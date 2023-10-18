// import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import '../../Storage/storage.dart';
import '../../components/auto_scroll.dart';
import '../../components/player_widget.dart';
import '../../settings/currentNumber.dart';
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
                foregroundColor:
                    Theme.of(context).primaryTextTheme.titleMedium!.color,
                elevation: 0,
                // backgroundColor: Colors.white,
                actions: [
                  IconButton(
                      onPressed: () {
                        if (controller.songModel.value.path_music != '') {
                          Share.shareXFiles(
                              [XFile(controller.songModel.value.path_music!)],
                              text:
                                  "${tr(LocaleKeys.edit_song_name_song)}${controller.songModel.value.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${controller.songModel.value.name_singer}\n\n${controller.songModel.value.song}",
                              subject: "My Songbook");
                        } else {
                          Share.share(
                              "${tr(LocaleKeys.edit_song_name_song)}${controller.songModel.value.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${controller.songModel.value.name_singer}\n\n${controller.songModel.value.song}",
                              subject: "My Songbook");
                        }
                      },
                      icon: Icon(Icons.share)),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_autoscroll),
                    child: IconButton(
                        onPressed: () {
                          autoScroll(controller.scrollController.value);
                          controller.speedTextCo.value = speed;
                          print("Speed: ");
                        },
                        icon: Icon(Icons.arrow_circle_down)),
                  ),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_text_down),
                    child: IconButton(
                        onPressed: () {
                          controller.sizeTextCo.value -= 0.5;
                          sizeTextPut(controller.sizeTextCo.value);
                          initSizedText();
                        },
                        icon: Icon(Icons.text_decrease)),
                  ),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_text_up),
                    child: IconButton(
                        onPressed: () {
                          controller.sizeTextCo.value += 0.5;
                          sizeTextPut(controller.sizeTextCo.value);
                          initSizedText();
                        },
                        icon: Icon(Icons.text_increase)),
                  ),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_edit_song),
                    child: IconButton(
                        onPressed: () {
                          Get.to(Edit_song(
                            songModel: controller.songModel.value,
                            asset: false,
                          ));
                        },
                        icon: Icon(Icons.edit_note)),
                  ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(tr(LocaleKeys.text_speed_scroll)),
                              IconButton(
                                  onPressed: () {
                                    controller.speedTextCo.value += 5;
                                    speedPut(controller.speedTextCo.value);
                                    initSpeed();
                                  },
                                  icon: Icon(Icons.keyboard_double_arrow_up)),
                              Text(controller.speedTextCo.value.toString()),
                              IconButton(
                                  onPressed: () {
                                    if (controller.speedTextCo.value > 0) {
                                      controller.speedTextCo.value -= 5;
                                      speedPut(controller.speedTextCo.value);
                                      initSpeed();
                                    }
                                  },
                                  icon: Icon(Icons.keyboard_double_arrow_down)),
                            ],
                          ),
                          controller.songModel.value.path_music != ''
                              ? PlayerWidget(
                                  name_song:
                                      controller.songModel.value.name_song,
                                  name_singer:
                                      controller.songModel.value.name_singer,
                                  audio: controller.songModel.value.path_music,
                                  asset: false)
                              : SizedBox(),
                          LyricsRenderer(
                            // horizontalAlignment: CrossAxisAlignment.stretch,
                            lyrics: controller.songModel.value.song,
                            textStyle: TextStyle(
                                fontSize: controller.sizeTextCo.value,
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium!
                                    .color),
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