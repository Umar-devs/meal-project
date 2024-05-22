import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({
    required this.page,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut, // You can change the curve here
                  reverseCurve:
                      Curves.easeInOut, // Optional: curve for reverse animation
                ),
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        );
}
