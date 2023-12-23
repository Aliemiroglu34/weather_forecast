import 'package:get/get.dart';

class Weather {
  RxString? cityName;
  RxString temp;
  RxString status;
  RxString icon;
  RxString wDate;

  Weather({
    required this.cityName,
    required this.temp,
    required this.status,
    required this.icon,
    required this.wDate,
  });

  @override
  String toString() {
    return 'Weather(cityName: $cityName, temp: $temp, status: $status, icon: $icon, date: $wDate)';
  }
}
