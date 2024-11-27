// ignore_for_file: use_build_context_synchronously

import 'package:finance_manager_yankovych_ki_401/abstract_storage.dart';
import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:finance_manager_yankovych_ki_401/shared_preferences_storage.dart';
import 'package:flutter/material.dart';

class PageRegister extends StatelessWidget {
  const PageRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = SharedPreferencesStorage();

    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    bool isValidEmail(String email) {
      final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
      return emailRegExp.hasMatch(email);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                labelText: 'Name',
                controller: nameController,
              ),
              CustomTextField(
                labelText: 'Email',
                controller: emailController,
              ),
              CustomTextField(
                labelText: 'Password',
                isPassword: true,
                controller: passwordController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!isValidEmail(emailController.text)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid email address'),
                      ),
                    );
                    return;
                  }

                  await storage.deleteData('transactions');

                  await storage.saveData('name', nameController.text);
                  await storage.saveData('email', emailController.text);
                  await storage.saveData('password', passwordController.text);

                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Already have an account? Log in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
