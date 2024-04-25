import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/modules/geolocator.dart';
import 'package:weather_final_proj/modules/open_meteo.dart';

class GeolocatorButton extends StatefulWidget {
  final ValueChanged<WeatherLocation?> onLocationChange;
  final ValueChanged<Weather?> onWeatherChange;

  const GeolocatorButton({
    super.key,
    required this.onLocationChange,
    required this.onWeatherChange,
  });

  @override
  State<GeolocatorButton> createState() => _GeolocatorButtonState();
}

class _GeolocatorButtonState extends State<GeolocatorButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        try {
          Position coordinates = await getCoordinates();

          List<dynamic> placemarks = await getPlacemarks(
            lat: coordinates.latitude,
            lon: coordinates.longitude,
          );
          WeatherLocation location = WeatherLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude,
            city: placemarks[0].locality,
            country: placemarks[0].country,
            region: placemarks[0].administrativeArea,
          );

          Weather weather = await ApiOpenMeteo.getWeather(location: location);
          setState(() {
            widget.onLocationChange(location);
            widget.onWeatherChange(weather);
          });
        } catch (e) {
          setState(() {
            widget.onLocationChange(null);
            widget.onWeatherChange(null);
          });
        }
      },
      icon: const Icon(Icons.location_on),
    );
  }
}
