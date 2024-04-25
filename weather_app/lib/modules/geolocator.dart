import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCoordinates() async {
  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied) {
    throw 'Permission denied';
  } else if (permission == LocationPermission.deniedForever) {
    throw 'Permission denied forever';
  } else {
    return await Geolocator.getCurrentPosition();
  }
}

Future<List<Placemark>> getPlacemarks({
  required double lat,
  required double lon,
}) async {
  LocationPermission permission = await Geolocator.requestPermission();
  if ([
    LocationPermission.denied,
    LocationPermission.deniedForever,
  ].contains(permission)) {
    return [];
  }
  return await placemarkFromCoordinates(lat, lon);
}
