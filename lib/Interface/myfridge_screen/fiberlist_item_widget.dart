import 'dart:developer';

import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FiberlistItemWidget extends StatefulWidget {
  final ingredient;
  final int quantity;
  final VoidCallback onDelete;
  final Function(String, int) onQuantityChanged;

  const FiberlistItemWidget({
    Key? key,
    this.quantity = 0,
    required this.ingredient,
    required this.onDelete,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  _FiberlistItemWidgetState createState() => _FiberlistItemWidgetState();
}

class _FiberlistItemWidgetState extends State<FiberlistItemWidget> {
  // Any state variables you need go here
  late TextEditingController foodcontroller;
  late TextEditingController countcontroller;

  @override
  void initState() {
    super.initState();
    foodcontroller = TextEditingController();
    countcontroller = TextEditingController(text: widget.quantity.toString());
    log("FiberlistItemWidget: " + widget.ingredient + " " + widget.quantity.toString());
  }

  // @override
  // void dispose() {
  //   countcontroller.dispose();
  //   foodcontroller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      padding: EdgeInsets.all(1.h),
      decoration: AppDecoration.fillLightGreen.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 20.h),
          Expanded(
            child: Text(
              widget.ingredient,
              style: TextStyle(fontSize: 14.fSize, fontFamily: "Outfit"),
            ),
          ),
          Text(
            "Quatity",
            style: TextStyle(fontSize: 10.fSize, fontFamily: "Outfit"),
          ),
          SizedBox(width: 10.h),
          Expanded(
              child: TextField(
                  controller: countcontroller,
                  decoration: InputDecoration(
                    isDense: true, // Important to reduce space
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.v, horizontal: 1.h),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  style: TextStyle(fontSize: 14.fSize),
                  //handle the input format
                  keyboardType: TextInputType.number, // Ensure numeric keyboard
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  onChanged: (value) {
                    int newQuantity = int.tryParse(value) ?? 0;
                    widget.onQuantityChanged(
                        widget.ingredient, newQuantity); // Invoke the callback
                  })),
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
