import 'package:finance_manager_yankovych_ki_401/imp_widgets.dart';
import 'package:flutter/material.dart';

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Image(
                    image: AssetImage('assets/images/profile-user.png'),
                    width: 150,
                    height: 150,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('User Profile', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                ),
              ],
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Info about user', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const PageNavigator(),
    );
  }
}
