import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';

class GenerationScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            tooltip: 'Back to home page',
            color: Colors.blueGrey,
            splashColor: appTheme.orange_primary,
            onPressed: () {
              Navigator.of(context)
                  .pop(MaterialPageRoute(builder: (context) => CreateScreen()));
            },
          ),
        ),
        body: Center(
            child: Container(
                child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.72,
                width: 316.h,
                decoration: BoxDecoration(
                    color: appTheme.yellow50,
                    borderRadius: BorderRadius.circular(10.h),
                    border: Border.all(color: appTheme.gray700, width: 1.h))),
          ],
        ))),
      ),
    );
  }
}
