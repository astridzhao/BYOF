// import 'dart:io';
// import 'package:astridzhao_s_food_app/core/app_export.dart';
// import 'package:flutter/material.dart';

// class RecipecontentrowItemWidget extends StatefulWidget {
//   final String imagefilePath;

//   const RecipecontentrowItemWidget({
//     Key? key,
//     required this.imagefilePath,
//   }) : super(key: key);

//   @override
//   _RecipecontentrowItemWidgetState createState() =>
//       _RecipecontentrowItemWidgetState();
// }

// class _RecipecontentrowItemWidgetState
//     extends State<RecipecontentrowItemWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 64.adaptSize,
//       width: 64.adaptSize,
//       margin: EdgeInsets.only(
//         left: 14.h,
//         top: 2.v,
//       ),
//       padding: EdgeInsets.all(3.h),
//       decoration: AppDecoration.outlineGray.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder32,
//       ),
//       child: widget.imagefilePath != "assets/images/generate2.png"

//           ? Image.file(File(widget.imagefilePath))
//           : Image.asset(widget.imagefilePath),
//     );
//   }
// }

import 'dart:io';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';

class RecipecontentrowItemWidget extends StatefulWidget {
  final String imagefilePath;

  const RecipecontentrowItemWidget({
    Key? key,
    required this.imagefilePath,
  }) : super(key: key);

  @override
  _RecipecontentrowItemWidgetState createState() =>
      _RecipecontentrowItemWidgetState();
}

class _RecipecontentrowItemWidgetState
    extends State<RecipecontentrowItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.adaptSize,
      width: 64.adaptSize,
      margin: EdgeInsets.only(
        left: 14.h,
        top: 2.v,
      ),
      padding: EdgeInsets.all(2.h),
      decoration: AppDecoration.outlineGray.copyWith(
        borderRadius: BorderRadiusStyle.circleBorder32,
      ),
      child: FutureBuilder<bool>(
        future: _checkFileExists(widget.imagefilePath),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              // If the file exists, display it
              return ClipOval(
                child: Image.file(
                  File(widget.imagefilePath),
                  fit: BoxFit.cover,
                ),
              );
            } else {
              // If the file doesn't exist, display a default image
              return ClipOval(
                child: Image.asset(
                  "assets/images/generate2.png",
                  fit: BoxFit.cover,
                ),
              );
            }
          } else {
            // While checking, you can show a placeholder or a loading indicator
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> _checkFileExists(String path) async {
    if (path.startsWith('assets/')) {
      // Assuming asset paths start with 'assets/', no need to check file existence
      return true;
    } else {
      final file = File(path);
      return file.exists();
    }
  }
}
