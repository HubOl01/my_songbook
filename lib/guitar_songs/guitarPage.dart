import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/guitar_songs/testPage.dart';
import 'package:my_songbook/styles/colors.dart';

import '../Storage/storage.dart';
import '../settings/currentNumber.dart';
import 'Card_for_news/cardNews.dart';
import 'create_song.dart';
import 'edit_song.dart';
import 'guitarController.dart';
import 'guitarDetal.dart';
import 'search/searchPage.dart';
import 'works_file.dart';

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
                    Get.to(SearchPage());
                  },
                  icon: Icon(Icons.search)),
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
                      itemCount: controller.songs.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return CardNews();
                        }
                        if (index == 1) {
                          return !isDeleteTest
                              ? ListTile(
                                  onLongPress: () async => await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                              title: Text(tr(LocaleKeys
                                                  .confirmation_title)),
                                              content: Text(tr(LocaleKeys
                                                  .edit_song_confirmation_content_delete)),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text(tr(LocaleKeys
                                                        .confirmation_no))),
                                                TextButton(
                                                    onPressed: () async {
                                                      // setState(() {
                                                      isDeleteTest = true;
                                                      isDeleteTestPut(
                                                          isDeleteTest);
                                                      // });
                                                      Get.back();
                                                      Get.back();
                                                      Get.back();
                                                    },
                                                    child: Text(tr(LocaleKeys
                                                        .confirmation_yes)))
                                              ])),
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
                                                child: Text(
                                                    tr(LocaleKeys.example),
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
                            : controller.songs.isEmpty
                                ? const SizedBox()
                                : ListTile(
                                    onLongPress: () async => await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              title: Text(tr(LocaleKeys
                                                  .confirmation_title)),
                                              content: Text(tr(LocaleKeys
                                                  .edit_song_confirmation_content_delete)),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text(tr(LocaleKeys
                                                        .confirmation_no))),
                                                TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        await deleteFile(
                                                            controller
                                                                .songs[
                                                                    index - 2]
                                                                .path_music!);
                                                        deleteSong(controller
                                                            .songs[index - 2]
                                                            .id!);
                                                        final GuitarController
                                                            guitar = Get.put(
                                                                GuitarController());
                                                        guitar.refreshSongs();
                                                        Get.back();
                                                        Get.back();
                                                        Get.back();
                                                      } catch (ex) {
                                                        print(
                                                            "delete ex ${ex}");
                                                        await showDialog(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                                      title: Text(tr(
                                                                          LocaleKeys
                                                                              .alertDialog_error_title)),
                                                                      content: Text(tr(
                                                                          LocaleKeys
                                                                              .alertDialog_error_delete_content)),
                                                                      actions: [
                                                                        TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            child:
                                                                                Text(tr(LocaleKeys.alertDialog_error_OK)))
                                                                      ],
                                                                    ));
                                                      }
                                                    },
                                                    child: Text(tr(LocaleKeys
                                                        .confirmation_yes)))
                                              ],
                                            )),
                                    title: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                            controller
                                                .songs[index - 2].name_song,
                                            style: TextStyle(fontSize: 16)),
                                        Text(
                                          "${controller.songs[index - 2].name_singer}",
                                          style: TextStyle(fontSize: 14, 
                                          color: context.isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.grey[600],),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Get.to(GuitarDetal(
                                        id: controller.songs[index - 2].id,
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
