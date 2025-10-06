import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      onPressed: () => context.pop(),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // User Info Card
              Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12), // 0.05 * 255 ≈ 12
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // User Avatar
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withAlpha(26), // 0.1 * 255 ≈ 26
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 32.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Madmaxpro',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'madmaxpro@example.com',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurface.withAlpha(153), // 0.6 * 255 ≈ 153
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Edit Button
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.sp,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Items
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(12), // 0.05 * 255 ≈ 12
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Account Information',
                      onTap: () {},
                    ),
                    _buildDivider(context),
                    _buildMenuItem(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      onTap: () {},
                    ),
                    _buildDivider(context),
                    _buildMenuItem(
                      context,
                      icon: Icons.payment_outlined,
                      title: 'Payment Methods',
                      onTap: () {},
                    ),
                    _buildDivider(context),
                    _buildMenuItem(
                      context,
                      icon: Icons.credit_card_outlined,
                      title: 'My Cards',
                      onTap: () {},
                    ),
                    _buildDivider(context),
                    _buildMenuItem(
                      context,
                      icon: Icons.history_outlined,
                      title: 'Transaction History',
                      onTap: () {},
                    ),
                    _buildDivider(context),
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Logout Button
              Container(
                margin: EdgeInsets.all(16.w),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle logout
                    context.read<AuthProvider>().logout();
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.error,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: colorScheme.error.withAlpha(128)), // 0.5 * 255 ≈ 128
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer Links
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink(context, 'Help & Support', () {}),
                    SizedBox(width: 16.w),
                    _buildFooterLink(context, 'Terms of Service', () {}),
                    SizedBox(width: 16.w),
                    _buildFooterLink(context, 'Privacy Policy', () {}),
                  ],
                ),
              ),

              // Version
              Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.onSurface.withAlpha(128), // 0.5 * 255 ≈ 128
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build menu item widget
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(26), // 0.1 * 255 ≈ 26
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: colorScheme.primary,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.sp,
                color: colorScheme.onSurface.withAlpha(128), // 0.5 * 255 ≈ 128
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build divider widget
  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Divider(
        height: 1,
        thickness: 1,
        color: theme.div s or.withAlpha(26), // 0.1 * 255 ≈ 26
      ),
    );
  }

  // Build footer link widget
  Widget _buildFooterLink(
    BuildContext context, 
    String text, 
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 0.6 * 255 ≈ 153
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
