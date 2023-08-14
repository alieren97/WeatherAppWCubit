import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/constants/constants.dart';
import 'package:open_weather_cubit/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:open_weather_cubit/cubits/weather/weather_cubit.dart';
import 'package:open_weather_cubit/models/weather.dart';
import 'package:open_weather_cubit/pages/search_page.dart';
import 'package:open_weather_cubit/pages/settins_page.dart';
import 'package:open_weather_cubit/widgets/error_dialog.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          actions: [
            IconButton(
              onPressed: () async {
                city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }));
                if (city != null) {
                  context.read<WeatherCubit>().fetchWeather(city!);
                }
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }));
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: _showWeather());
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toString() + '°F';
    }
    return temperature.toStringAsFixed(2) + '°C';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 48,
      height: 48,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.toTitleCase();
    return Text(
      formattedString,
      style: TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(builder: (context, state) {
      if (state.weatherStatus == WeatherStatus.initial) {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(fontSize: 20.0),
          ),
        );
      }
      if (state.weatherStatus == WeatherStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.weatherStatus == WeatherStatus.error &&
          state.weather.name == '') {
        return const Center(
          child: Text(
            'Select a city',
            style: TextStyle(fontSize: 20),
          ),
        );
      }

      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          Text(
            state.weather.name,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                TimeOfDay.fromDateTime(state.weather.lastUpdated)
                    .format(context),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                '${state.weather.country}',
                style: TextStyle(fontSize: 18.0),
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                showTemperature(state.weather.temp),
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 20.0,
              ),
              Column(
                children: [
                  Text(
                    showTemperature(state.weather.tempMax),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    showTemperature(state.weather.tempMin),
                    style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(),
              showIcon(state.weather.icon),
              Expanded(
                flex: 3,
                child: formatText(state.weather.description),
              ),
              Spacer(),
            ],
          )
        ],
      );
    }, listener: (context, state) {
      if (state.weatherStatus == WeatherStatus.error) {
        errorDialog(context, state.error.errMsg);
      }
    });
  }
}
