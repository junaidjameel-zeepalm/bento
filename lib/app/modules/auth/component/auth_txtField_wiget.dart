import 'package:bento/app/data/constant/data.dart';
import 'package:flutter/material.dart';

class AuthTxtFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Icon? prefixIcon;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? enabledBorderColor;
  final String? Function(String?)? validator;

  const AuthTxtFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.textStyle,
    this.hintStyle,
    this.fillColor,
    this.focusedBorderColor,
    this.enabledBorderColor,
    this.validator,
  });

  @override
  _AuthTxtFieldWidgetState createState() => _AuthTxtFieldWidgetState();
}

class _AuthTxtFieldWidgetState extends State<AuthTxtFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: widget.textStyle ?? const TextStyle(color: Colors.black),
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.kBlack,
                  size: 20,
                ),
                onPressed: _toggleObscureText,
              )
            : null,
        filled: true,
        fillColor: widget.fillColor ?? Colors.blue.withOpacity(0.05),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor ?? Colors.blue[900]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.enabledBorderColor ?? Colors.grey[400]!,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      ),
      obscureText: _obscureText,
      validator: widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your ${widget.labelText}';
            }
            return null;
          },
    );
  }
}
