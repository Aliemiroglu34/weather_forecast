import 'package:get/get.dart';

class WeatherController extends GetxController {
  // Değişkenlerin tanımlanması
  var icon = RxString("");
  var status = RxString("");
  var temp = RxString("");
  var vDate = RxString("");

  // Bu fonksiyon, yeni değerlerle değişkenleri günceller.
  void updateWeatherData({
    required RxString newIcon,
    required RxString newStatus,
    required RxString newTemp,
    required RxString newDate,
  }) {
    icon = newIcon;
    status = newStatus;
    temp = newTemp;
    vDate = newDate;
  }
}
