import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class FiberlistItemWidget extends StatefulWidget {
  final ingredient;

  const FiberlistItemWidget({
    Key? key,
    required this.ingredient,
  }) : super(key: key);

  @override
  _FiberlistItemWidgetState createState() => _FiberlistItemWidgetState();
}

class _FiberlistItemWidgetState extends State<FiberlistItemWidget> {
  // Any state variables you need go here
  TextEditingController foodcontroller = TextEditingController();
  TextEditingController countcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.all(1.h),
      decoration: AppDecoration.fillPurple.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(widget.ingredient),
          ),
          Expanded(
            child: TextField(
              controller: countcontroller,
              decoration: InputDecoration(
                isDense: true, // Important to reduce space
                contentPadding: EdgeInsets.symmetric(vertical: 4.h),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 10.fSize),
            ),
          ),
        ],
      ),
    );
  }
}
