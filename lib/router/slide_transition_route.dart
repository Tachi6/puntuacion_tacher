import 'package:flutter/material.dart';

PageRouteBuilder slidetransitionRoute(BuildContext context, Widget newRoute) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return newRoute;
    },
    // transitionDuration: Duration(seconds: 1),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {

      final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(curvedAnimation),
        child: child,
      );
    },
  );
}