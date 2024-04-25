const int hoursOfDay = 24;
const int daysOfWeek = 7;

const Map<int, List<String>> weatherDescription = {
  0: ["Clear sky", "sunny"],
  1: ["Mainly clear", "sunny"],
  2: ["Partly cloudy", "cloudy"],
  3: ["Overcast", "sunny-overcast"],
  45: ["Fog", "fog"],
  48: ["Depositing rime fog", "fog"],
  51: ["Light drizzle", "fog"],
  53: ["Drizzle", "fog"],
  55: ["Dense drizzle", "fog"],
  56: ["Light freezing drizzle", "fog"],
  57: ["Dense Freezing drizzle", "fog"],
  61: ["Slight rain", "rain"],
  63: ["Rain", "rain"],
  65: ["Dense rain", "rain"],
  66: ["Light freezing rain", "rain"],
  67: ["Heavy freezing rain", "rain"],
  71: ["Slight snowfall", "snow"],
  73: ["Snowfall", "snow"],
  75: ["Heavy snowfall", "snow"],
  77: ["Snow grains", "fleet"],
  80: ["Slight rain showers", "showers"],
  81: ["Rain showers", "showers"],
  82: ["Violent rain showers", "showers"],
  85: ["Slight snow showers", "snow"],
  86: ["Heavy snow showers", "snow"],
  95: ["Thunderstorm", "thunderstorm"],
  96: ["Thunderstorm with hail", "snow-thunderstorm"],
};

String getWeatherDescription(int code) {
  List<String>? currentWeather = weatherDescription[code];

  if (currentWeather == null) {
    return "Unknown";
  }

  return currentWeather[0];
}

String getWeatherIcon(int code) {
  List<String>? currentWeather = weatherDescription[code];

  if (currentWeather == null) {
    return "unknown";
  }

  return currentWeather.length > 1 ? currentWeather[1] : currentWeather[0];
}

class HourlyWeather {
  final String time;
  final double temperature;
  final String weatherCode;
  final String description;
  final double windSpeed;

  const HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weatherCode,
    required this.description,
    required this.windSpeed,
  });

  HourlyWeather.fromJson(Map<String, dynamic> json)
      : time = json['time'],
        temperature = json['temperature_2m'],
        weatherCode = getWeatherIcon(json['weather_code']),
        description = getWeatherDescription(json['weather_code']),
        windSpeed = json['wind_speed_10m'];

  HourlyWeather.fromJsonByHour(Map<String, dynamic> json, {required int hour})
      : time = json['time'][hour],
        temperature = json['temperature_2m'][hour],
        weatherCode = getWeatherIcon(json['weather_code'][hour]),
        description = getWeatherDescription(json['weather_code'][hour]),
        windSpeed = json['wind_speed_10m'][hour];
}

class DailyWeather {
  final String date;
  final String weatherCode;
  final String description;
  final double minTemperature;
  final double maxTemperature;

  const DailyWeather({
    required this.date,
    required this.weatherCode,
    required this.description,
    required this.minTemperature,
    required this.maxTemperature,
  });

  DailyWeather.fromJsonByDay(Map<String, dynamic> json, {required int day})
      : date = json['time'][day],
        weatherCode = getWeatherIcon(json['weather_code'][day]),
        description = getWeatherDescription(json['weather_code'][day]),
        minTemperature = json['temperature_2m_min'][day],
        maxTemperature = json['temperature_2m_max'][day];
}

class Weather {
  final HourlyWeather current;
  final List<HourlyWeather> today;
  final List<DailyWeather> weekly;

  const Weather({
    required this.current,
    required this.today,
    required this.weekly,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<HourlyWeather> today = [];
    List<DailyWeather> weekly = [];

    for (int index = 0; index < hoursOfDay; index++) {
      today.add(HourlyWeather.fromJsonByHour(json["hourly"], hour: index));
    }

    for (int index = 0; index < daysOfWeek; index++) {
      weekly.add(DailyWeather.fromJsonByDay(json["daily"], day: index));
    }

    return Weather(
      current: HourlyWeather.fromJson(json['current']),
      today: today,
      weekly: weekly,
    );
  }
}
