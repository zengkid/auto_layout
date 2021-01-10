import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef BuildBody = void Function(int bodyItemIndex);

typedef MenuBuilder = Widget Function(BuildContext context, BuildBody handle);

/// build a auto layout widget
class AudoLayoutBuilder extends StatefulWidget {
  ///app bar title
  final Widget title;

  ///define large device width, default is 600
  final int largeBreakpoint;

  ///initial page index
  final int initialPage;

  ///menu builder
  final MenuBuilder menuBuilder;

  ///body item builder, dependent on menu index
  final IndexedWidgetBuilder bodyItemBuilder;

  ///app bar actions
  final List<Widget> actions;

  /// build a auto layout
  ///
  ///```dart
  ///  AudoLayoutBuilder(
  ///    title: Text("Admin"),
  ///    actions: [
  ///      IconButton(
  ///        icon: Icon(Icons.logout),
  ///      )
  ///    ],
  ///    menuBuilder: (BuildContext context, BuildBody buildBody) {
  ///      return ListView.builder(
  ///          itemCount: 10,
  ///          itemBuilder: (context, index) {
  ///            return ListTile(
  ///              onTap: () {
  ///                buildBody(index); //must invoke the method to build body content
  ///              },
  ///              title: Text('menu_$index'),
  ///            );
  ///          });
  ///    },
  ///    initialPage: 0,  //start index = 0
  ///    bodyItemBuilder: (context, index) {
  ///      return index == null ? Text("Welcome") : Text("body_$index");
  ///  })
  ///```
  const AudoLayoutBuilder(
      {Key key,
      this.title,
      this.actions,
      this.menuBuilder,
      this.bodyItemBuilder,
      this.largeBreakpoint = 600,
      this.initialPage})
      : super(key: key);

  @override
  _AudoLayoutBuilderState createState() => _AudoLayoutBuilderState();
}

class _AudoLayoutBuilderState extends State<AudoLayoutBuilder>
    with TickerProviderStateMixin {
  int _currentIndex;
  bool _hideMenu = false;

  AnimationController _animationController;
  Animation<double> _menuAnimation;
  Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialPage;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _menuAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _iconAnimation =
        Tween<double>(begin: 0.0, end: 0.25).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = constraints.maxWidth;
        if (maxWidth >= widget.largeBreakpoint) {
          var drawerWidth = maxWidth / 5;
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
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: widget.title,
          actions: widget.actions,
        ),
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
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor),
                        child: IconButton(
                          alignment: Alignment.centerLeft,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildMenus(true),
                ))
              ])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.bodyItemBuilder(context, _currentIndex),
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
              !_hideMenu
                  ? _animationController.forward()
                  : _animationController.reverse();
              _hideMenu = !_hideMenu;
            },
            icon: RotationTransition(
                alignment: Alignment.center,
                turns: _iconAnimation,
                child: Icon(Icons.menu)),
          ),
          title: widget.title,
          actions: widget.actions,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: _menuAnimation,
                    builder: (BuildContext context, Widget child) {
                      return Container(
                          width: _menuAnimation.value * drawerWidth,
                          child: child);
                    },
                    child: Drawer(
                      elevation: 2,
                      child: _buildMenus(false),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: widget.bodyItemBuilder(context, _currentIndex),
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

  Widget _buildMenus([bool needHide = false]) {
    return widget.menuBuilder(context, (index) {
      setState(() {
        _currentIndex = index;
      });
      if (needHide) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
