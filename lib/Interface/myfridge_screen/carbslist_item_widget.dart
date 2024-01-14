import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:astridzhao_s_food_app/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

class CarblistItemWidget extends StatefulWidget {
  final ingredient;
  final VoidCallback onDelete;

  const CarblistItemWidget({
    Key? key,
    required this.ingredient,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CarblistItemWidgetState createState() => _CarblistItemWidgetState();
}

class _CarblistItemWidgetState extends State<CarblistItemWidget> {
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20),
          Expanded(
            child: Text(
              widget.ingredient,
              style: TextStyle(fontSize: 14.fSize, fontFamily: "Outfit"),
            ),
          ),
          // Expanded(
          //   child: Text(
          //     "Quatity",
          //     style: TextStyle(fontSize: 10.fSize ,fontFamily: "Outfit"),
          //   ),
          // ),
          Text(
            "Quatity",
            style: TextStyle(fontSize: 10.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: countcontroller,
              decoration: InputDecoration(
                isDense: true, // Important to reduce space
                contentPadding:
                    EdgeInsets.symmetric(vertical: 2.v, horizontal: 1.h),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
              style: TextStyle(fontSize: 14.fSize),
            ),
          ),
          Expanded(
              child: IconButton(
            icon: Icon(Icons.delete_sharp),
            onPressed: () {
              widget.onDelete();
            },
          )),
        ],
      ),
    );
  }
}
