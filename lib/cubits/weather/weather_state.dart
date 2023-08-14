// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_cubit.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus weatherStatus;
  final Weather weather;
  final CustomError error;
  WeatherState({
    required this.weatherStatus,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() {
    return WeatherState(
        weatherStatus: WeatherStatus.initial,
        weather: Weather.initial(),
        error: CustomError());
  }

  @override
  List<Object?> get props => [weatherStatus, weather, error];

  @override
  String toString() =>
      'WeatherState(status: $weatherStatus, weather: $weather, error: $error';

  WeatherState copyWith({
    WeatherStatus? weatherStatus,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }
}
