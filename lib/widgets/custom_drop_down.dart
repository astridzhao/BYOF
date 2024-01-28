import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  // final GlobalKey<_CustomDropDownState> dropDownKey;
  CustomDropDown({
    Key? key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    this.items,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.initialValue,
    // required this.dropDownKey,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final FocusNode? focusNode;

  final Widget? icon;

  final bool? autofocus;

  final TextStyle? textStyle;

  final List<String>? items;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  final String? initialValue;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.centerLeft,
            child: dropDownWidget,
          )
        : dropDownWidget;
  }

  Widget get dropDownWidget => SizedBox(
        width: widget.width ?? double.maxFinite,
        child: DropdownButtonFormField(
          focusNode: widget.focusNode ?? FocusNode(),
          icon: widget.icon,
          autofocus: widget.autofocus!,
          style: widget.textStyle,
          items: widget.items?.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              // key: widget.dropDownKey,
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: widget.hintStyle,
              ),
            );
          }).toList(),
          decoration: decoration,
          validator: widget.validator,
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
            if (newValue != null && widget.onChanged != null) {
              widget.onChanged!(newValue);
            }
          },
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: widget.hintText ?? "",
        hintStyle: widget.hintStyle,
        prefixIcon: widget.prefix,
        prefixIconConstraints: widget.prefixConstraints,
        suffixIcon: widget.suffix,
        suffixIconConstraints: widget.suffixConstraints,
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 12,
            ),
        fillColor: widget.fillColor ??
            appTheme.yellow_secondary, // Change to your desired color
        filled: widget.filled,
        border: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.blue, // Change to your desired color
                width: 1,
              ),
            ),
        enabledBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: theme.colorScheme.onPrimaryContainer,
                width: 1,
              ),
            ),
        focusedBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.h),
              borderSide: BorderSide(
                color: theme.colorScheme.onPrimaryContainer,
                width: 1,
              ),
            ),
      );
}
