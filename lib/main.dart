import 'package:flutter/material.dart';
import 'package:weather_forecast/screens/main_screen.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/screens/search_city_screen.dart';
import 'package:weather_forecast/services/WeatherService.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  WeatherService service = WeatherService();


  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}

