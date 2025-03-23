import 'package:diet_app/presentation/providers/auth/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleBasedBottomNavigationBar extends ConsumerStatefulWidget {
  const RoleBasedBottomNavigationBar({super.key});

  @override
  _RoleBasedBottomNavigationBarState createState() =>
      _RoleBasedBottomNavigationBarState();
}

class _RoleBasedBottomNavigationBarState
    extends ConsumerState<RoleBasedBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userRole = ref.watch(authNotifierProvider).maybeWhen(
          authenticated: (user) => user.role.name,
          orElse: () => 'USER',
        );

    List<BottomNavigationBarItem> bottomNavItems = [];
    List<Widget> pages = [];

    if (userRole == 'DIETITIAN') {
      bottomNavItems = [
        const BottomNavigationBarItem(
            icon: Icon(Icons.people), label: 'Clients'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.food_bank), label: 'Plans'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today), label: 'Appointments'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: 'Notifications'),
      ];
      pages = [
        const Text('Clients Page'),
        const Text('Plans Page'),
        const Text('Appointments Page'),
        const Text('Notifications Page'),
      ];
    } else if (userRole == 'USER') {
      bottomNavItems = [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.trending_up), label: 'Progress'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu), label: 'My Diet'),
        const BottomNavigationBarItem(
            icon: Icon(Icons.message), label: 'Contact Dietitian'),
      ];
      pages = [
        const Text('Home Page'),
        const Text('Progress Page'),
        const Text('My Diet Page'),
        const Text('Contact Dietitian Page'),
      ];
    }

    return Scaffold(
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
