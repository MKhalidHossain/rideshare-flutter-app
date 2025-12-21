import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}


void showCustomSnackBar(
  String message, {
  bool isError = true,
  int seconds = 2,
  String? subMessage,
}) {
  final overlayContext = Get.overlayContext;
  final overlay = overlayContext != null ? Overlay.maybeOf(overlayContext) : null;
  final messageWidget = _SnackBarBody(
    message: message,
    subMessage: subMessage,
    isError: isError,
  );

  if (overlay != null) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(
      GetSnackBar(
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(10).copyWith(right: 10),
        duration: Duration(seconds: seconds),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.white,
        borderRadius: 10,
        messageText: messageWidget,
      ),
    );
    return;
  }

  final context = Get.context ?? Get.key.currentContext;
  final messenger = context != null ? ScaffoldMessenger.maybeOf(context) : null;
  if (messenger == null) {
    customPrint('Snackbar skipped (no context available): $message');
    return;
  }

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: seconds),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
        content: messageWidget,
      ),
    );
}

class _SnackBarBody extends StatelessWidget {
  final String message;
  final String? subMessage;
  final bool isError;

  const _SnackBarBody({
    required this.message,
    this.subMessage,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final Color textColor = isError ? Colors.red.shade700 : Colors.black;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              if (subMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  subMessage!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
