import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/controller/hover_controller.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/dialogs/loading_dialog.dart';

class AppUtils {
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';

    final random = math.Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  static putAllControllers() {
    Get.put(HomeController(), permanent: true);
    Get.put(HoverController(), permanent: true);
    // Get.put(ProjectController(), permanent: true);
    // Get.put(MessageController(), permanent: true);
  }

  static removeAllControllers() {
    Get.delete<HoverController>(force: true);

    // Get.delete<ProjectController>(force: true);
    // Get.delete<MessageController>(force: true);
  }

  String dateBuilder(DateTime date) {
    ///if date is today return time else return yesterday and up to 6 days ago
    if (DateTime.now().day == date.day) {
      String hour = date.hour > 12
          ? (date.hour - 12).toString().padLeft(2, '0')
          : date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      String period = date.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } else if (DateTime.now().day - date.day == 1) {
      return 'Yesterday';
    } else if (DateTime.now().day - date.day < 7) {
      return '${DateTime.now().day - date.day} days ago';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }

  String timeOfDayToString(TimeOfDay time) {
    final hour = time.hourOfPeriod.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

Future<T?> callFutureFunctionWithLoadingOverlay<T>({
  required Future<T> Function() asyncFunction,
  bool showOverLay = true,
}) async {
  T? result;
  if (!showOverLay) {
    try {
      result = await asyncFunction();
    } catch (e) {
      log(e.toString());
      showErrorDialog(e.toString());
    }
    return result;
  } else {
    await Get.showOverlay(
      asyncFunction: () async {
        try {
          result = await asyncFunction();
        } catch (e) {
          log(e.toString());
          showErrorDialog(e.toString());
        }
      },
      loadingWidget: const LoadingDialog(
        message: 'Please wait...',
      ),
    );
    return result;
  }
}
