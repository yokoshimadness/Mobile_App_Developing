// ignore_for_file: inference_failure_on_function_invocation, unrelated_type_equality_checks, lines_longer_than_80_chars, use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  final LocalStorage storage = SharedPreferencesStorage();
  String? _name;
  String? _email;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  double totalIncome = 0;
  double totalExpense = 0;
  double totalBalance = 0;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFinancialData();
    _checkInitialConnection();
    _startListeningToConnectionChanges();
  }

  void _loadUserData() async {
    final name = await storage.getData('name');
    final email = await storage.getData('email');

    setState(() {
      _name = name;
      _email = email;
      _nameController.text = name ?? '';
      _emailController.text = email ?? '';
    });
  }

  void _loadFinancialData() async {
    final incomeData = await storage.getData('totalIncome');
    final expenseData = await storage.getData('totalExpense');

    setState(() {
      totalIncome = double.tryParse(incomeData ?? '0') ?? 0;
      totalExpense = double.tryParse(expenseData ?? '0') ?? 0;
      totalBalance = totalIncome - totalExpense;
    });
  }

  void _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });
  }

  void _startListeningToConnectionChanges() {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      setState(() {
        isOnline = result.first != ConnectivityResult.none;
      });

      if (!isOnline) {
        _showNoConnectionDialog();
      }
    });
  }

  void _saveData() async {
    final newName = _nameController.text;
    final newEmail = _emailController.text;

    if (newName.isNotEmpty && _validateEmail(newEmail)) {
      await storage.saveData('name', newName);
      await storage.saveData('email', newEmail);

      setState(() {
        _isEditing = false;
        _name = newName;
        _email = newEmail;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid data')),
      );
    }
  }

  bool _validateEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegExp.hasMatch(email);
  }

  void _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await storage.saveData('isLoggedOut', 'true');
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false,
          arguments: isOnline,);
    }
  }

  int _selectedIndex = 2;

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

  double _calculatePercentage(double value) {
    final double total = totalIncome + totalExpense;
    return total > 0 ? (value / total) * 100 : 0;
  }

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
              'Please check your internet connection and try again.',),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/images/profile-user.png'),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_name != null)
                      Text(
                        'Name: $_name',
                        style: const TextStyle(fontSize: 18),
                      ),
                    if (_email != null)
                      Text(
                        'Email: $_email',
                        style: const TextStyle(fontSize: 18),
                      ),
                  ],
                ),
              ],
            ),
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveData,
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                        });
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
                child: const Text('Edit Data'),
              ),
            const SizedBox(height: 20),
            Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
            Text('Total Expense: \$${totalExpense.toStringAsFixed(2)}'),
            Text('Current Balance: \$${totalBalance.toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: totalIncome,
                      title:
                          'Income\n${totalIncome.toStringAsFixed(2)}\n(${_calculatePercentage(totalIncome).toStringAsFixed(1)}%)',
                      color: Colors.green,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: totalExpense,
                      title:
                          'Expense\n${totalExpense.toStringAsFixed(2)}\n(${_calculatePercentage(totalExpense).toStringAsFixed(1)}%)',
                      color: Colors.red,
                      radius: 60,
                    ),
                  ],
                ),
              ),
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
