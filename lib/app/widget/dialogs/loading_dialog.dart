import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog extends StatefulWidget {
  const LoadingDialog({super.key, required this.message});
  final String message;

  @override
  LoadingDialogState createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Colors.transparent, // Dark background for dialog
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        content: SizedBox(
          width: 250,
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(0),
                      _buildDot(0.3),
                      _buildDot(0.6),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(double delay) {
    return FadeTransition(
      opacity: Tween(begin: 0.4, end: 2.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(delay, 1.0, curve: Curves.easeInCirc),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Icon(
          Icons.circle,
          color: Colors.amber, // White dot
          size: 40,
        ),
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
  return Get.dialog(
    ErrorDialog(message: message),
    barrierDismissible: false,
  );
}

Future<void> showLoadingDialog({required String message}) {
  return Get.dialog(
    LoadingDialog(message: message),
    barrierDismissible: false,
    barrierColor:
        Colors.black.withOpacity(0.5), // Dark background for the entire screen
  );
}

void hideLoadingDialog() {
  return Get.back();
}
