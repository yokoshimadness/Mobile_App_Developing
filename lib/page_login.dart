import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

class PageLogin extends StatefulWidget {
  const PageLogin({super.key});

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  final LocalStorage storage = SharedPreferencesStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isOnline = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _startListeningToConnectionChanges();
    _checkInitialConnection();
    _checkAutoLogin();
    
  }

  void _checkAutoLogin() async {
    final email = await storage.getData('email');
    final password = await storage.getData('password');
    final isLoggedOutString = await storage.getData('isLoggedOut');

    if (email != null && password != null && isLoggedOutString != 'true' && isOnline) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    else if (email != null && password != null && isLoggedOutString != 'true' && !isOnline) {
  _showNoConnectionDialog();
  Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _checkInitialConnection() async {
    final result = await Connectivity().checkConnectivity();
    setState(() {
      isOnline = result.first != ConnectivityResult.none;
    });
  }

  void _startListeningToConnectionChanges() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      setState(() {
        isOnline = result.first != ConnectivityResult.none;
      });
    });
  }

  void _showLoginSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Login successful!'),
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

  void _showNoConnectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
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
        title: const Text('Login'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isOnline ? 'You are online' : 'No internet connection',
                style: TextStyle(
                  color: isOnline ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              CustomTextField(
                labelText: 'Password',
                isPassword: true,
                controller: passwordController,
              ),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Not registered?',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (isOnline) {
                    final savedEmail = await storage.getData('email');
                    final savedPassword = await storage.getData('password');

                    if (savedEmail == emailController.text &&
                        savedPassword == passwordController.text) {
                      await storage.saveData('isLoggedOut', 'false');
                      setState(() {
                        isLoggedIn = true;
                      });
                      _showLoginSuccessDialog();
                      Navigator.pushNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Login failed.'),
                        ),
                      );
                    }
                  } else {
                    _showNoConnectionDialog();
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}