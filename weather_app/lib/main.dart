import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_final_proj/models/location.dart';
import 'package:weather_final_proj/models/weather.dart';
import 'package:weather_final_proj/modules/geolocator.dart';
import 'package:weather_final_proj/modules/open_meteo.dart';
import 'package:weather_final_proj/views/currently.dart';
import 'package:weather_final_proj/views/today.dart';
import 'package:weather_final_proj/views/weekly.dart';
import 'package:weather_final_proj/widgets/geolocator_button.dart';
import 'package:weather_final_proj/widgets/loaders.dart';
import 'package:weather_final_proj/widgets/search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _firstLoad = true;
  bool _hasPermission = true;
  DateTime timeNow = DateTime.now();
  WeatherLocation? _location;

  Weather? _weather;

  void onLocationChange(WeatherLocation? location) {
    setState(() {
      _location = location;
    });
  }

  void onWeatherChange(Weather? weather) {
    setState(() {
      _weather = weather;
    });
  }

  late bool isDark = timeNow.hour > 18 || timeNow.hour < 6;

  final Future<WeatherLocation> _coordinates = Future.delayed(
    const Duration(seconds: 1),
    () async {
      Position coordinates = await getCoordinates();

      List<Placemark> placemarks = await getPlacemarks(
        lat: coordinates.latitude,
        lon: coordinates.longitude,
      );
      return WeatherLocation.fromPlacemark(
        latitude: coordinates.latitude,
        longitude: coordinates.longitude,
        placemark: placemarks[0],
      );
    },
  );

  late final Future<Weather> _weatherData = Future.delayed(
    const Duration(seconds: 1),
    () async {
      WeatherLocation location = await _coordinates;
      return await ApiOpenMeteo.getWeather(location: location);
    },
  );

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Currently', icon: Icon(Icons.sunny)),
    Tab(text: 'Today', icon: Icon(Icons.today)),
    Tab(text: 'Weekly', icon: Icon(Icons.calendar_month)),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      timeNow = DateTime.now();
    });
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.wait([_coordinates, _weatherData]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasError) {
            _hasPermission = false;
          }
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: isDark
                      ? const AssetImage('assets/images/night.png')
                      : const AssetImage('assets/images/after_noon.png'),
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  Expanded(
                      child: WeatherSearchBar(
                    onLocationChange: onLocationChange,
                    onWeatherChange: onWeatherChange,
                  )),
                  VerticalDivider(
                      color: Theme.of(context).colorScheme.onSurface,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15),
                  GeolocatorButton(
                    onLocationChange: onLocationChange,
                    onWeatherChange: onWeatherChange,
                  ),
                ],
              ),
              body: TabBarView(
                controller: _tabController,
                children: tabs.map((Tab tab) {
                  if (snapshot.hasData && _firstLoad) {
                    _location = snapshot.data[0];
                    _weather = snapshot.data[1];
                    _firstLoad = false;
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const MainLoader();
                  }

                  if (!_hasPermission &&
                      (_location == null || _weather == null)) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "No permission to access location\n"
                          "Please enable location access in settings or use the search bar",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    );
                  }

                  if (_location == null || _weather == null) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "Something went wrong with the API. Please try again later.",
                          style: TextStyle(fontSize: 20, color: Colors.red),
                        ),
                      ),
                    );
                  }

                  switch (tab.text) {
                    case 'Currently':
                      return CurrentlyView(
                        isDark: isDark,
                        location: _location,
                        hourlyWeather: _weather?.current,
                      );
                    case 'Today':
                      return TodayView(
                        location: _location,
                        weathers: _weather?.today ?? [],
                      );
                    case 'Weekly':
                      return WeeklyView(
                        location: _location,
                        weathers: _weather?.weekly ?? [],
                      );
                    default:
                      return const Center(child: Text("Currently\n"));
                  }
                }).toList(),
              ),
              bottomNavigationBar: TabBar(
                controller: _tabController,
                tabs: tabs,
              ),
            ),
          );
        },
      ),
    );
  }
}
