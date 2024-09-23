import 'package:bento/app/data/constant/data.dart';
import 'package:bento/app/services/auth_wrapper.dart';
import 'package:bento/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);

    return GetMaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        useInheritedMediaQuery: true,
        title: 'Bento',
        debugShowCheckedModeBanner: false,
        scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
        theme: AppTheme.lightTheme,
        //theme: AppTheme.darkTheme,
        home: AuthWrapper());
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); //

