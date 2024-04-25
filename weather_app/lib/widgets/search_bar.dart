import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/modules/open_meteo.dart';

class WeatherSearchBar extends StatefulWidget {
  final ValueChanged<WeatherLocation> onLocationChange;
  final ValueChanged<Weather> onWeatherChange;

  const WeatherSearchBar({
    super.key,
    required this.onLocationChange,
    required this.onWeatherChange,
  });

  @override
  State<WeatherSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<WeatherSearchBar> {
  List<WeatherLocation> _locationsSuggestions = [];

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<WeatherLocation>(
      hideOnEmpty: true,
      errorBuilder: (context, error) {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Something went wrong, look your internet connection and try again.',
            style: TextStyle(color: Colors.red),
          ),
        );
      },
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Search location',
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
                icon: const Icon(Icons.clear), onPressed: controller.clear),
          ),
        );
      },
      itemBuilder: (context, WeatherLocation suggestion) {
        return Column(
          children: [
            ListTile(
              trailing: const Icon(Icons.location_on),
              title: Row(
                children: <Widget>[
                  const Icon(Icons.location_city),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      suggestion.city,
                      style: TextStyle(
                        fontSize: suggestion.city.length > 20
                            ? max((40 - suggestion.city.length).toDouble(), 10)
                            : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text('${suggestion.region}, ${suggestion.country}'),
            ),
            const Divider(),
          ],
        );
      },
      onSelected: (WeatherLocation suggestion) async {
        Weather weather = await ApiOpenMeteo.getWeather(location: suggestion);
        setState(() {
          widget.onLocationChange(suggestion);
          widget.onWeatherChange(weather);
        });
      },
      suggestionsCallback: (pattern) async {
        try {
          _locationsSuggestions =
              await ApiOpenMeteo().getLocations(name: pattern);
        } catch (e) {
          debugPrint(e.toString());
          rethrow;
        }
        return _locationsSuggestions;
      },
    );
  }
}
