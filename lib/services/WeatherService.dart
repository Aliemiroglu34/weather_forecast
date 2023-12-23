import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart'; // Yeni import

class WeatherService {
  late Position position;
  String apiKey = "792bc9bdb690b91652c1a2d300d33cc3";

  double latitude = 0.0;
  double longitude = 0.0;
  List<double> longitudeAndLatitudeArray = [];
  late Map<String, dynamic> jsonMapFromCurrentPosition;
  RxString? cityName = "xxx".obs;

  String get ftemps => _ftemps;

  set ftemps(String value) {
    _ftemps = value;
  }

  String _ftemps = "";
  String _fstatu = "";
  String _ficon = "";

  Future<Map<String, dynamic>?> getLatitudeLongitudeFromPosition(
      RxString?cityNameFromSearch) async {
    if (cityNameFromSearch == null) {
      LocationPermission permission = await Geolocator.requestPermission();
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      latitude = position?.latitude ?? 0.0;
      longitude = position?.longitude ?? 0.0;
      longitudeAndLatitudeArray
        ..add(latitude)
        ..add(longitude);
      return await getMapFromCoordinatesFromOtherInfoExceptName();
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?>
      getMapFromCoordinatesFromOtherInfoExceptName() async {
    try {
      String lat = longitudeAndLatitudeArray[0].toString();
      String lon = longitudeAndLatitudeArray[1].toString();
      await getIlFromCoordinates(double.parse(lat), double.parse(lon));
      String showWeatherFromPositionApi =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&lang=tr&units=metric';
      var response = await http.get(Uri.parse(showWeatherFromPositionApi));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<Map<String, dynamic>?> fiveDaysWeatherInfo(
      RxString? cityName, double? lat, double? lon) async {
    if (cityName == null && (lat == null && lon == null)) {
      print("Geçerli bir şehir adı veya koordinat sağlanmalıdır.");
      return null;
    }

    Map<String, dynamic> tempMap;
    try {
      if (cityName != null) {
        String urlForCity =
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&lang=tr&units=metric';
        var response = await http.get(Uri.parse(urlForCity));
        if (response.statusCode == 200) {
          tempMap = jsonDecode(response.body);
          return tempMap;
        }
      } else {
        String urlCoordinate =
            'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&lang=tr&units=metric';
        var response = await http.get(Uri.parse(urlCoordinate));
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
      }
    } catch (e) {
      print("Hata meydana geldi: $e");
    }
    return null;
  }

  Future<void> getIlFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (place.administrativeArea != null) {
          cityName = RxString(place.administrativeArea!);
        } else {
          // Eğer administrativeArea null ise başka bir değer atayabilir veya hata işleme yapabilirsiniz.
          // Örneğin:
          // cityName = RxString("Bilinmeyen Şehir");
        }
      }
    } catch (e) {
      // Hata işleme yapabilirsiniz.
      print("Hata: $e");
    }
  }

  void openingInfoExceptName(Map<String, dynamic>? map) {
    if (map != null) {
      _ftemps = map["main"]["temp"]?.toString() ?? "temp boş";
      _fstatu = map["weather"][0]["main"]?.toString() ?? "statu boş";
      _ficon = map["weather"][0]["icon"]?.toString() ?? "icon boş";
    }
  }

  String get fstatu => _fstatu;

  set fstatu(String value) {
    _fstatu = value;
  }

  String get ficon => _ficon;

  set ficon(String value) {
    _ficon = value;
  }
}
