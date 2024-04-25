import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_final_proj/models/weather.dart';

class WeeklyCharts extends StatelessWidget {
  final List<DailyWeather> weathers;

  const WeeklyCharts({super.key, required this.weathers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 12, left: 8, right: 16),
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(18),
        ),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      child: LineChart(
        duration: const Duration(milliseconds: 150), // Optional
        curve: Curves.linear, // Optional
        LineChartData(
          betweenBarsData: [
            BetweenBarsData(
              fromIndex: 0,
              toIndex: 1,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
            ),
          ],
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: const SideTitles(showTitles: false),
              axisNameSize: 25,
              axisNameWidget: Text(
                "Min/Max Temperature (°C) by Day",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 2,
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, titleMeta) => Text(
                  '${value.toInt()}°C',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, titleMeta) => Text(
                  "${weathers[value.toInt()].date.split("-")[1]}/${weathers[value.toInt()].date.split("-")[2]}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          minY: min(
            weathers.map((weather) => weather.minTemperature).reduce(min),
            weathers
                    .map((weather) => weather.minTemperature)
                    .reduce(min)
                    .toInt() -
                4,
          ),
          maxY: max(
            weathers.map((weather) => weather.maxTemperature).reduce(max),
            weathers
                    .map((weather) => weather.maxTemperature)
                    .reduce(max)
                    .toInt() +
                4,
          ),
          lineBarsData: [
            LineChartBarData(
              color: Theme.of(context).colorScheme.primary,
              spots: weathers
                  .map(
                    (weather) => FlSpot(
                      weathers.indexOf(weather).toDouble(),
                      weather.minTemperature,
                    ),
                  )
                  .toList(),
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: Theme.of(context).colorScheme.onPrimary,
                  strokeWidth: 2,
                  strokeColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            LineChartBarData(
              color: Theme.of(context).colorScheme.tertiary,
              spots: weathers
                  .map(
                    (weather) => FlSpot(
                      weathers.indexOf(weather).toDouble(),
                      weather.maxTemperature,
                    ),
                  )
                  .toList(),
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: Theme.of(context).colorScheme.onTertiary,
                  strokeWidth: 2,
                  strokeColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
