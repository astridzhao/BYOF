import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SavingSummeryWidget extends StatefulWidget {
  final String imagePath;
  final String title;
  final String unit;
  final double counter;

  const SavingSummeryWidget({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.unit,
    required this.counter,
  }) : super(key: key);

  @override
  SavingSummeryWidgetState createState() => SavingSummeryWidgetState();
}

class SavingSummeryWidgetState extends State<SavingSummeryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 27.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.fillGray.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      width: 128.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildText(widget.title, 12),
          SizedBox(height: 20.v),
          CustomImageView(
            imagePath: widget.imagePath,
            height: 72.adaptSize,
            width: 72.adaptSize,
            radius: BorderRadius.circular(
              36.h,
            ),
          ),
          SizedBox(height: 14.v),
          _buildUnitIndicator(),
        ],
      ),
    );
  }

  Widget _buildText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.onError.withOpacity(1),
        fontSize: fontSize.fSize,
        fontFamily: 'Outfit',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildUnitIndicator() {
    return _buildText("${widget.counter} ${widget.unit}", 14);
  }
}
