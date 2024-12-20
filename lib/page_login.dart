// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, lines_longer_than_80_chars

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flashlight_plugin/flashlight_plugin.dart';
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
  bool isFlashlightOn = false; // Додаємо змінну для відстеження стану ліхтарика

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

    if (email != null &&
        password != null &&
        isLoggedOutString != 'true' &&
        isOnline) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (email != null &&
        password != null &&
        isLoggedOutString != 'true' &&
        !isOnline) {
      _showNoConnectionDialog();
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _checkInitialConnection() async {
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
    });
  }

  void _showLoginSuccessDialog() {
    // ignore: inference_failure_on_function_invocation
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

  void toggleFlashlight(BuildContext context) {
    setState(() {
      isFlashlightOn = !isFlashlightOn;
    });
    FlashlightPlugin.toggleFlashlight(enable: isFlashlightOn).then((_) {
      final statusMessage =
          isFlashlightOn ? 'The flashlight is on!' : 'The flashlight is off!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            statusMessage,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Flashlight not supported on this platform.'),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showNoConnectionDialog() {
    // ignore: inference_failure_on_function_invocation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text(
            'Please check your internet connection and try again.',
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
        title: const Text('Login'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              isFlashlightOn ? Icons.wb_sunny : Icons.wb_sunny_outlined,
              color: isFlashlightOn ? Colors.yellow : Colors.grey,
            ),
            onPressed: () => toggleFlashlight(context),
          ),
        ],
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
