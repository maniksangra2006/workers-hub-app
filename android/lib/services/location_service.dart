import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as gc;

class LocationService {
  static Future<({double lat, double lng, String address})> getCurrent() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    final pos = await Geolocator.getCurrentPosition();
    final placemarks = await gc.placemarkFromCoordinates(pos.latitude, pos.longitude);
    final p = placemarks.first;
    final address =
        '${p.name}, ${p.locality}, ${p.subAdministrativeArea}, ${p.administrativeArea}';
    return (lat: pos.latitude, lng: pos.longitude, address: address);
  }
}
