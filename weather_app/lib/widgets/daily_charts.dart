import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:weather_final_proj/models/weather.dart';

class DailyCharts extends StatelessWidget {
  final List<HourlyWeather> weathers;

  const DailyCharts({super.key, required this.weathers});

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
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: const SideTitles(showTitles: false),
              axisNameSize: 25,
              axisNameWidget: Text(
                "Temperature (°C) by Hours",
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
                interval: 3,
                showTitles: true,
                getTitlesWidget: (value, titleMeta) => Text(
                  '${value.toInt()}:00',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          minX: 0,
          maxX: 24,
          minY: min(
            weathers.map((weather) => weather.temperature).reduce(min),
            weathers.map((weather) => weather.temperature).reduce(min).toInt() -
                4,
          ),
          maxY: max(
            weathers.map((weather) => weather.temperature).reduce(max),
            weathers.map((weather) => weather.temperature).reduce(max).toInt() +
                4,
          ),
          lineBarsData: [
            LineChartBarData(
              color: Theme.of(context).colorScheme.primary,
              spots: weathers
                  .map(
                    (weather) => FlSpot(
                      double.parse(
                        weather.time.split("T")[1].split(":")[0],
                      ),
                      weather.temperature,
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
          ],
        ),
      ),
    );
  }
}
