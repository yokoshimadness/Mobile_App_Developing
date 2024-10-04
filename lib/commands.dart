import 'package:flutter/material.dart';

class WeatherCommands extends StatelessWidget {
  const WeatherCommands(this.weatherCommand, {super.key});

  final String weatherCommand;

  @override
  Widget build(context) {
    return Text(
      weatherCommand,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
