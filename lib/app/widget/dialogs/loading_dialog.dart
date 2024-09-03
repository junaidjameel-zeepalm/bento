import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: SizedBox(
            width: 250,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 20),
                Text(
                  message,
                )
              ],
            )),
      ),
    );
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      elevation: 0,
      title: const Center(child: Text('Error')),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Ok',
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
  }
}

Future<void> showErrorDialog(String message) {
  return Get.dialog(ErrorDialog(message: message));
}

Future<void> showLoadingDialog({required String message}) {
  return Get.dialog(LoadingDialog(message: message), barrierDismissible: false);
}

void hideLoadingDialog() {
  return Get.back();
}
