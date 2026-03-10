import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideztohealth/feature/profileAndHistory/presentation/screens/history_screen.dart';
import 'package:rideztohealth/feature/serviceFeature/presentation/screens/service_screen.dart';
import 'package:rideztohealth/helpers/remote/data/socket_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature/auth/controllers/auth_controller.dart';
import 'feature/profileAndHistory/presentation/screens/profile_screen.dart';
import 'navigation/custom_bottom_nev_bar.dart';
import 'feature/home/presentation/screens/home_screen.dart';
import 'utils/app_constants.dart';

class AppMain extends StatefulWidget {
  const AppMain({super.key});

  @override
  State<AppMain> createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> {
  int _selectedIndex = 0;
  final SocketClient socketClient = SocketClient();
  SharedPreferences? sharedPreferences;
  String userId = '';
  final AuthController authController = Get.find<AuthController>();


  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
    _initUserIdAndJoin();
  }

  Future<void> _initUserIdAndJoin() async {
    final prefs = await SharedPreferences.getInstance();
    sharedPreferences = prefs;
    final storedUserId = prefs.getString(AppConstants.userId) ?? '';
    if (!mounted) return;
    setState(() {
      userId = storedUserId;
    });
    if (userId.isEmpty) {
      print('⚠️ User ID not found in SharedPreferences');
      return;
    }
    if (socketClient.isConnected) {
      _emitJoin(userId);
    } else {
      socketClient.on('connect', (_) {
        _emitJoin(userId);
      });
    }
  }

  void _emitJoin(String id) {
    socketClient.emit('join-user', {
      'userId': id, // ei key ta backend expect korche
    });
    print('socket join with sender id To checkkkkkkkikk : from AppMain : $id');
  }

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
