import 'package:flutter/material.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/widgets/weekly_charts.dart';
import 'package:weather_icons/weather_icons.dart';

class WeeklyView extends StatefulWidget {
  final WeatherLocation? location;
  final List<DailyWeather> weathers;

  const WeeklyView({
    super.key,
    required this.location,
    required this.weathers,
  });

  @override
  State<WeeklyView> createState() => _WeeklyViewState();
}

class _WeeklyViewState extends State<WeeklyView> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
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
            WeeklyCharts(weathers: widget.weathers),
            RawScrollbar(
              controller: _scrollController,
              thumbColor: Theme.of(context).colorScheme.primary,
              thumbVisibility: true,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.weathers
                        .map(
                          (weather) => Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 4.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    "${weather.date.split("-")[1]}/${weather.date.split("-")[2]}"),
                                BoxedIcon(
                                  WeatherIcons.fromString(
                                    "wi-day-${weather.weatherCode}",
                                    fallback: WeatherIcons.na,
                                  ),
                                  size: 20,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BoxedIcon(
                                      WeatherIcons.direction_up,
                                      size: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    Text(
                                      '${weather.maxTemperature}°C',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BoxedIcon(
                                      WeatherIcons.direction_down,
                                      size: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                    Text(
                                      '${weather.minTemperature}°C',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
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
