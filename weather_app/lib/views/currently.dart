import 'package:flutter/material.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class CurrentlyView extends StatelessWidget {
  final bool isDark;
  final WeatherLocation? location;
  final HourlyWeather? hourlyWeather;

  const CurrentlyView({
    super.key,
    required this.isDark,
    required this.location,
    required this.hourlyWeather,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  location!.city,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${location!.region}, ${location!.country}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxedIcon(
                  WeatherIcons.thermometer,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text('${hourlyWeather!.temperature}°C',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ],
            ),
            Column(
              children: [
                BoxedIcon(
                  WeatherIcons.fromString(
                    "wi-day-${hourlyWeather!.weatherCode}",
                    fallback: WeatherIcons.na,
                  ),
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(hourlyWeather!.description,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxedIcon(
                  WeatherIcons.fromString(
                    "wi-wind-beaufort-${hourlyWeather!.windSpeed.toInt()}",
                    fallback: WeatherIcons.windy,
                  ),
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text('${hourlyWeather!.windSpeed} km/h'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
