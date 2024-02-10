import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/theme/theme_helper.dart'; // Assuming this exists for theming

class CustomTextFieldLogin extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final InputDecoration decoration;
  final IconData icons;
  final bool isPasswordTextField;

  const CustomTextFieldLogin({
    Key? key,
    required this.controller,
    this.validator,
    required this.keyboardType,
    required this.hintText,
    required this.labelText,
    required this.decoration,
    required this.icons,
    required this.isPasswordTextField,
  }) : super(key: key);

  @override
  _CustomTextFieldLoginState createState() => _CustomTextFieldLoginState();
}

class _CustomTextFieldLoginState extends State<CustomTextFieldLogin> {
  late bool showPassword;

  @override
  void initState() {
    super.initState();
    showPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPasswordTextField ? !showPassword : false,
      decoration: widget.decoration.copyWith(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: Icon(widget.icons),
        suffixIcon: widget.isPasswordTextField
            ? IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.black45,
              width: 2.0), // Border color when TextField is focused
          borderRadius: BorderRadius.circular(25.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.red,
              width: 2.0), // Border color when TextField has error
          borderRadius: BorderRadius.circular(25.0),
        ),
        hintStyle: TextStyle(
          color: Colors.blueGrey,
          fontSize: 14,
          fontFamily: 'Outfit',
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: appTheme.gray700, // Label text color when not focused
          fontSize: 14,
        ),
        floatingLabelStyle: TextStyle(
          color: appTheme.green_primary, // Label text color when focused
          fontSize: 18,
        ),
      ),
    );
  }
}
