
import 'package:get/get.dart';
class MainController extends GetxController {

  var returnValueFromSearchScreen="".obs;

      void updateReturnValueFromSearchScreen(String? newVal){
        returnValueFromSearchScreen.value=newVal ?? "";
      }

}