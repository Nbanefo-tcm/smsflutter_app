import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/main/presentation/screens/main_screen.dart';
import '../../../features/sms/presentation/screens/sms_inbox_screen.dart';
import '../../../features/wallet/presentation/screens/fund_wallet_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    redirect: (BuildContext context, GoRouterState state) {
      final authProvider = context.read<AuthProvider>();
      final isLoggedIn = authProvider.isAuthenticated;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScreen(content: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const Center(child: Text('Home', key: Key('home_screen'))),
            ),
          ),
          GoRoute(
            path: '/sms-inbox',
            name: 'sms-inbox',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const SmsInboxScreen(),
            ),
          ),
          GoRoute(
            path: '/fund-wallet',
            name: 'fund-wallet',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const FundWalletScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: const ProfileScreen(),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Text('Error: ${state.error}', key: const Key('error_message')),
        ),
      ),
    ),
  );
}
