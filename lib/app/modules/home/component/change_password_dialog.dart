import 'package:bento/app/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bento/app/modules/auth/component/auth_txtField_wiget.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  ChangePasswordDialogState createState() => ChangePasswordDialogState();
}

class ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final AuthRepo _authRepo = AuthRepo();

  Future<void> _onChangePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    await _authRepo.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AuthTxtFieldWidget(
            controller: _oldPasswordController,
            labelText: 'Old Password',
            obscureText: true,
          ),
          const SizedBox(height: 20),
          AuthTxtFieldWidget(
            controller: _newPasswordController,
            labelText: 'New Password',
            obscureText: true,
          ),

          
          
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _onChangePassword,
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
              child: Text('Save Password', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
