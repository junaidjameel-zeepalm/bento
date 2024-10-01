import 'package:bento/app/modules/auth/component/auth_txtField_wiget.dart';
import 'package:bento/app/repo/auth_repo.dart';
import 'package:flutter/material.dart';

class ChangeEmailDialog extends StatelessWidget {
  ChangeEmailDialog({super.key});
  final TextEditingController _newEmailCon = TextEditingController();
  final TextEditingController _currentPasswordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onEmailChange() {
      AuthRepo().changeEmail(
          _newEmailCon.text.trim(), _currentPasswordCon.text.trim(), context);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AuthTxtFieldWidget(controller: _newEmailCon, labelText: 'New Email'),
          const SizedBox(height: 20),
          AuthTxtFieldWidget(
              controller: _currentPasswordCon,
              labelText: 'Your Current Password'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onEmailChange,
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
              child: Text('Change', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
