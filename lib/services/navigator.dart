import 'package:ff_test/screens/home_screen/ui.dart';
import 'package:ff_test/screens/login_screen/ui.dart';
import 'package:flutter/material.dart';

class AppNavigator {
  BuildContext? context;
  var bloc;
  AppNavigator({@required this.context});

  Route _createRoute(String? pageName) {
    var page;
    switch (pageName) {
      case 'login':
        page = LoginScreen();
        break;
      case 'home':
        page = HomeScreen();
        break;
    }
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        animation = CurvedAnimation(curve: Curves.linear, parent: animation);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  void navigateTo({@required String? pageName}) {
    Navigator.of(context!).push(_createRoute(pageName));
  }
}
