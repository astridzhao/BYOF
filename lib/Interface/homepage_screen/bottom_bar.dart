library botton_nav_bar;

import 'package:astridzhao_s_food_app/Interface/create_recipe_screen/creation-screen.dart';
import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:botton_nav_bar/src/notched_shape.dart';
import 'package:flutter/material.dart';

///this is a model for custom navigatorBar with following parameter
class BottomBarItem {
  ///initializing Constructor with BottomNavBarItem
  BottomBarItem({
    this.selectedIcon,
    required this.label,
    required this.screen,
    this.centerDockedTitle,
    this.bottomItemSelectedColor,
    this.icon,
  });

  ///screen of bottomNavigation Bar
  Widget screen;

  ///Selected Icon of a NavigationBar
  Widget? icon;

  ///Icon of bottom nav bar
  IconData? selectedIcon;

  ///selected item color
  Color? bottomItemSelectedColor;

  ///unselected bottomNav bar item color
  Color? bottomItemUnSelectedColor;

  ///label represts the title of NavBar
  String label;

  /// title for Floating action button
  String? centerDockedTitle;
}

///BottomNavBarScreen
class BottomNavBar extends StatefulWidget {
  ///initializing Constructor of bottom Nav Bar
  const BottomNavBar({
    required this.bottomItems,
    this.fabChild,
    this.fabBackGroundColor,
    this.bottomNavBarColor,
    this.floatingActionButtonLocation,
    this.fabIcon,
    this.fabElevation,
    this.fabIconPress,
    this.bottomNavItemSelectedIconSize,
    this.bottomNavItemunSelectedIconSize,
    this.bottomNavItemSelectedLabelSize,
    this.bottomNavItemunSelectedLabelSize,
    this.fabHeight,
    this.fabWidth,
    this.bottomItemLabelFontWeight,
    this.bottomNavItemHeight,
    this.bottomNavItemIconHeight,
    this.bottomNavItemLabelHeight,
    this.notchedRadius,
    this.centerNotched = false,
  });

  ///list of BottomBarItem
  final List<BottomBarItem> bottomItems;
  //FAB LABEL
  final Widget? fabChild;

  ///floting action button color
  final Color? fabBackGroundColor;

  ///bottm navigation bar   color
  final Color? bottomNavBarColor;

  ///FAB Location
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// FAB ICON
  final Widget? fabIcon;

  /// FAB elevation
  final double? fabElevation;

  /// FAB onpress function
  final Function()? fabIconPress;

  /// FAB Height
  final double? fabHeight;

  /// FAB Width
  final double? fabWidth;

  ///buttom item selected size
  final double? bottomNavItemSelectedIconSize;

  ///buttom item unselected size
  final double? bottomNavItemunSelectedIconSize;

  ///buttom item selected size
  final double? bottomNavItemSelectedLabelSize;

  ///buttom item selected size
  final double? bottomNavItemLabelHeight;

  ///buttom item selected size
  final double? bottomNavItemIconHeight;

  ///buttom item unselected size
  final double? bottomNavItemunSelectedLabelSize;

  ///buttom item selected size
  final double? bottomNavItemHeight;

  /// bottomitem font weight
  final FontWeight? bottomItemLabelFontWeight;

  /// u want notched center or not
  final bool centerNotched;

  final double? notchedRadius;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

///Collector   Function

class _BottomNavBarState extends State<BottomNavBar> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: widget.bottomItems[_pageIndex].screen,
      floatingActionButtonLocation: widget.floatingActionButtonLocation ??
          FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        height: widget.fabHeight ?? 70,
        width: widget.fabWidth ?? 70,
        child: FloatingActionButton(
            shape: CircleBorder(),
            onPressed: () {
              widget.fabIconPress!();
            
            },
            backgroundColor: widget.fabBackGroundColor ?? Colors.green,
            elevation: widget.fabElevation ?? 20,
            child: widget.fabIcon),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(40.0),
            ),
            child: BottomAppBar(
              height: MediaQuery.of(context).size.height * 0.1,
              color: appTheme.green_primary,
              shape: widget.centerNotched
                  ? CenterNotchedShape(notchRadius: widget.notchedRadius!)
                  : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    widget.bottomItems.length + 1,
                    (int index) => Expanded(
                      child: index == (widget.bottomItems.length / 2)
                          ? Container(
                              height: widget.fabHeight ?? 45,
                              padding: const EdgeInsets.only(top: 20),
                              alignment: Alignment.bottomCenter,
                              child: widget.fabChild ??
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: widget.fabBackGroundColor ??
                                          Colors.orange,
                                    ),
                                  ),
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  _pageIndex =
                                      index > (widget.bottomItems.length / 2)
                                          ? index - 1
                                          : index;
                                });
                                if (_pageIndex == 0) {
                                  setState(() {});
                                }
                              },
                              child: SizedBox(
                                height: widget.bottomNavItemHeight ?? 50,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                      height: widget.bottomNavItemIconHeight ??
                                          MediaQuery.of(context).size.height *
                                              0.027,
                                      child: widget
                                              .bottomItems[(index >
                                                      (widget.bottomItems
                                                              .length /
                                                          2)
                                                  ? index - 1
                                                  : index)]
                                              .icon ??
                                          Icon(
                                            widget
                                                .bottomItems[(index >
                                                        (widget.bottomItems
                                                                .length /
                                                            2)
                                                    ? index - 1
                                                    : index)]
                                                .selectedIcon,
                                            size: (index >
                                                            widget.bottomItems
                                                                    .length /
                                                                2
                                                        ? index - 1
                                                        : index) ==
                                                    _pageIndex
                                                ? widget.bottomNavItemSelectedIconSize ??
                                                    27
                                                : widget.bottomNavItemunSelectedIconSize ??
                                                    25,
                                            color: (index >
                                                            widget.bottomItems
                                                                    .length /
                                                                2
                                                        ? index - 1
                                                        : index) ==
                                                    _pageIndex
                                                ? widget.bottomItems[_pageIndex]
                                                    .bottomItemSelectedColor
                                                : widget.bottomItems[_pageIndex]
                                                        .bottomItemUnSelectedColor ??
                                                    Color.fromARGB(
                                                        255, 62, 61, 61),
                                          ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    SizedBox(
                                      height:
                                          widget.bottomNavItemLabelHeight ?? 18,
                                      child: Text(
                                        widget
                                            .bottomItems[(index >
                                                    (widget.bottomItems.length /
                                                        2)
                                                ? index - 1
                                                : index)]
                                            .label,
                                        style: TextStyle(
                                          color: (index >
                                                          widget.bottomItems
                                                                  .length /
                                                              2
                                                      ? index - 1
                                                      : index) ==
                                                  _pageIndex
                                              ? widget.bottomItems[_pageIndex]
                                                  .bottomItemSelectedColor
                                              : widget.bottomItems[_pageIndex]
                                                      .bottomItemUnSelectedColor ??
                                                  Color.fromARGB(
                                                      255, 62, 61, 61),
                                          fontWeight: widget
                                                  .bottomItemLabelFontWeight ??
                                              FontWeight.w600,
                                          fontSize: (index >
                                                          widget.bottomItems
                                                                  .length /
                                                              2
                                                      ? index - 1
                                                      : index) ==
                                                  _pageIndex
                                              ? widget.bottomNavItemSelectedLabelSize ??
                                                  13
                                              : widget.bottomNavItemunSelectedLabelSize ??
                                                  11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          )));
}
