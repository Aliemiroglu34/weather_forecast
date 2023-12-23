import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class MyCardWidget extends StatefulWidget {
  final RxString icon;
  final RxString temp;
  final RxString status;
  final RxString wdate;

  MyCardWidget({
    required this.icon,
    required this.temp,
    required this.status,
    required this.wdate,
  });

  @override
  State<MyCardWidget> createState() => _MyCardWidgetState();
}

class _MyCardWidgetState extends State<MyCardWidget> {
 
  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.transparent,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
              "https://openweathermap.org/img/wn/${widget.icon}@2x.png"),
         Text(widget.temp.value),

          // Diğer String verilerini kullanabilirsiniz
        ],
      ),
    );
  }
}
