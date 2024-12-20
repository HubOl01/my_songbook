// import 'package:audioplayers/audioplayers.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/storage/storage.dart';
import '../../components/auto_scroll.dart';
import '../../components/player_widget.dart';
import '../../core/utils/currentNumber.dart';
import 'edit_song.dart';
import 'guitarDetalController.dart';
import '../../core/model/songsModel.dart';
// import 'package:get/get.dart';

// import '../components/player_widget.dart';
class GuitarDetal extends GetView<GuitarDetalController> {
  final id;
  const GuitarDetal({required this.id, super.key});

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
                      onPressed: () async {
                        try {
                          if (controller.songModel.value.path_music != '') {
                            try {
                              await Share.shareXFiles([
                                XFile(controller.songModel.value.path_music!)
                              ],
                                  text:
                                      "${tr(LocaleKeys.edit_song_name_song)}${controller.songModel.value.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${controller.songModel.value.name_singer}\n\n${controller.songModel.value.song}",
                                  subject:
                                      "${controller.songModel.value.name_song} from My Songbook");
                              AppMetrica.reportEvent(
                                  'Share successed!!! (audio)');
                            } catch (e) {
                              print("file exception: $e");
                              AppMetrica.reportEvent(
                                  'Share: file exception $e');
                              Share.share(
                                  "${tr(LocaleKeys.edit_song_name_song)}${controller.songModel.value.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${controller.songModel.value.name_singer}\n\n${controller.songModel.value.song}",
                                  subject:
                                      "${controller.songModel.value.name_song} from My Songbook");
                            }
                          } else {
                            AppMetrica.reportEvent(
                                'Share successed!!! (not audio)');
                            await Share.share(
                                "${tr(LocaleKeys.edit_song_name_song)}${controller.songModel.value.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${controller.songModel.value.name_singer}\n\n${controller.songModel.value.song}",
                                subject:
                                    "${controller.songModel.value.name_song} from My Songbook");
                          }
                        } catch (e) {
                          print("share_plus exception: $e");
                        }
                      },
                      icon: const Icon(Icons.share)),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_autoscroll),
                    child: IconButton(
                        onPressed: () {
                          autoScroll(controller.scrollController.value);
                          controller.speedTextCo.value = speed;
                          print("Speed: ");
                        },
                        icon: const Icon(Icons.arrow_circle_down)),
                  ),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_text_down),
                    child: IconButton(
                        onPressed: () {
                          controller.sizeTextCo.value -= 0.5;
                          sizeTextPut(controller.sizeTextCo.value);
                          initSizedText();
                        },
                        icon: const Icon(Icons.text_decrease)),
                  ),
                  Tooltip(
                    message: tr(LocaleKeys.tooltip_text_up),
                    child: IconButton(
                        onPressed: () {
                          controller.sizeTextCo.value += 0.5;
                          sizeTextPut(controller.sizeTextCo.value);
                          initSizedText();
                        },
                        icon: const Icon(Icons.text_increase)),
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
                        icon: const Icon(Icons.edit_note)),
                  ),
                ],
              ),
            ],
            body: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    controller: controller.scrollController.value,
                    physics: const BouncingScrollPhysics(),
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
                                  icon: const Icon(
                                      Icons.keyboard_double_arrow_up)),
                              Text(controller.speedTextCo.value.toString()),
                              IconButton(
                                  onPressed: () {
                                    if (controller.speedTextCo.value > 0) {
                                      controller.speedTextCo.value -= 5;
                                      speedPut(controller.speedTextCo.value);
                                      initSpeed();
                                    }
                                  },
                                  icon: const Icon(
                                      Icons.keyboard_double_arrow_down)),
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
                              : TitleContent(song: controller.songModel.value),
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
class TitleContent extends StatelessWidget {
  final Song song;
  const TitleContent({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        song.name_song != ""
            ? Text(
                song.name_song,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : const SizedBox(),
        song.name_song != ""
            ? const SizedBox(
                height: 4,
              )
            : const SizedBox(),
        song.name_singer != ""
            ? Text(song.name_singer, style: const TextStyle(fontSize: 20))
            : const SizedBox(),
      ],
    );
  }
}
