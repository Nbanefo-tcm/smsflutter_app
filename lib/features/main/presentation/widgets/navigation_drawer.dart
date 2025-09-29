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

    return Drawer(
      backgroundColor: theme.drawerTheme.backgroundColor ?? theme.canvasColor,
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
              color: colorScheme.primary,
            ),
            child: Row(
              children: [
                // App Logo/Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.sms,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'MSMmax',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.dashboard_outlined,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.of(context).pop();
                    // Always navigate to main screen (dashboard)
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main',
                      (route) => false,
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.sms_outlined,
                  title: 'Receive SMS',
                  onTap: () {
                    Navigator.of(context).pop();
                    // Check if we're already on SMS inbox screen
                    final currentRoute = ModalRoute.of(context)?.settings.name;
                    if (currentRoute != '/sms-inbox') {
                      Navigator.of(context).pushNamed('/sms-inbox');
                    }
                  },
                ),
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
                _buildMenuItem(
                  context,
                  icon: Icons.tag,
                  title: 'Rent Number',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Rent Number');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.sim_card_outlined,
                  title: 'My eSIM',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'My eSIM');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.diamond_outlined,
                  title: 'eSIM Plans',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'eSIM Plans');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'API Docs',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'API Docs');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Settings');
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Tutorials',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon(context, 'Tutorials');
                  },
                ),
              ],
            ),
          ),
          
          // Footer
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
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
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
                            color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
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
                                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0088CC),
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

  ListTile _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        icon,
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
        size: 20.sp,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: theme.textTheme.bodyLarge?.color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      horizontalTitleGap: 12.w,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: theme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
