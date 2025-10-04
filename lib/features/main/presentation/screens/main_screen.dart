import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/theme_selector.dart';
import '../../../../core/widgets/profile_avatar_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/service_card.dart';

class MainScreen extends StatefulWidget {
  final Widget? content;
  
  const MainScreen({
    super.key,
    this.content,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _services = [
    {
      'title': 'SMS',
      'icon': Icons.sms_outlined,
      'color': AppColors.primary,
      'route': '/sms-inbox',
    },
    {
      'title': 'Rent Number',
      'icon': Icons.phone_android_outlined,
      'color': AppColors.success,
      'route': '/rent-number',
    },
    {
      'title': 'My eSIM',
      'icon': Icons.sim_card_outlined,
      'color': AppColors.accent,
      'route': '/my-esim',
    },
    {
      'title': 'eSIM Plans',
      'icon': Icons.credit_card_outlined,
      'color': AppColors.warning,
      'route': '/esim-plans',
    },
    {
      'title': 'API Docs',
      'icon': Icons.api_outlined,
      'color': AppColors.error,
      'route': '/api-docs',
    },
    {
      'title': 'Tutorials',
      'icon': Icons.school_outlined,
      'color': AppColors.info,
      'route': '/tutorials',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(6.r),
                image: const DecorationImage(
                  image: AssetImage('assets/images/simmax_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'SimMAX',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.appBarTheme.foregroundColor,
              ),
            ),
          ],
        ),
        actions: [
          const ProfileAvatarButton(iconColor: Colors.black),
          const ThemeSelector(),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
            },
          ),
        ],
      ),
      body: widget.content ?? _buildHomeContent(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_outlined),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        backgroundColor: theme.bottomNavigationBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 8,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha((0.08 * 255).round()),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.waving_hand_outlined,
                    size: 24.sp,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.brightness == Brightness.dark 
                              ? Colors.white.withOpacity(0.9)
                              : colorScheme.onSurface.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Explore our services',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.brightness == Brightness.dark 
                              ? Colors.white 
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 28.h),
          
          // Services Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Services',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              Text(
                '${_services.length} services',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // Services Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.1,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return ServiceCard(
                title: service['title'],
                icon: service['icon'],
                color: service['color'],
                onTap: () {
                  Navigator.pushNamed(context, service['route']);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
