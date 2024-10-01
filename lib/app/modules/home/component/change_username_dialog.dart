import 'package:bento/app/modules/auth/component/auth_txtField_wiget.dart';
import 'package:bento/app/repo/widget_repo.dart';
import 'package:flutter/material.dart';

class ChangeUsernameDialog extends StatelessWidget {
  ChangeUsernameDialog({super.key});
  final TextEditingController _newUserNameCon = TextEditingController();

  void _onChangePassword() {
    WidgetRepo().changeUserName(_newUserNameCon.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AuthTxtFieldWidget(
              controller: _newUserNameCon, labelText: 'New UserName'),
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
              child: Text('Save', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
