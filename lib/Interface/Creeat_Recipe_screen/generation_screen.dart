import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
// import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

class GenerationScreen extends StatefulWidget {
  final String resultCompletion;

  GenerationScreen({Key? key, required this.resultCompletion})
      : super(key: key);

  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  @override
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
        body: SizedBox.expand(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.64,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                width: 316.h,
                decoration: BoxDecoration(
                    color: appTheme.yellow50,
                    borderRadius: BorderRadius.circular(10.h),
                    border: Border.all(color: appTheme.gray700, width: 1.h)),
                child: SingleChildScrollView(
                  child: Text(widget.resultCompletion),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ButtonBar(
          children: [
            TabBar(
              indicatorPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
              indicator: UnderlineTabIndicator(
                  insets: EdgeInsets.fromLTRB(16, 0, 16, 8)),
              tabs: [
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                      child: Icon(
                    Icons.home,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                      child: Icon(
                    Icons.search,
                  )),
                ),
                SizedBox(
                  height: 55,
                  width: 40,
                  child: Center(
                      child: Icon(
                    Icons.add,
                  )),
                ),
              ],
            ),
          ],
          
        ),
      ),
    );
  }
}
