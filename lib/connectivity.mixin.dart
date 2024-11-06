import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  bool isOnline = true;
  
  @override
  void initState() {
    super.initState();
    _startListeningToConnectionChanges();
    _checkInitialConnection();
  }

  void _startListeningToConnectionChanges() {
  // Listen for connectivity changes
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> resultList) {
    setState(() {
      isOnline = resultList.isNotEmpty && resultList.first != ConnectivityResult.none; // Update status
    });

    // Show no connection dialog if disconnected
    if (!isOnline) {
      _showNoConnectionDialog();
    }
  });
}

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result != ConnectivityResult.none;
    });
  }

  void _showNoConnectionDialog() {
    if (!isOnline) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text('You have lost connection. Please check your internet and try again.'),
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
  }
}
