import 'package:astridzhao_s_food_app/Interface/Creeat_Recipe_screen/create_screen.dart';
import 'package:flutter/material.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:clipboard/clipboard.dart';

class GenerationScreen extends StatefulWidget {
  final String resultCompletion;

  GenerationScreen({Key? key, required this.resultCompletion})
      : super(key: key);

  @override
  _GenerationScreenState createState() => _GenerationScreenState();
}

class _GenerationScreenState extends State<GenerationScreen> {
  IconData copyIcon = Icons.content_copy_rounded;
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
            Container(
              margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.70,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            OverflowBar(
              // Adds spacing between each button
              overflowSpacing: 8.0, // Spacing after overflow
              alignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(copyIcon),
                  tooltip: "Copy",
                  onPressed: () {
                    FlutterClipboard.copy(widget.resultCompletion)
                        .then((value) => {Tooltip: "copied"});
                  },
                ),
                IconButton(
                    icon: Icon(Icons.share),
                    tooltip: "Share",
                    onPressed: () {}),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 30.0,
                      right: 10), // Adds padding around the TextButton
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: appTheme.green_primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0), // Button internal padding
                    ),
                    onPressed: () {},
                    icon: Icon(Icons.favorite_border_outlined),
                    label: Text(
                      "Add to My Favorite",
                      style: TextStyle(
                        fontFamily: "Outfit",
                      ),
                    ),
                  ),
                ),
                // TextButton.icon(
                //     style: TextButton.styleFrom(
                //       backgroundColor: appTheme.green_primary,
                //       foregroundColor: Colors.white,
                //     ),
                //     onPressed: () {},
                //     icon: Icon(Icons.favorite_border_outlined),
                //     label: Text(
                //       "Add to My Favorite",
                //       style: TextStyle(
                //         fontFamily: "Outfit",
                //       ),
                //     )),
              ],
            ),
          ],
        ),
      ),
    ));

    //   return DefaultTabController(
    //       length: 3,
    //       child: Scaffold(
    //         appBar: AppBar(
    //           backgroundColor: Colors.white,
    //           elevation: 0,
    //           leading: IconButton(
    //             icon: const Icon(Icons.keyboard_backspace),
    //             tooltip: 'Back to home page',
    //             color: Colors.blueGrey,
    //             splashColor: appTheme.orange_primary,
    //             onPressed: () {
    //               Navigator.of(context).pop(
    //                   MaterialPageRoute(builder: (context) => CreateScreen()));
    //             },
    //           ),
    //           //
    //         ),
    //         body: TabBarView(children: [
    //           SizedBox.expand(
    //             child: Column(
    //               children: [
    //                 SizedBox(
    //                   height: 20.h,
    //                 ),
    //                 Container(
    //                   height: MediaQuery.of(context).size.height * 0.64,
    //                   padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
    //                   width: 316.h,
    //                   decoration: BoxDecoration(
    //                       color: appTheme.yellow50,
    //                       borderRadius: BorderRadius.circular(10.h),
    //                       border:
    //                           Border.all(color: appTheme.gray700, width: 1.h)),
    //                   child: SingleChildScrollView(
    //                     child: Text(widget.resultCompletion),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ]),
    //         bottomNavigationBar: menu(),
    //       ),
    // );
  }
}
