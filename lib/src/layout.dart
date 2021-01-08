import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef MenuItemPress = void Function(int index);
typedef MenuItemBuilder = Widget Function(
    BuildContext context, int index, int selectedIndex);

class AudoLayoutBuilder extends StatefulWidget {
  final Widget title;
  final int largeBreakpoint;
  final MenuItemPress onMenuItemPress;
  final MenuItemBuilder menuItemBuilder;
  final IndexedWidgetBuilder bodyItemBuilder;
  final int itemCount;

  const AudoLayoutBuilder(
      {Key key,
      this.title,
      this.itemCount,
      this.onMenuItemPress,
      this.menuItemBuilder,
      this.bodyItemBuilder,
      this.largeBreakpoint = 600})
      : super(key: key);

  @override
  _AudoLayoutBuilderState createState() => _AudoLayoutBuilderState(
      this.title,
      this.itemCount,
      this.onMenuItemPress,
      this.menuItemBuilder,
      this.bodyItemBuilder,
      this.largeBreakpoint);
}

class _AudoLayoutBuilderState extends State<AudoLayoutBuilder>
    with TickerProviderStateMixin {
  final Widget title;

  final MenuItemPress onMenuItemPress;
  final MenuItemBuilder menuItemBuilder;
  final IndexedWidgetBuilder bodyItemBuilder;
  final int itemCount;
  final int largeBreakpoint;

  int _currentIndex;
  bool _hideMenu = false;

  AnimationController _animationController;
  Animation<double> _menuAnimation;
  Animation<double> _iconAnimation;

  _AudoLayoutBuilderState(this.title, this.itemCount, this.onMenuItemPress,
      this.menuItemBuilder, this.bodyItemBuilder, this.largeBreakpoint);

  @override
  void initState() {
    super.initState();
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
        if (maxWidth >= largeBreakpoint) {
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
                  child: _buildMenus(true),
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
          title: title,
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

  ListView _buildMenus([bool needHide = false]) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return MouseRegion(
            cursor: SystemMouseCursors.click, //not support web?
            child: InkWell(
                onTap: () {
                  if (onMenuItemPress != null) {
                    onMenuItemPress(index);
                  }
                  setState(() {
                    _currentIndex = index;
                  });
                  if (needHide) {
                    Navigator.pop(context);
                  }
                },
                child: menuItemBuilder(context, index, _currentIndex)));
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
