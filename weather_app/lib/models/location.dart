import 'package:geocoding/geocoding.dart';

class WeatherLocation {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final String region;

  const WeatherLocation({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    required this.region,
  });

  WeatherLocation.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        city = json['city'],
        country = json['country'],
        region = json['region'];

  WeatherLocation.fromPlacemark({
    required Placemark placemark,
    required this.latitude,
    required this.longitude,
  })  : city = placemark.locality!,
        country = placemark.country!,
        region = placemark.administrativeArea!;
}
