import 'package:bento/app/controller/home_controller.dart';
import 'package:bento/app/modules/auth/login.dart';
import 'package:bento/app/modules/home/home.dart';
import 'package:bento/app/widget/dialogs/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});
  final ac = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ac.user == null) {
        return SignInView();
      } else {
        _registerUserController();
        final uc = Get.find<UserController>();
        if (uc.user == null) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(.6),
            body: const Center(
                child: LoadingDialog(
              message: '',
            )),
          );
        }

        return const BentoHomePage();
      }
    });
  }

  void _registerUserController() {
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController(), permanent: true);
    }
  }
}
