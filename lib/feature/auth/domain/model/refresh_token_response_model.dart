class RefreshTokenResponseModel {
	bool? success;
	String? message;
	List<ErrorSources>? errorSources;
	Err? err;
	int? stack;

	RefreshTokenResponseModel({this.success, this.message, this.errorSources, this.err, this.stack});

	RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
		success = json['success'];
		message = json['message'];
		if (json['errorSources'] != null) {
			errorSources = <ErrorSources>[];
			json['errorSources'].forEach((v) { errorSources!.add(new ErrorSources.fromJson(v)); });
		}
		err = json['err'] != null ? new Err.fromJson(json['err']) : null;
		stack = json['stack'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['success'] = this.success;
		data['message'] = this.message;
		if (this.errorSources != null) {
      data['errorSources'] = this.errorSources!.map((v) => v.toJson()).toList();
    }
		if (this.err != null) {
      data['err'] = this.err!.toJson();
    }
		data['stack'] = this.stack;
		return data;
	}
}

class ErrorSources {
	String? path;
	String? message;

	ErrorSources({this.path, this.message});

	ErrorSources.fromJson(Map<String, dynamic> json) {
		path = json['path'];
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['path'] = this.path;
		data['message'] = this.message;
		return data;
	}
}

class Err {


	Err();

	Err.fromJson(Map<String, dynamic> json) {
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		return data;
	}
}
