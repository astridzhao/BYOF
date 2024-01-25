import 'dart:io';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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
    //Testing:
    // print('build: Image file name is ${widget.imagefilePath}');

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
      child: buildImage(),
    );
  }

  Widget buildImage() {
    // Check if the image path starts with 'assets/'
    if (widget.imagefilePath.startsWith('assets/')) {
      // If it's an asset, display it directly
      return ClipOval(
        child: Image.asset(
          widget.imagefilePath,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // If it's not an asset, check if the file exists
      return FutureBuilder<File>(
        future: getFile(widget.imagefilePath),
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.existsSync()) {
              // Testing: If the file exists, display it

              // print('File exists: ${snapshot.data}');
              return ClipOval(
                child: Image.file(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              );
            } else {
              // Testing: If the file doesn't exist, display a default image
              // print('File does not exists');
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
      );
    }
  }

  Future<File> getFile(String imageName) async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    return File(path.join(documentDirectory.path, imageName));
  }
}
