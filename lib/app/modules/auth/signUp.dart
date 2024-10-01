import 'package:bento/app/data/constant/app_typography.dart';
import 'package:bento/app/data/constant/data.dart';
import 'package:bento/app/modules/auth/component/auth_txtField_wiget.dart';
import 'package:bento/app/modules/auth/component/carousal_slider_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../controller/auth_controller.dart';
import '../../repo/auth_repo.dart';

class SignUpView extends StatelessWidget {
  SignUpView({super.key});

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  AuthController get ac => Get.find<AuthController>();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signUp(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final name = _nameController.text;
      await AuthRepo().signUp(
        userName: name,
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Row(
          children: [
            if (!isMobile)
              Expanded(
                child:
                    Lottie.asset('assets/lottie/signUp.json', reverse: false),
              ),
            Expanded(child: _buildSignUpCard(screenSize, context)),
          ],
        );
      }),
    );
  }

  Center _buildSignUpCard(Size screenSize, BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: screenSize.width > 600 ? 400 : screenSize.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create an account',
                  style: GoogleFonts.kanit(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                AuthTxtFieldWidget(
                  controller: _nameController,
                  labelText: 'Name',
                ),
                const SizedBox(height: 20),
                //   _buildEmailField(),
                AuthTxtFieldWidget(
                  controller: _emailController,
                  labelText: 'Email',
                ),
                const SizedBox(height: 16),
                AuthTxtFieldWidget(
                  controller: _passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                        style:
                            TextStyle(color: Colors.grey[700], fontSize: 16)),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text('Sign In',
                          style: AppTypography.kSemiBold16
                              .copyWith(color: AppColors.kBlack, fontSize: 17)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _signUp(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red[400],
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('Sign Up', style: AppTypography.kSemiBold16),
                  ),
                ),
                const SizedBox(height: 30),
                _loginWithGoogleButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWithGoogleButton({bool isActive = false}) {
    return SizedBox(
      height: 50,
      width: Get.width,
      child: ElevatedButton(
        onPressed: () => AuthRepo().signInWithGoogle(isFromSignIn: false),
        style: ElevatedButton.styleFrom(
          foregroundColor: isActive ? Colors.black : Colors.black,
          backgroundColor: isActive ? Colors.white : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isActive ? 5 : 1,
          side: BorderSide(
              color: isActive ? Colors.transparent : Colors.grey[400]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/google.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 8),
            const Text('Sign up with Google'),
          ],
        ),
      ),
    );
  }
}
