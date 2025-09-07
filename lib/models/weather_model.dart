import 'package:flutter/material.dart';

class WeatherModel {
  DateTime date;
  double temp;
  double maxTemp;
  double minTemp;
  String weatherStateName;

  WeatherModel({
    required this.date,
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherStateName,
  });

  factory WeatherModel.fromJson(dynamic data) {
    var jsonData = data['forecast']['forecastday'][0]['day'];

    return WeatherModel(
      date: DateTime.parse(data['current']['last_updated']),
      temp: jsonData['avgtemp_c'],
      maxTemp: jsonData['maxtemp_c'],
      minTemp: jsonData['mintemp_c'],
      weatherStateName: jsonData['condition']['text'],
    );
  }

  @override
  String toString() {
    return 'temp = $temp  minTemp = $minTemp  date = $date';
  }

  String getImage() {
    String state = weatherStateName.toLowerCase();

    if (state.contains('sun') ||
        state.contains('clear') ||
        state.contains('partly')) {
      return 'assets/images/clear.png';
    } else if (state.contains('snow') || state.contains('blizzard')) {
      return 'assets/images/snow.png';
    } else if (state.contains('cloud') ||
        state.contains('fog') ||
        state.contains('mist')) {
      return 'assets/images/cloudy.png';
    } else if (state.contains('rain') || state.contains('showers')) {
      return 'assets/images/rainy.png';
    } else if (state.contains('thunder')) {
      return 'assets/images/thunderstorm.png';
    } else {
      return 'assets/images/clear.png';
    }
  }

  MaterialColor getThemeColor() {
    String state = weatherStateName.toLowerCase();

    if (state.contains('sun') ||
        state.contains('clear') ||
        state.contains('partly')) {
      return Colors.orange;
    } else if (state.contains('snow') || state.contains('blizzard')) {
      return Colors.blue;
    } else if (state.contains('cloud') ||
        state.contains('fog') ||
        state.contains('mist')) {
      return Colors.blueGrey;
    } else if (state.contains('rain') || state.contains('showers')) {
      return Colors.blue;
    } else if (state.contains('thunder')) {
      return Colors.deepPurple;
    } else {
      return Colors.orange;
    }
  }
}
