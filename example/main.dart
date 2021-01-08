import 'package:auto_layout/auto_layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(SampleLayout());

class SampleLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AudoLayoutBuilder(
            largeBreakpoint: 500,
            title: Text("Sample"),
            itemCount: 10,
            onMenuItemPress: (index) {
              print('mneu_$index is pressed');
            },
            menuItemBuilder: (context, index) {
              return Text("menu_$index");
            },
            bodyItemBuilder: (context, index) {
              return index == null ? Text("Welcome") : Text("body_$index");
            }));
  }
}
