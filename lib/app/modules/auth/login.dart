import 'package:bento/app/modules/auth/signUp.dart';
import 'package:bento/app/repo/auth_repo.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class SignInView extends StatelessWidget {
  SignInView({super.key});

  // Controllers for form fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signIn(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle sign-in logic here
      final email = _emailController.text;
      final password = _passwordController.text;
      AuthRepo()
          .signIn(userName: 'testing user', email: email, password: password);
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
                  child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Lottie.asset('assets/lottie/signIn lottie.json'),
                ),
              )),
            Expanded(
              child: _buildLoginCard(screenSize, context),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLoginCard(Size screenSize, BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: screenSize.width > 600 ? 450 : screenSize.width * 0.9,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            // boxShadow: const [
            //   BoxShadow(
            //     color: Colors.black12,
            //     spreadRadius: 3,
            //     blurRadius: 8,
            //     offset: Offset(0, 4),
            //   ),
            // ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Sign In',
                  style: GoogleFonts.kanit(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 23, 72, 112),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 5,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // const SizedBox(height: 16),
                // _loginWithGoogleButton(image: 'assets/google.png'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: TextStyle(color: Colors.grey[700])),
                    TextButton(
                      onPressed: () async {
                        Get.to(() => SignUpView());
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _loginWithGoogleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: _emailController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Email',
        hoverColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]!),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        prefixIcon: const Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        prefixIcon: const Icon(Icons.lock),
        hoverColor: Colors.black,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]!),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}

Widget _loginWithGoogleButton({bool isActive = false}) {
  return SizedBox(
    height: 50,
    width: Get.width,
    child: ElevatedButton(
      onPressed: () => AuthRepo().signInWithGoogle(),
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
          const Text('Sign in with Google'),
        ],
      ),
    ),
  );
}
