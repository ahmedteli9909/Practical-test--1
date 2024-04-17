import 'package:flutter/material.dart';
import 'package:practical_tast_1/view/home/home_screen.dart';

class AppRoutes {
  static const String initialRoute = HomeScreen.route;

  static Route<dynamic>? onGeneratedRoutes(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.route:
        return _materialPageRoute(const HomeScreen(), settings);
    }
    return null;
  }

  static MaterialPageRoute _materialPageRoute(
      Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }
}
