import 'package:flutter/material.dart';

class SimpleLayout extends StatefulWidget {
  final Widget title;
  final int largeBreakpoint;
  final IndexedWidgetBuilder menuItemBuilder;
  final IndexedWidgetBuilder bodyItemBuilder;
  final int itemCount;

  const SimpleLayout(
      {Key key,
      this.title,
      this.itemCount,
      this.menuItemBuilder,
      this.bodyItemBuilder,
      this.largeBreakpoint = 600})
      : super(key: key);

  @override
  _SimpleLayoutState createState() => _SimpleLayoutState(
      this.title,
      this.itemCount,
      this.menuItemBuilder,
      this.bodyItemBuilder,
      this.largeBreakpoint);
}

class _SimpleLayoutState extends State<SimpleLayout> {
  final Widget title;

  final IndexedWidgetBuilder menuItemBuilder;
  final IndexedWidgetBuilder bodyItemBuilder;
  final int itemCount;
  final int largeBreakpoint;

  int _currentIndex;
  bool _hideMenu = false;

  _SimpleLayoutState(this.title, this.itemCount, this.menuItemBuilder,
      this.bodyItemBuilder, this.largeBreakpoint);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = constraints.maxWidth;
        if (maxWidth >= largeBreakpoint) {
          var drawerWidth = maxWidth / 4;
          if (drawerWidth < 180) {
            drawerWidth = 180;
          }
          if (drawerWidth > 400) {
            drawerWidth = 400;
          }

          return _buildLargeLayout(drawerWidth, context);
        } else {
          var drawerWidth = 320.0;
          if (drawerWidth > maxWidth - 40) {
            drawerWidth = maxWidth - 40;
          }

          return _buildMiddleLayout(drawerWidth, context);
        }
      },
    );
  }

  SafeArea _buildMiddleLayout(double drawerWidth, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: true, title: this.title),
        drawer: Container(
          width: drawerWidth,
          child: Drawer(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                Container(
                    height: 64,
                    child: DrawerHeader(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: Text('Menu'))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                            });
                            Navigator.pop(context);
                          },
                          title: menuItemBuilder(context, index));
                    },
                  ),
                ))
              ])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: bodyItemBuilder(context, _currentIndex),
        ),
      ),
    );
  }

  SafeArea _buildLargeLayout(double drawerWidth, BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                _hideMenu = !_hideMenu;
              });
            },
            icon: _hideMenu ? Icon(Icons.menu) : Icon(Icons.menu_open),
          ),
          title: title,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: _hideMenu ? 0 : drawerWidth,
                    child: Drawer(
                      elevation: 2,
                      child: ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              title: menuItemBuilder(context, index));
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: bodyItemBuilder(context, _currentIndex),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
