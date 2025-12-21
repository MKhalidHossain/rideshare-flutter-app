import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/map/presentation/screens/ride_confirmed_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/domain/reponse_model/get_search_destination_for_find_Nearest_drivers_response_model.dart';
import '../../map/domain/models/driver.dart';

class PaymentWebViewScreen extends StatefulWidget {
 final NearestDriverData? selectedDriver;
  final String paymentUrl;
  final String? sessionId;

  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.selectedDriver,
    this.sessionId,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0;
  bool _handledResult = false;

  static const String _successKey = 'payment-success';
  static const String _cancelKey = 'payment-cancel';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onPageStarted: (_) {
            setState(() => _progress = 0);
          },
          onPageFinished: (url) {
            setState(() => _progress = 1);
            _handleUrlIfNeeded(url);
          },
          onNavigationRequest: (request) {
            _handleUrlIfNeeded(request.url);
            if (_shouldIntercept(request.url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            final message = error.description.isNotEmpty
                ? error.description
                : 'Something went wrong while loading the payment page.';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  bool _shouldIntercept(String url) {
    final lower = url.toLowerCase();
    return lower.contains(_successKey) || lower.contains(_cancelKey);
  }

  void _handleUrlIfNeeded(String url) {
    if (_handledResult) return;
    final lower = url.toLowerCase();
    if (lower.contains(_successKey)) {
      _handledResult = true;
      Get.back(result: true);
      return;
    }
    if (lower.contains(_cancelKey)) {
      _handledResult = true;
      Get.back(result: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed: () =>   Get.to(
        () => RideConfirmedScreen(
          selectedDriver: widget.selectedDriver,
        ),
            )
          ),
        
        
        title: const Text('Complete Payment'),
        actions: [
          
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.reload,
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Get.to(
        () => RideConfirmedScreen(
          selectedDriver: widget.selectedDriver,
        ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progress < 1)
            LinearProgressIndicator(value: _progress == 0 ? null : _progress),
        ],
      ),
    );
  }
}
