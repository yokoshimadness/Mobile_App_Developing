import 'package:flutter/material.dart';
import 'package:finance_manager_yankovych_ki_401/weather_changer.dart';

var sAlignment = Alignment.topRight;
var eAlignment = Alignment.bottomLeft;

class GradCon extends StatelessWidget{
  const GradCon(this.colors, {super.key});

  final List<Color> colors;

  @override
  Widget build(context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient:LinearGradient(
          colors: colors,
          begin: sAlignment,
          end: eAlignment,
        ),
      ),
      child: const Center(
        child: WeatherChanger(),
        ),
    );
  }
}
