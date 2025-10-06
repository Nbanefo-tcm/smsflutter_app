import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/theme_selector.dart';
import '../../../../core/widgets/profile_avatar_button.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/dashboard_page.dart' as dashboard;

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
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    const dashboard.DashboardPage(),
    const Center(child: Text('SMS')),
    const Center(child: Text('Transactions')),
    const Center(child: Text('Rent')),
    const Center(child: Text('eSIM')),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sms_outlined),
      activeIcon: Icon(Icons.sms),
      label: 'SMS',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'Transactions',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.paid_outlined),
      activeIcon: Icon(Icons.paid),
      label: 'Rent',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.sim_card_outlined),
      activeIcon: Icon(Icons.sim_card),
      label: 'eSIM',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Only update the page controller if we're using the PageView
    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    }
    
    // Update the URL to match the selected tab
    final routes = ['/', '/sms', '/transactions', '/rent', '/esim'];
    if (index < routes.length) {
      GoRouter.of(context).go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If we have content from the router, use it, otherwise use our PageView
    final bodyContent = widget.content ?? _buildDefaultContent();
    
    return Scaffold(
      drawer: const AppNavigationDrawer(),
      appBar: AppBar(
        title: const Text(
          'SimMAX',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, size: 24),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          ThemeSelector(),
          SizedBox(width: 8),
          ProfileAvatarButton(),
          SizedBox(width: 8),
        ],
      ),
      body: bodyContent,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withAlpha(25),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF4E73DF),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12, height: 2),
          unselectedLabelStyle: const TextStyle(fontSize: 12, height: 2),
          items: _bottomNavItems,
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    // This is the default content when no route is specified
    return _pages[_selectedIndex];
  }
}
