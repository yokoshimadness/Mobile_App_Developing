import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/page_home_logo.png'),
              width: 300,
              height: 300,
            ),
            Text('Home Page', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
      bottomNavigationBar: const PageNavigator(),
    );
  }
}
