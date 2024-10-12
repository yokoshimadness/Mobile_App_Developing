import 'dart:convert';
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

  @override
  void initState() {
    super.initState();
    _loadTransactions();
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
                          _addTransaction('Income');
                        },
                        child: const Text('Add Income'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _addTransaction('Expense');
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
