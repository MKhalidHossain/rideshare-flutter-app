import 'dart:convert';
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../../core/constants/urls.dart';
import '../../../utils/app_constants.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final String appBaseUrln = Urls.baseUrl;

  final SharedPreferences sharedPreferences;

  static final String noInternetMessage = 'connection_to_api_server_failed'.tr;

  final int timeoutInSeconds = 30;

  late String _accessToken;


  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    _accessToken = sharedPreferences.getString(AppConstants.accessToken) ?? '';
    if (kDebugMode) {
      print('Token: $_accessToken');
    }
    updateHeader(_accessToken);
  }

  Map<String, String> getHeader(){
    _accessToken = sharedPreferences.getString(AppConstants.accessToken) ?? '';
     Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_accessToken',
    };
    return header;
  }

  void updateHeader(String token) {
    // Map<String, String> header = {
    //   'Content-Type': 'application/json; charset=UTF-8',
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer $token',
    // };

    print(
      'User Token ${token.toString()} ================================== from api Client ',
    );
    _accessToken = token;

    print('New header: from api client : _token || updateedToken : $_accessToken');
  }

  Future<Response> getData(
    String uri, {
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('====> API Call: $uri\nHeader: $getHeader()');
      }
      http.Response response = await http
          .get(Uri.parse(appBaseUrln + uri), headers: headers ??  getHeader())
          .timeout(Duration(seconds: timeoutInSeconds));
      debugPrint('====> API Response: ${response.statusCode} - $uri');
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      print('====> API Body: $body');

      if (kDebugMode) {

        log('====> API Body: ${body}');
      }
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrln + uri),
            body: jsonEncode(body),
            headers: headers ?? getHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      print("$e---------------------------------------");

      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartFormData(
    String uri, {
    required Map<String, dynamic> fields,
    required List<XFile> photos,
    Map<String, String>? headers,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(appBaseUrln + uri));

      // ✅ Remove Content-Type (multipart will set it automatically)
      var requestHeaders = Map<String, String>.from(headers ?? getHeader());
      requestHeaders.remove('Content-Type');
      request.headers.addAll(requestHeaders);

      // ✅ Add fields (stringify JSON lists/maps)
      fields.forEach((key, value) {
        if (value != null) {
          if (value is List || value is Map) {
            request.fields[key] = jsonEncode(value);
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // ✅ Add photos
      for (var file in photos) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photos', // must match backend field
            file.path,
            filename: file.name,
          ),
        );
      }

      // ✅ Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return handleResponse(response, uri);
    } catch (e) {
      print("Error in postMultipartFormData: $e");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  //
  // patch Data
  //
  Future<Response> patchData(
    String uri,
    dynamic body, {

    Map<String, String>? headers,
    XFile? file,
    String fileFieldName = 'profileImage',
  }) async {
    try {
      if (kDebugMode) {
        log('====> API Call (PATCH): $appBaseUrln$uri\nHeader: $getHeader()');
        log('====> API Body: $body');
      }

      // If we have a file to upload, use multipart request
      if (file != null) {
        var request = http.MultipartRequest(
          'PATCH',
          Uri.parse(appBaseUrln + uri),
        );

        // Add headers (remove Content-Type for multipart request)
        var requestHeaders = Map<String, String>.from(headers ?? getHeader());
        requestHeaders.remove('Content-Type');
        request.headers.addAll(requestHeaders);

        // Add file
        request.files.add(
          await http.MultipartFile.fromPath(
            fileFieldName,
            file.path,
            filename: file.name,
          ),
        );

        // Add other fields if body is a Map
        if (body is Map) {
          body.forEach((key, value) {
            if (value != null) {
              request.fields[key] = value.toString();
            }
          });
        }

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        return handleResponse(response, uri);
      }
      // Otherwise use regular PATCH with JSON
      else {
        http.Response response = await http
            .patch(
              Uri.parse(appBaseUrln + uri),
              body: jsonEncode(body),
              headers: headers ?? getHeader(),
            )
            .timeout(Duration(seconds: timeoutInSeconds));
        return handleResponse(response, uri);
      }
    } catch (e) {
      print('Error in patchData: $e');
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> patchMultipartData(
    String uri, {
    Map<String, String>? fields,
    Map<String, XFile>? files,
    Map<String, String>? headers,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse(appBaseUrln + uri),
      );

      // Add default headers
      request.headers.addAll(headers ?? getHeader());

      // Add fields (text data)
      if (fields != null) {
        request.fields.addAll(fields);
      }

      // Add files (images, documents, etc.)
      if (files != null) {
        for (var entry in files.entries) {
          var file = await http.MultipartFile.fromPath(
            entry.key,
            entry.value.path,
            filename: entry.value.name,
          );
          request.files.add(file);
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postMultipartData(
    String uri, {
    required Map<String, dynamic> body,
    required List<XFile> photos,
    Map<String, String>? headers,
  }) async {
    debugPrint("photos >>>> ${photos.length}");
    debugPrint("availability >>>> ${body['availability']}");
    for (final photo in photos) {
      debugPrint("photo >>>> ${photo.path}");
    }
    try {
      String apiUrl = Urls.baseUrl + uri;

      if (kDebugMode) {
        log(
          'API Call: $apiUrl\nHeaders: ${headers ?? getHeader()}\nBody: $body',
        );
      }

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add headers
      var requestHeaders = Map<String, String>.from(headers ?? getHeader());
      requestHeaders.remove('Content-Type');
      request.headers.addAll(requestHeaders);

      // Remove 'avatar' key from body before sending
      // Map<String, String> filteredBody = body.map(
      //   (key, value) => MapEntry(key, value.toString()),
      // );

      // Map<String, String> filteredBody = body.map((key, value) {
      //   if (value is List || value is Map) {
      //     debugPrint("availability in api -> ${jsonEncode(value)}");
      //     return MapEntry(key, jsonEncode(value));
      //   } else {
      //     return MapEntry(key, value.toString());
      //   }
      // });

      Map<String, String> filteredBody = {};
      body.forEach((key, value) {
        if (value is List && key != 'photos') {
          // encode only nested lists/maps, not the top-level array
          filteredBody[key] = jsonEncode(value);
        } else if (value is Map) {
          filteredBody[key] = jsonEncode(value);
        } else {
          filteredBody[key] = value.toString();
        }
      });
      filteredBody.remove('photos');
      request.fields.addAll(filteredBody);

      // Handle profile image upload
      if (photos.isNotEmpty) {
        for (var file in photos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'photos', // or 'photos' depending on backend
              file.path,
              filename: file.name,
            ),
          );
        }
      }

      debugPrint("request >>>> ${request.files.length}");
      if (kDebugMode) {
        log(
          'API Call: $apiUrl\nHeaders: ${headers ?? getHeader()}\nBody: $body',
        );
      }
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log full response
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 500) {
        throw Exception("Server error: ${response.body}");
      }

      return handleResponse(response, apiUrl);
    } catch (e) {
      print('Error in Multipart Request:: $e');
      return Response(
        statusCode: 3000,
        statusText: "Failed to update profile. Server error.{}",
      );
    }
  }

  Future<Response> postMultipartDataBug(
    String uri,
    Map<String, String> body,
    MultipartBody? image, {
    Map<String, String>? headers,
  }) async {
    try {
      String apiUrl = "https://";

      if (kDebugMode) {
        log(
          'API Call: $appBaseUrln+$uri\nHeaders: ${headers ?? getHeader()}\nBody: $body',
        );
      }

      var request = http.MultipartRequest('POST', Uri.parse(appBaseUrln + uri));

      // Add headers
      request.headers.addAll(headers ?? getHeader());

      // Remove 'avatar' key from body before sending
      Map<String, String> filteredBody = Map.from(body);
      filteredBody.remove('image');
      request.fields.addAll(filteredBody);

      // Handle profile image upload
      if (image != null && image.file != null) {
        var file = image.file!;
        request.files.add(
          http.MultipartFile(
            'commanderImage', // This must match the backend field name
            file.readAsBytes().asStream(),
            await file.length(),
            filename: file.path.split('/').last, // Extract filename from path
          ),
        );
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Log full response
      log('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 500) {
        throw Exception("Server error: ${response.body}");
      }

      return handleResponse(response, apiUrl);
    } catch (e) {
      print('Error: $e');
      return Response(
        statusCode: 3000,
        statusText: "Failed to update profile. Server error.",
      );
    }
  }

  Future<Response> postMultipartDataConversation(
    String? uri,
    Map<String, String> body,
    List<MultipartBody>? multipartBody, {
    Map<String, String>? headers,
    PlatformFile? otherFile,
  }) async {
    http.MultipartRequest request = http.MultipartRequest(
      'POST',
      Uri.parse(appBaseUrl + uri!),
    );
    request.headers.addAll(headers ?? getHeader());

    if (otherFile != null) {
      request.files.add(
        http.MultipartFile(
          'files[${multipartBody!.length}]',
          otherFile.readStream!,
          otherFile.size,
          filename: basename(otherFile.name),
        ),
      );
    }
    if (multipartBody != null) {
      for (MultipartBody multipart in multipartBody) {
        Uint8List list = await multipart.file!.readAsBytes();
        request.files.add(
          http.MultipartFile(
            multipart.key,
            multipart.file!.readAsBytes().asStream(),
            list.length,
            filename: '${DateTime.now().toString()}.png',
          ),
        );
      }
    }
    request.fields.addAll(body);
    http.Response response = await http.Response.fromStream(
      await request.send(),
    );
    return handleResponse(response, uri);
  }

  Future<Response> putData(
    String uri,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        log('====> API Call: $uri\nHeader: $getHeader()');
        log('====> API Body: $body');
      }
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrln + uri),
            body: jsonEncode(body),
            headers: headers ?? getHeader(),
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(
    String uri, {
    Map<String, String>? headers,
  }) async {
    try {
      if (kDebugMode) {
        log('====> API Call: $uri\nHeader: $getHeader()');
      }
      http.Response response = await http
          .delete(Uri.parse(appBaseUrl + uri), headers: headers ?? getHeader())
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic body;

    try {
      body = jsonDecode(response.body);
      debugPrint('Not Any Error in Response');
      // print('no fuck you');
      print(response.body.toString());
    } catch (e) {
      print(e.toString() + 'Error has occuredin Response');
    }
    Response localResponse = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      //request: http.Request(headers: response.request!.headers, method: response.request!.method, url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (kDebugMode) {
      // log('====> API Response: [${localResponse.statusCode}] $uri\n${localResponse.body} ==========');
    }
    // log('====> API Response: [${localResponse.statusCode}] $uri\n${localResponse.body} ==========');
    return localResponse;
  }
}

class MultipartBody {
  String key;
  XFile? file;
  MultipartBody(this.key, this.file);
}

class MultipartDocument {
  String key;
  PlatformFile? file;
  MultipartDocument(this.key, this.file);
}
