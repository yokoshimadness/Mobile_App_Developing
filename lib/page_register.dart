import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:flutter/material.dart';

class PageRegister extends StatelessWidget {
  const PageRegister({super.key});
  @override
  Widget build(BuildContext context) {
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
              const CustomTextField(
                labelText: 'Name',
              ),
              const CustomTextField(
                labelText: 'Email',
              ),
              const CustomTextField(
                labelText: 'Password',
                isPassword: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
