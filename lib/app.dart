import 'package:flutter/material.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/history_screen.dart';
import 'package:rideztohealth/feature/serviceFeature/presentation/screens/service_screen.dart';

import 'feature/profileAndHistory/presentation/screens/profile_screen.dart';
import 'navigation/custom_bottom_nev_bar.dart';
import 'feature/home/presentation/screens/home_screen.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ServiceScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
