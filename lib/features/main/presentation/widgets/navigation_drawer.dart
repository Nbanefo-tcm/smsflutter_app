import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.primaryContainer,
              gradient: isDark ? null : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withOpacity(0.9),
                  colorScheme.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: Row(
              children: [
                // App Logo/Icon - Matches app bar logo
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(6),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/simmax_logo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'SimMAX',
                  style: TextStyle(
                    color: isDark ? Colors.white : colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: isDark
                        ? [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black.withOpacity(0.3),
                            ),
                          ]
                        : null,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: isDark ? colorScheme.onSurface : colorScheme.onPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Main Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main',
                      (route) => false,
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.swap_horiz_outlined,
                  title: 'Transaction',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Transaction');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.sms_outlined,
                  title: 'SMS',
                  onTap: () {
                    Navigator.of(context).pop();
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != '/sms-inbox') {
                      Navigator.of(context).pushNamed('/sms-inbox');
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Fund Wallet',
                  onTap: () {
                    Navigator.of(context).pop();
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != '/fund-wallet') {
                      Navigator.of(context).pushNamed('/fund-wallet');
                    }
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.phone_android_outlined,
                  title: 'Rent',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Rent');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.sim_card_outlined,
                  title: 'eSIM Profile',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'eSIM Profile');
                  },
                ),
                
                // Divider before profile section
                Divider(
                  height: 16,
                  thickness: 1,
                  indent: 16,
                  endIndent: 16,
                  color: colorScheme.outlineVariant,
                ),
                
                // Profile section
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    Navigator.of(context).pop();
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != '/profile') {
                      Navigator.of(context).pushNamed('/profile');
                    }
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Buy Socks5 Proxy
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Socks5 Proxy');
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Buy Socks5 Proxy',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 16.h),

                // Contact Info
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      children: [
                        Text(
                          authProvider.user?.email ?? 'user@email.com',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Message us',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      tileColor: Colors.transparent,
      hoverColor: colorScheme.onSurface.withOpacity(0.05),
      focusColor: colorScheme.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature feature coming soon!',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
        backgroundColor: colorScheme.primaryContainer,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
