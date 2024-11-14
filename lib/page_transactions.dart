// ignore_for_file: inference_failure_on_function_invocation, unrelated_type_equality_checks, lines_longer_than_80_chars

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

class PageTransactions extends StatefulWidget {
  const PageTransactions({super.key});

  @override
  State<PageTransactions> createState() => _PageTransactionsState();
}

class _PageTransactionsState extends State<PageTransactions> {
  final LocalStorage storage = SharedPreferencesStorage();
  List<Map<String, String>> _transactions = [];
  bool _isAddingTransaction = false;

  String _amount = '';
  String _description = '';

  int _selectedIndex = 1;
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _checkInitialConnection();
    _startListeningToConnectionChanges();
  }

  void _loadTransactions() async {
    final storedTransactions = await storage.getData('transactions');
    if (storedTransactions != null) {
      setState(() {
        _transactions = (json.decode(storedTransactions) as List<dynamic>)
            .map((item) => Map<String, String>.from(item as Map))
            .toList();
      });
    }
    _calculateTotals();
  }

  void _calculateTotals() async {
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in _transactions) {
      final amount = double.tryParse(transaction['amount'] ?? '0') ?? 0;
      if (transaction['type'] == 'Income') {
        totalIncome += amount;
      } else if (transaction['type'] == 'Expense') {
        totalExpense += amount;
      }
    }

    await storage.saveData('totalIncome', totalIncome.toString());
    await storage.saveData('totalExpense', totalExpense.toString());
  }

  void _saveTransactions() async {
    await storage.saveData('transactions', json.encode(_transactions));
  }

  void _addTransaction(String type) {
    if (_amount.isNotEmpty) {
      setState(() {
        _transactions.add({
          'type': type,
          'amount': _amount,
          'description': _description,
        });
        _isAddingTransaction = false;
        _amount = '';
        _description = '';

        _saveTransactions();
        _calculateTotals();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
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
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection to use the app.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(
                    '${transaction['type']} - \$${transaction['amount']}',
                  ),
                  subtitle: Text(transaction['description'] ?? ''),
                );
              },
            ),
          ),
          if (_isAddingTransaction)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Amount'),
                    onChanged: (value) {
                      _amount = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) {
                      _description = value;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (isOnline) {
                            _addTransaction('Income');
                          } else {
                            _showNoConnectionDialog();
                          }
                        },
                        child: const Text('Add Income'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (isOnline) {
                            _addTransaction('Expense');
                          } else {
                            _showNoConnectionDialog();
                          }
                        },
                        child: const Text('Add Expense'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAddingTransaction = !_isAddingTransaction;
              });
            },
            child: Text(_isAddingTransaction ? 'Cancel' : 'Add Transaction'),
          ),
        ],
      ),
      bottomNavigationBar: PageNavigator(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
