import 'dart:async';

import 'package:aina/presentation/onboardings/signin_screen.dart';
import 'package:aina/presentation/onboardings/signup_screen.dart';
import 'package:aina/presentation/settings/profile_sceen.dart';
import 'package:flutter/material.dart';
import 'package:aina/presentation/calendar/calendar_screen.dart';
import 'package:aina/presentation/home/CRUD/diary_screen.dart';
import 'package:aina/presentation/home/home_screen.dart';
import 'package:aina/presentation/main/main_layout.dart';
import 'package:aina/presentation/settings/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

  return GoRouter(
    initialLocation: '/home',

    // Supabase 로그인 상태가 변경되면 GoRouter가 redirect를 다시 실행
    refreshListenable: GoRouterRefreshStream(
      supabase.auth.onAuthStateChange,
    ),

    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;

      final location = state.matchedLocation;

      final isAuthRoute =
          location == '/login' ||
          location == '/signup';

      // 로그인하지 않은 사용자가 보호된 페이지에 접근
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // 이미 로그인한 사용자가 로그인/회원가입 페이지 접근
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const SigninScreen(),
      ),

      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const CalendarScreen(),
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/diary/write',
        builder: (context, state) => const DiaryScreen(),
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});


class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen(
      (_) {
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}