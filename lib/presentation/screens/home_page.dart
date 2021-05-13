import 'package:flutter/material.dart';
import 'package:spotify_clone/constants/colors.dart';
import 'package:spotify_clone/presentation/router/app_router.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.appRouter}) : super(key: key);

  final AppRouter appRouter;

  @override
  _HomePageState createState() => _HomePageState(appRouter: appRouter);
}

class _HomePageState extends State<HomePage> {
  final AppRouter appRouter;

  _HomePageState({this.appRouter});

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
          key: _navigatorKey, onGenerateRoute: appRouter.onGenerateRoute),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: darkGreyColor,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: greenColor,
      unselectedItemColor: lightGreyColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.thumb_up),
          label: "Top tracks",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: "Saved tracks",
        )
      ],
      onTap: _onTap,
      currentIndex: _currentTabIndex,
    );
  }

  _onTap(int tabIndex) {
    switch (tabIndex) {
      case 0:
        _navigatorKey.currentState.pushReplacementNamed("/");
        break;
      case 1:
        _navigatorKey.currentState.pushReplacementNamed("/");
        break;
    }
    setState(() {
      _currentTabIndex = tabIndex;
    });
  }
}
