import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:get/get.dart';

class ApplicationsController extends GetxController {
@override
  void onInit() {
    AppMetrica.reportEvent('The applications guitar page is open');
    super.onInit();
  }
}