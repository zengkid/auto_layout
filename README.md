# simple_layout

It is a very simple layout for flutter.


## Getting Started

```dart
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

```


## Screenshot
![show gif](https://github.com/zengkid/auto_layout/blob/master/doc/showing.gif?raw=true)
![pic1](https://github.com/zengkid/auto_layout/blob/master/doc/1.png?raw=true)
![pic2](https://github.com/zengkid/auto_layout/blob/master/doc/2.png?raw=true)
![pic3](https://github.com/zengkid/auto_layout/blob/master/doc/3.png?raw=true)
![pic4](https://github.com/zengkid/auto_layout/blob/master/doc/4.png?raw=true)