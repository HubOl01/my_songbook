import 'package:get/get.dart';

import 'db/dbSongs.dart';
import 'model/songsModel.dart';

class GuitarController extends GetxController {
var songs = <Song>[].obs;
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    refreshSongs();
  }

  @override
  void dispose() {
    DBSongs.instance.close();
    super.dispose();
  }

  Future refreshSongs() async {
    isLoading.value = true;
    songs.value = await DBSongs.instance.readAllSongs();
    
    isLoading.value = false;
  }
}