import 'dart:convert';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage implements LocalStorage {
  @override
  Future<void> saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<void> deleteData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  Future<void> saveTransactions(List<Map<String, String>> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final String transactionsJson = jsonEncode(transactions);
    await prefs.setString('transactions', transactionsJson);
  }

  @override
  Future<List<Map<String, String>>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsString = prefs.getString('transactions');

    if (transactionsString != null) {
      final List<dynamic> jsonList = jsonDecode(
        transactionsString,
      ) as List<dynamic>;
      return jsonList
          .map(
            (json) => Map<String, String>.from(json as Map),
          )
          .toList();
    }
    return [];
  }

  Future<void> clearTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions');
  }
}
