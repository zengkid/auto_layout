# auto_layout

auto admin layout builder, it can build  difference layout with difference device

## Getting Started

* add library to your pubspec.yaml

```yaml

dependencies:
  uto_layout: ^latest_version
  
```

admin page sample
```dart
import 'package:auto_layout/auto_layout.dart';
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
          menuBuilder: (BuildContext context, BuildBody buildBody) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      buildBody(index); //must invoke the method to build body content
                    },
                    title: Text('menu_$index'),
                  );
                });
          },
          initialPage: 0,//start index = 0
          bodyItemBuilder: (context, index) {
            print('building body $index');
            return index == null ? Text("Welcome") : Text("body_$index");
          }),
    );
  }
}
```


## Screenshot
![show gif](https://github.com/zengkid/auto_layout/blob/master/doc/showing.gif?raw=true)
![pic1](https://github.com/zengkid/auto_layout/blob/master/doc/1.png?raw=true)
![pic2](https://github.com/zengkid/auto_layout/blob/master/doc/2.png?raw=true)
![pic3](https://github.com/zengkid/auto_layout/blob/master/doc/3.png?raw=true)
![pic4](https://github.com/zengkid/auto_layout/blob/master/doc/4.png?raw=true)