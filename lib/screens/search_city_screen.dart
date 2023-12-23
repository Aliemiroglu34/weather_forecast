import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/waether_model.dart';

class SearchCityScreen extends StatefulWidget {
  const SearchCityScreen({super.key});

  @override
  State<SearchCityScreen> createState() => _SearchCityScreenState();
}

class _SearchCityScreenState extends State<SearchCityScreen> {

String selectedCityName="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,backgroundColor: Colors.transparent,),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/images/search.jpg'),
              fit: BoxFit.cover,
            ),

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onChanged: (val){
                    selectedCityName=val;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Şehir Giriniz',
                    labelStyle: TextStyle(color: Colors.white,),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),

                  ),
                ),
              ),
              ElevatedButton(onPressed: (){
                Get.back(result: selectedCityName);
              }, child: Text("Ara"))
            ],
          ),
        ),
      ),
    );
  }
}
