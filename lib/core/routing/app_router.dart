import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:rehla/core/presentation/view/focus_handler.dart';
import 'package:rehla/features/home/presentation/view/home_screen.dart';
import 'package:rehla/features/settings/presentation/view/settings_screen.dart';

enum PageRouteAnimation { fade, scale, rotate, slide, slideBottomTop }

class AppRouter {
  static const String kHome = '/';
  static const String kSettings = '/settings';

  static Page<void> animateRoute(
    Widget widget, {
    PageRouteAnimation? pageRouteAnimation,
    Duration? duration,
  }) {
    if (Platform.isIOS) {
      return CupertinoPage(child: widget);
    }

    return CustomTransitionPage(
      child: widget,
      fullscreenDialog: false,
      transitionDuration: duration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (pageRouteAnimation) {
          case PageRouteAnimation.scale:
            return ScaleTransition(
              scale: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
              ),
              child: child,
            );
          case PageRouteAnimation.rotate:
            return RotationTransition(
              turns: Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            );
          case PageRouteAnimation.slide:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          case PageRouteAnimation.slideBottomTop:
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  ),
              child: child,
            );
          case PageRouteAnimation.fade:
          case null:
            return FadeTransition(opacity: animation, child: child);
        }
      },
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: kHome,
    observers: [KeyboardDismissObserver()],
    // redirect: (context, state) {
    //   const loggedIn = false;
    //   final location = state.matchedLocation;
    //   const loginRoute = '/login';
    //   if (!loggedIn && location != loginRoute) return loginRoute;
    //   if (loggedIn && location == loginRoute) return kHome;
    //   return null;
    // },
    routes: [
      GoRoute(
        path: kHome,
        pageBuilder: (context, state) {
          return animateRoute(
            const HomeScreen(),
            pageRouteAnimation: PageRouteAnimation.fade,
          );
        },
      ),
      GoRoute(
        path: kSettings,
        pageBuilder: (context, state) {
          return animateRoute(
            const SettingsScreen(),
            pageRouteAnimation: PageRouteAnimation.slide,
          );
        },
      ),
    ],
  );
}
