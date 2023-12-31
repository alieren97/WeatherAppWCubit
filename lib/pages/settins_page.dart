import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_cubit/cubits/temp_settings/temp_settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          title: Text("Temperature Unit"),
          subtitle: Text("Celcius/Fahrenheit (Default: Celcius"),
          trailing: Switch(
              value: context.watch<TempSettingsCubit>().state.tempUnit ==
                  TempUnit.celsius,
              onChanged: (_) {
                context.read<TempSettingsCubit>().toggleTempUnit();
              }),
        ),
      ),
    );
  }
}
