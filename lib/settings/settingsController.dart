import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  @override
  void onInit() {
    AppMetrica.reportEvent('The settings page is open');
    super.onInit();
  }
}