import 'package:bento/app/modules/auth/login.dart';
import 'package:bento/app/modules/home/home.dart';
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const BentoHomePage();
        // CustomBottomNavBar();

        // return CustomBottomBar();
        // // Scaffold(
        // //     body: Center(
        // //         child: SizedBox(
        // //   width: 200,
        // //   height: 200,
        // //   child: Column(
        // //     children: [
        // //       Text('Welcome ${uc.user!.name}'),
        // //       Text("App Keys ${AppKeys.spoonacularApiKey}"),
        // //       ElevatedButton(
        // //         onPressed: () {
        // //           AuthService().signOut();
        // //         },
        // //         child: const Text('Sign Out'),
        // //       ),
        // //     ],
        // //   ),
        // )));
        // const LandingPage();
      }
    });
  }

  void _registerUserController() {
    if (!Get.isRegistered<UserController>()) {
      Get.put(UserController(), permanent: true);
    }
  }
}
