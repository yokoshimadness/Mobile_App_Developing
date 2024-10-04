import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:flutter/material.dart';

class PageLogin extends StatelessWidget {
  const PageLogin({super.key});
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
              const CustomTextField(
                labelText: 'Email',
              ),
              const CustomTextField(
                labelText: 'Password',
                isPassword: true,
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
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
