import 'package:get/get.dart';

import '../../../core/data/dbSongs.dart';
import '../../../core/model/songsModel.dart';

class SearchPageController extends GetxController {

SearchPageController();
var songs = <Song>[].obs;
var searchedSong = <Song>[].obs;
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
  Future searchSong(RxString name) async {
    searchedSong.clear();
    for(var song in songs) {
        if(song.name_song.toLowerCase().contains(name.value.toLowerCase())){
          searchedSong.add(song);
          print("Запрос ответа name_song :=: ${searchedSong.toList()}");
        }else if(song.name_singer.toLowerCase().contains(name.value.toLowerCase())){
          searchedSong.add(song);
          print("Запрос ответа name_singer :=: ${searchedSong.toList()}");
        }
    }
  }

}