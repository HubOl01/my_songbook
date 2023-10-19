import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/settings/currentNumber.dart';

import 'db/dbSongs.dart';
import 'model/songsModel.dart';

class GuitarDetalController extends GetxController {
  final id;

  GuitarDetalController({required this.id});
  var songModel = Song(
          name_singer: "",
          name_song: "",
          song: "",
          date_created: DateTime.now())
      .obs;
  var isLoading = false.obs;
  final scrollController = ScrollController().obs;
  var speedTextCo = 0.obs;
  var sizeTextCo = 1.0.obs;
  // final textStyle = TextStyle(fontSize: sizeTextCo.value, color: Colors.black).obs;
  // final chordStyle = TextStyle(fontSize: sizeTextCo.value, color: Colors.red).obs;

  @override
  void onInit() {
    print("ID ---> ${id}");
    speedTextCo.value = speed;
    sizeTextCo.value = sizeText;
    super.onInit();
    refreshSong();
  }

  @override
  void dispose() {
    DBSongs.instance.close();
    scrollController.value.dispose();
    super.dispose();
  }

  Future refreshSong() async {
    // try {
    isLoading.value = true;
    songModel.value = await DBSongs.instance.readSong(id);
    print("Запущено чтение песни");
    isLoading.value = false;
    // } catch (e) {
    //   print("Exception : ${e}");
    //   isLoading = false.obs;
    // }
    // Future.delayed(const Duration(seconds: 3), () {});
  }
}
