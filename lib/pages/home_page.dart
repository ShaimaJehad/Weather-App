import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_cubit/weather_state.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/search_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        WeatherModel? weatherData;
        if (state is WeatherSuccess) {
          weatherData = state.weatherModel;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Weather App'),
            backgroundColor: (state is WeatherSuccess)
                ? weatherData!.getThemeColor()
                : Colors.blue,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          body: () {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherFailure) {
              return const Center(
                child: Text('Something went wrong, please try again'),
              );
            } else if (state is WeatherSuccess) {
              return SuccessBody(weatherData: weatherData!);
            } else {
              return const DefaultBody();
            }
          }(),
        );
      },
    );
  }
}

class DefaultBody extends StatelessWidget {
  const DefaultBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('There is no weather 😔 start', style: TextStyle(fontSize: 30)),
          Text('Searching now 🔍', style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}

class SuccessBody extends StatelessWidget {
  const SuccessBody({super.key, required this.weatherData});

  final WeatherModel weatherData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            weatherData.getThemeColor(),
            weatherData.getThemeColor()[300]!,
            weatherData.getThemeColor()[100]!,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          Text(
            BlocProvider.of<WeatherCubit>(context).cityName ?? 'Unknown',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          Text(
            'Updated at: ${weatherData.date.hour.toString().padLeft(2, '0')}:${weatherData.date.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 22),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(weatherData.getImage()),
              Text(
                weatherData.temp.toInt().toString(),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Text('Max: ${weatherData.maxTemp.toInt()}'),
                  Text('Min: ${weatherData.minTemp.toInt()}'),
                ],
              ),
            ],
          ),
          const Spacer(),
          Text(
            weatherData.weatherStateName,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
