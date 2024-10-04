import 'package:flutter/material.dart';
import 'package:finance_manager_yankovych_ki_401/gradcon.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradCon(
          [
            Color.fromARGB(2, 110, 119, 223),
            Color.fromARGB(255, 57, 58, 103),
          ],
        ),
      ),
    ),
  );
}
