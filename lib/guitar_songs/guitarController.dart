import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:get/get.dart';

import 'db/dbSongs.dart';
import 'model/songsModel.dart';

class GuitarController extends GetxController {
var songs = <Song>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    AppMetrica.reportEvent('The guitar page is open');
    super.onInit();
    refreshSongs();
  }

  @override
  void dispose() {
    DBSongs.instance.close();
    super.dispose();
  }

  Future refreshSongs() async {
    // try {
    isLoading.value = true;
    songs.value = await DBSongs.instance.readAllSongs();
    
    isLoading.value = false;
    // } catch (e) {
    //   print("Exception : ${e}");
    //   isLoading = false.obs;
    // }
    // Future.delayed(const Duration(seconds: 3), () {});
  }
}