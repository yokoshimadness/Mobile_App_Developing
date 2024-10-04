import 'package:flutter/material.dart';
import 'package:finance_manager_yankovych_ki_401/commands.dart';

class WeatherChanger extends StatefulWidget {
  const WeatherChanger({super.key});
  @override
  State<WeatherChanger> createState() {
    return _WeatherChangerState();
  }
}

class _WeatherChangerState extends State<WeatherChanger> {
  final TextEditingController controller = TextEditingController();
  String image = 'assets/images/start.png';

  void changeWeather() {
    setState(() {
      final String input = controller.text.toLowerCase();
      if (input == 'rain') {
        image = 'assets/images/rain.png';
      } else if (input == 'snow') {
        image = 'assets/images/snow.jpg';
      } else if (input == 'cloud') {
        image = 'assets/images/cloud.png';
      } else if (input == 'sun') {
        image = 'assets/images/sun.png';
      } else if (input == 'thunderstorm') {
        image = 'assets/images/thunderstorm.png';
      } else if (input == 'fog') {
        image = 'assets/images/fog.png';
      } else {
        image = 'assets/images/error.png';
      }
      controller.clear();
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            width: 300,
            height: 300,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter weather type',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: changeWeather,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              backgroundColor: const Color.fromARGB(255, 82, 90, 86),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              textStyle: const TextStyle(
                fontSize: 25,
              ),
            ),
            child: const Text('Change Weather'),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                Text(
                  'Commands:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherCommands('sun'),
                    Spacer(flex: 2),
                    WeatherCommands('rain'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherCommands('cloud'),
                    Spacer(flex: 2),
                    WeatherCommands('snow'),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WeatherCommands('thunderstorm'),
                    Spacer(flex: 2),
                    WeatherCommands('fog'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
