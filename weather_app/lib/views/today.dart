import 'package:flutter/material.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/widgets/daily_charts.dart';
import 'package:weather_icons/weather_icons.dart';

class TodayView extends StatefulWidget {
  final WeatherLocation? location;
  final List<HourlyWeather> weathers;

  const TodayView({
    super.key,
    required this.location,
    required this.weathers,
  });

  @override
  State<TodayView> createState() => _TodayViewState();
}

class _TodayViewState extends State<TodayView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                Text(
                  widget.location!.city,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${widget.location!.region}, ${widget.location!.country}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            DailyCharts(weathers: widget.weathers),
            RawScrollbar(
              controller: _scrollController,
              thumbColor: Theme.of(context).colorScheme.primary,
              thumbVisibility: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.weathers
                        .map((weather) => Padding(
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(weather.time.split("T")[1]),
                                  BoxedIcon(
                                    WeatherIcons.fromString(
                                      "wi-day-${weather.weatherCode}",
                                      fallback: WeatherIcons.na,
                                    ),
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BoxedIcon(
                                        WeatherIcons.thermometer,
                                        size: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      Text('${weather.temperature}°C',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      BoxedIcon(
                                        WeatherIcons.fromString(
                                          "wi-wind-beaufort-${weather.windSpeed.toInt()}",
                                          fallback: WeatherIcons.windy,
                                        ),
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      Text('${weather.windSpeed}km/h'),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
