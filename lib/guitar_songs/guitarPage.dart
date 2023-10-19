import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/guitar_songs/testPage.dart';
import 'package:my_songbook/styles/colors.dart';

import '../settings/currentNumber.dart';
import 'create_song.dart';
import 'guitarController.dart';
import 'guitarDetal.dart';

class GuitarPage extends GetView<GuitarController> {
  const GuitarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(tr(LocaleKeys.appbar_list_songs)),
            actions: [
              IconButton(
                  onPressed: () {
                    Get.to(Create_song());
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          body: RefreshIndicator(
              color: colorFiolet,
              onRefresh: () {
                return controller.refreshSongs();
              },
              child: ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: colorFiolet.withOpacity(0.3),
                    child: ListView.builder(
                      // physics: BouncingScrollPhysics(),
                      itemCount: controller.songs.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return !isDeleteTest
                              ? ListTile(
                                  title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          children: [
                                            Text(tr(LocaleKeys.ex_name_song),
                                                style: TextStyle(fontSize: 16)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              child: Container(
                                                color: colorFiolet,
                                                child: Text(tr(LocaleKeys.example),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5, vertical: 3),
                                              ),
                                            )
                                          ],
                                        ),
                                        Text(
                                          tr(LocaleKeys.ex_name_singer),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ]),
                                  onTap: () => Get.to(TestPage()))
                              : SizedBox();
                        }
                        //       controller.songs.isEmpty
                        // ? return const SizedBox()
                        return controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            :  controller.songs.isEmpty 
                        ? const SizedBox() :
                            ListTile(
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(controller.songs[index - 1].name_song,
                                        style: TextStyle(fontSize: 16)),
                                    Text(
                                      "${controller.songs[index - 1].name_singer}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Get.to(GuitarDetal(
                                    // songModel: controller.songs[index-1],
                                    id: controller.songs[index - 1].id,
                                    // name_song: controller.songs[index - 1].name_song,
                                    // name_singer:
                                    // controller.songs[index - 1].name_singer,
                                    // song: controller.songs[index - 1].song,
                                    // audio: controller.songs[index - 1].path_music,
                                    // date_created:
                                    // controller.songs[index - 1].date_created));
                                  ));
                                },
                              );
                      },
                    ),
                  ))),
        ));
  }
}

final GuitarController controller = Get.put(GuitarController());
