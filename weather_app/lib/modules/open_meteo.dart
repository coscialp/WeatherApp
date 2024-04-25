import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/modules/request.dart';

class ApiOpenMeteo {
  static const _baseUrlGeocoding = 'https://geocoding-api.open-meteo.com/v1/';
  static const _baseUrl = 'https://api.open-meteo.com/v1/';

  Future<List<WeatherLocation>> getLocations({required String name}) async {
    List<WeatherLocation> locations = [];
    dynamic response = await Request.get(
        Uri.parse("${_baseUrlGeocoding}search?name=$name&count=5"),
        headers: {});

    if (!response.containsKey("results")) {
      return locations;
    }

    for (dynamic location in response["results"]) {
      locations.add(WeatherLocation(
        latitude: location['latitude'],
        longitude: location['longitude'],
        city: location['name'],
        country: location['country'],
        region: location['admin1'] ??
            location['admin2'] ??
            location['admin3'] ??
            location['admin4'] ??
            "",
      ));
    }
    return locations;
  }

  static Future<Weather> getWeather({required WeatherLocation location}) async {
    dynamic response = await Request.get(
        Uri.parse(
            "${_baseUrl}forecast?latitude=${location.latitude}&longitude=${location.longitude}&current=temperature_2m,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max"),
        headers: {});

    return Weather.fromJson(response);
  }
}
