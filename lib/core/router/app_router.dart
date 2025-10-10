import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/main/presentation/screens/main_screen.dart';
import '../../../features/main/presentation/widgets/dashboard_page.dart' as dashboard;
import '../../../features/sms/presentation/screens/sms_inbox_screen.dart';
import '../../../features/transactions/presentation/screens/transactions_screen_fixed.dart';
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
      // Login route (outside shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      // Main shell route (all authenticated routes go here)
      ShellRoute(
        builder: (context, state, child) => MainScreen(content: child),
        routes: [
          // Dashboard (home) route
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const dashboard.DashboardPage(),
          ),
          
          // Transactions route
          GoRoute(
            path: '/transactions',
            name: 'transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          
          // Inbox route
          GoRoute(
            path: '/inbox',
            name: 'inbox',
            builder: (context, state) => const SmsInboxScreen(),
          ),
          
          // Numbers route
          GoRoute(
            path: '/numbers',
            name: 'numbers',
            builder: (context, state) => const Center(child: Text('Numbers')),
          ),
          
          // Profile route (using ProfileScreen instead of placeholder)
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          
          // Fund Wallet route
          GoRoute(
            path: '/fund-wallet',
            name: 'fund-wallet',
            builder: (context, state) => const FundWalletScreen(),
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
