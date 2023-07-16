import 'package:flutter/material.dart';
import 'package:weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({Key? key}) : super(key: key);

  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late Weather? _weather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _weather = snapshot.data!;
              return weatherBox(_weather!);
            } else {
              return const CircularProgressIndicator();
            }
          },
          future: getCurrentWeather(),
        ),
      ),
    );
  }
}

Widget weatherBox(Weather weather) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        child: Text(
          "${weather.temp}°C",
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 55),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text(weather.description),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("Feels:${weather.feelsLike}°C"),
      ),
      Container(
        margin: const EdgeInsets.all(5.0),
        child: Text("H:${weather.high}°C L:${weather.low}°C"),
      ),
    ],
  );
}

Future<Weather> getCurrentWeather() async {
  Weather weather;
  String city = "miami";
  String apiKey = "8231c946ec04e70b9da991615e7ebfaf";
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    } else {
      // Handle non-200 status code, e.g., by throwing an exception
      throw Exception('Failed to fetch weather data');
    }
  } catch (error) {
    // Handle any error that occurred during the HTTP request
    print('Error: $error');
    throw Exception('Failed to fetch weather data');
  }

  return weather;
}
