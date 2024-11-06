import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  final LocalStorage storage = SharedPreferencesStorage();
  String? _name;
  int _selectedIndex = 0;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkInitialConnection();
    _startListeningToConnectionChanges();
  }

  void _loadUserData() async {
    final name = await storage.getData('name');

    setState(() {
      _name = name;
    });
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });

    if (!isOnline) {
      _showNoConnectionDialog();
    }
  }

  void _startListeningToConnectionChanges() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        isOnline = result.first != ConnectivityResult.none;
      });

      if (!isOnline) {
        _showNoConnectionDialog();
      }
    });
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection to use the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/transactions');
    } else if (index == 2) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_name != null)
              Text(
                'Welcome, $_name',
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/page_home_logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            if (!isOnline)
              const Text(
                'You are currently offline.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
      bottomNavigationBar: PageNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
