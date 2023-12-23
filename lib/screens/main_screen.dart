import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_forecast/screens/search_city_screen.dart';
import 'package:weather_forecast/widgets/main_screen_widgets/main_page_list_weather_card.dart';
import '../controllers/weathere_controller.dart';
import '../models/waether_model.dart';
import '../services/WeatherService.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final weatherController = Get.put(WeatherController());
  Map<String, dynamic> openingMap = {};

  WeatherService service = WeatherService();
  Map<String, dynamic> fiveDaysMap = {};
  List<Weather> weatherList = [];
  RxList<Widget> cards = <Widget>[].obs;
  Future<void>? _asynchronousFunctionFuture;
  RxString result = "".obs;

  @override
  void initState() {
    super.initState();
    _asynchronousFunctionFuture = _asynchronousFunctions(
        cityName: service.cityName?.value == "xxx" ? null : service.cityName);
  }

  Future<void> _asynchronousFunctions({RxString? cityName}) async {
    weatherList.clear();
    cards.clear();
    if (cityName == null) {
      var resultFromPosition =
          await service.getLatitudeLongitudeFromPosition(cityName);
      if (resultFromPosition != null) {
        openingMap = resultFromPosition;
        service.openingInfoExceptName(openingMap);

        fiveDaysMap =
            (await service.fiveDaysWeatherInfo(service.cityName, null, null))!;
        if (fiveDaysMap['list'] != null) {
          List<dynamic> havaTahminleri = fiveDaysMap['list'];
          int kayitAdim = 8;

          for (int i = 0; i < havaTahminleri.length; i += kayitAdim) {
            RxString temp = (havaTahminleri[i]['main']['temp'].toString()).obs;

            RxString status =
                (havaTahminleri[i]['weather'][0]['main'] as String).obs;
            RxString icon =
                (havaTahminleri[i]['weather'][0]['icon'] as String).obs;
            RxString tDate = DateTime.fromMillisecondsSinceEpoch(
                    havaTahminleri[i]['dt'] * 1000)
                .toString()
                .obs;

            weatherController.updateWeatherData(
                newIcon: icon,
                newStatus: status,
                newTemp: temp,
                newDate: tDate);
            Weather weatherItem = Weather(
                cityName: cityName,
                temp: temp,
                status: status,
                icon: icon,
                wDate: tDate);
            weatherList.add(weatherItem);
            var singleCard = MyCardWidget(
              icon: weatherController.icon,
              temp: weatherController.temp,
              status: weatherController.status,
              wdate: weatherController.vDate,
            );
            cards.add(singleCard);
          }
        }
        print("result: $result, service.cityName: ${service.cityName}");
      }
    } else {
      fiveDaysMap = (await service.fiveDaysWeatherInfo(result, null, null))!;
      if (fiveDaysMap['list'] != null) {
        List<dynamic> havaTahminleri = fiveDaysMap['list'];
        int kayitAdim = 8;

        for (int i = 0; i < havaTahminleri.length; i += kayitAdim) {
          RxString temp = (havaTahminleri[i]['main']['temp'].toString()).obs;

          RxString status =
              (havaTahminleri[i]['weather'][0]['main'] as String).obs;
          RxString icon =
              (havaTahminleri[i]['weather'][0]['icon'] as String).obs;
          RxString tDate = DateTime.fromMillisecondsSinceEpoch(
                  havaTahminleri[i]['dt'] * 1000)
              .toString()
              .obs;

          Weather weatherItem = Weather(
              cityName: result,
              temp: temp,
              status: status,
              icon: icon,
              wDate: tDate);
          weatherController.updateWeatherData(
              newIcon: icon,
              newTemp: temp,
              newStatus: status,
              newDate: RxString("initial"));
          weatherList.add(weatherItem);
          var singleCard = MyCardWidget(
            icon: icon,
            temp: temp,
            status: status,
            wdate: tDate,
          );
          cards.add(singleCard);
        }
      }
      print("result: $result, service.cityName: ${service.cityName}");
    }
  }

  void refreshData() {
    if (result != null && result.value != null && result.value.isNotEmpty) {
      _asynchronousFunctionFuture = _asynchronousFunctions(cityName: result);
    } else {
      _asynchronousFunctionFuture =
          _asynchronousFunctions(cityName: service.cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _asynchronousFunctionFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Hata: ${snapshot.error.toString()}'));
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/home.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            result.value.isNotEmpty
                                ? result.value
                                : service.cityName.toString(),
                            style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            openSearchCityScreen();
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: Obx(() => Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: cards.length,
                              itemBuilder: (context, index) => cards[index],
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> openSearchCityScreen() async {
    String? returnedCity = await Get.to(const SearchCityScreen());
    if (returnedCity != null && returnedCity.isNotEmpty) {
      result.value = returnedCity;
      _asynchronousFunctions(cityName: result);
    }
  }
}
