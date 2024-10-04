import 'package:finance_manager_yankovych_ki_401/page_home.dart';
import 'package:finance_manager_yankovych_ki_401/page_login.dart';
import 'package:finance_manager_yankovych_ki_401/page_profile.dart';
import 'package:finance_manager_yankovych_ki_401/page_register.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;

  const CustomTextField({
    required this.labelText,
    super.key,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(labelText: labelText),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});
  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const PageHome(),
        '/profile': (context) => const PageProfile(),
        '/login': (context) => const PageLogin(),
        '/register': (context) => const PageRegister(),
      },
    );
  }
}

class PageNavigator extends StatelessWidget {
  const PageNavigator({super.key});
  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
        left: 50,
        right: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
            child: Image.asset(
              'assets/images/pagenavigation/page_home.png',
              height: 30,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
            child: Image.asset(
              'assets/images/pagenavigation/page_profile.png',
              height: 60,
            ),
          ),
        ],
      ),
    );
  }
}
