import 'package:finance_manager_yankovych_ki_401/page_home.dart';
import 'package:finance_manager_yankovych_ki_401/page_login.dart';
import 'package:finance_manager_yankovych_ki_401/page_profile.dart';
import 'package:finance_manager_yankovych_ki_401/page_register.dart';
import 'package:finance_manager_yankovych_ki_401/page_transactions.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    required this.labelText,
    required this.controller,
    super.key,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(labelText: labelText),
      style: const TextStyle(color: Colors.white),
    );
  }
}

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => const PageHome(),
        '/profile': (context) => const PageProfile(),
        '/login': (context) => const PageLogin(),
        '/register': (context) => const PageRegister(),
        '/transactions': (context) => const PageTransactions(),
      },
    );
  }
}

class PageNavigator extends StatelessWidget {
  const PageNavigator({
    required this.selectedIndex,
    required this.onItemTapped,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
              AssetImage('assets/images/pagenavigation/page_home.png'),
              size: 30,),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
              AssetImage('assets/images/pagenavigation/page_transactions.png'),
              size: 30,),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
              AssetImage('assets/images/pagenavigation/page_profile.png'),
              size: 30,),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
