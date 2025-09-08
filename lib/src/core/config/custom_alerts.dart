import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlerts {
  // Reusable success alert
  static void showSuccessAlert(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }

  // Reusable error alert
  static void showErrorAlert(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  // Reusable info alert
  static void showInfoAlert(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // Confirmation alert dialog
  static Future<bool?> showConfirmationAlert(String title, String message) async {
    return await Get.defaultDialog(
      title: title,
      middleText: message,
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      middleTextStyle: const TextStyle(fontSize: 16),
      radius: 10,
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.white,
      onCancel: () => Get.back(result: false),
      onConfirm: () => Get.back(result: true),
      buttonColor: Colors.red,
    );
  }
}
