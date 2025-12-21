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
  int seconds = 3,
  String? subMessage,
}) {
  Get.closeCurrentSnackbar();
  Get.showSnackbar(
    GetSnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.all(10).copyWith(right: 18),
      duration: Duration(seconds: seconds),
      backgroundColor:
          Get.isDarkMode
              ? Colors.grey.shade800
              : Theme.of(Get.context!).textTheme.titleMedium!.color!,
      borderRadius: 10,
      messageText: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  subMessage != null
                      ? Text(
                        subMessage,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
