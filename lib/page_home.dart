// ignore: lines_longer_than_80_chars
// ignore_for_file: inference_failure_on_function_invocation, unrelated_type_equality_checks

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  double? usdRate;
  double? eurRate;
  double? jpyRate;
  double? gbpRate;
  double? cadRate;
  double? cnyRate;
  double? plnRate;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchExchangeRates();
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

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text(
            'Please check your internet connection to use the app.',
            style: TextStyle(color: Colors.black54),
          ),
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

  Future<void> _fetchExchangeRates() async {
    final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/UAH');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;
      setState(() {
        usdRate = (data['rates']['USD'] as num?)?.toDouble();
        eurRate = (data['rates']['EUR'] as num?)?.toDouble();
        jpyRate = (data['rates']['JPY'] as num?)?.toDouble();
        gbpRate = (data['rates']['GBP'] as num?)?.toDouble();
        cadRate = (data['rates']['CAD'] as num?)?.toDouble();
        cnyRate = (data['rates']['CNY'] as num?)?.toDouble();
        plnRate = (data['rates']['PLN'] as num?)?.toDouble();
      });
    } else {
      throw Exception('Failed to load exchange rates');
    }
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
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Welcome, $_name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/page_home_logo.png',
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            if (!isOnline)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'You are currently offline.',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            if (usdRate != null &&
                eurRate != null &&
                jpyRate != null &&
                gbpRate != null &&
                cadRate != null &&
                cnyRate != null &&
                plnRate != null)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Exchange Rates',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildCurrencyRow(
                          'USD',
                          usdRate,
                          Icons.attach_money,
                          Colors.green,
                        ),
                        _buildCurrencyRow(
                          'EUR',
                          eurRate,
                          Icons.euro,
                          Colors.blue,
                        ),
                        _buildCurrencyRow(
                          'JPY',
                          jpyRate,
                          Icons.currency_yen,
                          Colors.orange,
                        ),
                        _buildCurrencyRow(
                          'GBP',
                          gbpRate,
                          Icons.currency_pound,
                          Colors.purple,
                        ),
                        _buildCurrencyRow(
                          'CAD',
                          cadRate,
                          Icons.money,
                          Colors.cyan,
                        ),
                        _buildCurrencyRow(
                          'CNY',
                          cnyRate,
                          Icons.monetization_on,
                          Colors.red,
                        ),
                        _buildCurrencyRow(
                          'PLN',
                          plnRate,
                          Icons.account_balance_wallet,
                          Colors.teal,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: PageNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildCurrencyRow(
    String currency,
    double? rate,
    IconData icon,
    Color color,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(width: 10),
        Text(
          '1 UAH = ${rate!.toStringAsFixed(2)} $currency',
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
