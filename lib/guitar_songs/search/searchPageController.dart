import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/dbSongs.dart';
import '../model/songsModel.dart';

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
  Future searchSong(String name) async {
    searchedSong.clear();
    for(var song in songs) {
        if(song.name_song.contains(name)){
          searchedSong.add(song);
          print("Запрос ответа :=: ${searchedSong.toList()}");
        }
    }
  }

}