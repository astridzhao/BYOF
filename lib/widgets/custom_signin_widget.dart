import 'package:astridzhao_s_food_app/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class CustomTextFieldLogin extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final InputDecoration decoration;
  final IconData icons;

  const CustomTextFieldLogin({
    Key? key,
    required this.controller,
    this.validator,
    required this.keyboardType,
    required this.hintText,
    required this.labelText,
    required this.decoration,
    required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration: decoration.copyWith(
        // Use copyWith to allow overriding specific properties
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icons),

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

        // Other properties like border, fillColor, etc., can be predefined or customized here
      ),
    );
  }
}
