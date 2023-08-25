// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';

import '../Storage/storage.dart';
import '../components/auto_scroll.dart';
import '../components/player_widget.dart';
import '../settings/currentNumber.dart';
import 'edit_song.dart';
import 'guitarDetalController.dart';
// import 'package:get/get.dart';

// import '../components/player_widget.dart';
class GuitarDetal extends GetView<GuitarDetalController> {
  final id;
  GuitarDetal({required this.id, super.key}) {}

  // final _scrollController = ScrollController();

  // bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final GuitarDetalController controller =
        Get.put(GuitarDetalController(id: id));

    return Obx(() => Scaffold(
          body: NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      forceElevated: innerBoxIsScrolled,
                      snap: false,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      // backgroundColor: Colors.white,
                      actions: [
                        Tooltip(
                          message: "Авто-прокрутка",
                          child: IconButton(
                              onPressed: () {
                                // setState(() {
                                autoScroll(controller.scrollController.value);
                                controller.speedTextCo.value = speed;
                                print("Speed: ");
                                // });
                              },
                              icon: Icon(Icons.arrow_circle_down)),
                        ),
                        Tooltip(
                          message: "Уменьшить размер текста",
                          child: IconButton(
                              onPressed: () {
                                // setState(() {
                                controller.sizeTextCo.value -= 0.5;
                                sizeTextPut(controller.sizeTextCo.value);
                                initSizedText();
                                // });
                              },
                              icon: Icon(Icons.text_decrease)),
                        ),
                        Tooltip(
                          message: "Увеличить размер текста",
                          child: IconButton(
                              onPressed: () {
                                // setState(() {
                                controller.sizeTextCo.value += 0.5;
                                sizeTextPut(controller.sizeTextCo.value);
                                initSizedText();
                                // });
                              },
                              icon: Icon(Icons.text_increase)),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.to(Edit_song(
                                songModel: controller.songModel.value,
                                asset: false,
                              ));
                            },
                            icon: Icon(Icons.edit_note)),
                      ],
                    ),
                  ],
              body: controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                          controller: controller.scrollController.value,
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Скорость прокрутки: "),
                                      IconButton(
                                          onPressed: () {
                                            // setState(() {
                                            controller.speedTextCo.value += 5;
                                            speedPut(
                                                controller.speedTextCo.value);
                                            initSpeed();
                                            // });
                                          },
                                          icon: Icon(
                                              Icons.keyboard_double_arrow_up)),
                                      Text(controller.speedTextCo.value
                                          .toString()),
                                      IconButton(
                                          onPressed: () {
                                            // setState(() {
                                            if (controller.speedTextCo.value >
                                                0) {
                                              controller.speedTextCo.value -= 5;
                                              speedPut(
                                                  controller.speedTextCo.value);
                                              initSpeed();
                                            }
                                            // });
                                          },
                                          icon: Icon(Icons
                                              .keyboard_double_arrow_down)),
                                    ],
                                  ),
                                  controller.songModel.value.path_music != ''
                                      ? PlayerWidget(
                                          name_song: controller
                                              .songModel.value.name_song,
                                          name_singer: controller
                                              .songModel.value.name_singer,
                                          audio: controller
                                              .songModel.value.path_music,
                                          asset: false)
                                      : SizedBox(),
                                  LyricsRenderer(
                                    // horizontalAlignment: CrossAxisAlignment.stretch,
                                    lyrics: controller.songModel.value.song,
                                    textStyle: TextStyle(
                                        fontSize: controller.sizeTextCo.value,
                                        color: Colors.black),
                                    chordStyle: TextStyle(
                                        fontSize: controller.sizeTextCo.value,
                                        color: Colors.red),
                                    // widgetPadding: 50,
                                    onTapChord: (String chord) {
                                      print('pressed chord: $chord');
                                    },
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                   
        ));
  }

  void initSpeed() {
    speed = controller.speedTextCo.value;
  }

  void initSizedText() {
    sizeText = controller.sizeTextCo.value;
  }
}

// Future refreshSongAll(int id) async {
//   song = await DBSongs.instance.readSong(id);
//   print("Successed refresh song all!!! ${id} ${controller.song.toJson()}");
// }


// final GuitarDetalController controller = Get.put(GuitarDetalController());