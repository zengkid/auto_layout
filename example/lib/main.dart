import 'package:auto_layout/layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(AdminPage());

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudoLayoutBuilder(
          title: Text("Admin"),
          actions: [
            IconButton(
              onPressed: () {
                print('logout...');
              },
              icon: Icon(Icons.logout),
            )
          ],
          itemCount: 10,
          onMenuItemPress: (index) {
            print("menu_$index pressed");
          },
          menuItemBuilder: (context, index, selectedIndex) {
            return ListTile(
                tileColor: index == selectedIndex
                    ? Colors.grey[200]
                    : Colors.transparent,
                title: Text("menu_$index"));
          },
          bodyItemBuilder: (context, index) {
            print('building body');
            return index == null ? Text("Welcome") : Text("body_$index");
          }),
    );
  }
}
