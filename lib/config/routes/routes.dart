import 'package:elyx_task/features/home/data/models/user_data_model.dart';
import 'package:elyx_task/features/home/presentation/pages/homepage_screen.dart';
import 'package:elyx_task/features/home/presentation/pages/user_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String home = '/home';
  static const String userDetail = '/userDetail';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    routes: [
      GoRoute(
        path: home,
        name: home,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          HomeScreenWrapper(),
          name: state.name,
        ),
      ),
      GoRoute(
        path: userDetail,
        name: userDetail,
        pageBuilder: (context, state) {
          final user = state.extra as UserData;
          return _buildPageWithTransition(
            context,
            UserDetailScreen(user: user),
            name: state.name,
          );
        },
      ),
    ],
  );

  static CustomTransitionPage _buildPageWithTransition(
    BuildContext context,
    Widget child, {
    String? name,
  }) {
    return CustomTransitionPage(
      child: child,
      name: name,
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        final slideTween = Tween<Offset>(
          begin: const Offset(0.1, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));

        final fadeTween = Tween<double>(begin: 0.0, end: 1.0);

        final scaleTween = Tween<double>(
          begin: 0.98,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut));

        return SlideTransition(
          position: curvedAnimation.drive(slideTween),
          child: FadeTransition(
            opacity: curvedAnimation.drive(fadeTween),
            child: ScaleTransition(
              scale: curvedAnimation.drive(scaleTween),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
