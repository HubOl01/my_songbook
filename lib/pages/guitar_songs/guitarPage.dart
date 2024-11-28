import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/core/data/testDataGroup.dart';
import 'package:my_songbook/pages/guitar_songs/testPage.dart';
import 'package:my_songbook/core/styles/colors.dart';
// import 'package:yandex_mobileads/mobile_ads.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/storage/storage.dart';
import '../../core/utils/currentNumber.dart';
import 'Card_for_news/cardNews.dart';
import 'create_song.dart';
import 'edit_song.dart';
import 'guitarController.dart';
import 'guitarDetal.dart';
import 'search/searchPage.dart';
import 'works_file.dart';

class GuitarPage extends StatefulWidget {
  const GuitarPage({super.key});

  @override
  State<GuitarPage> createState() => _GuitarPageState();
}

class _GuitarPageState extends State<GuitarPage> {
  int indexGroup = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(LocaleKeys.appbar_list_songs)),
        actions: [
          IconButton(
              onPressed: () {
                AppMetrica.reportEvent('Search');
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
                child: BlocBuilder<SongsBloc, SongsState>(
                    builder: (context, state) {
                  if (state is SongsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SongsLoaded) {
                    return ListView.builder(
                      itemCount: state.songs.length + 3,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return CardNews();
                        }
                        if (index == 1) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            height: 30,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: groups
                                  .asMap()
                                  .map((i, group) => MapEntry(
                                      i,
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            indexGroup = i;
                                          });
                                          // controller.indexGroup
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              left: i == 0 ? 15 : 10,
                                              right: i == groups.length - 1
                                                  ? 15
                                                  : 0),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: indexGroup == i
                                                  ? colorFiolet.withOpacity(.3)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: colorFiolet)),
                                          child: Text(
                                            group.name,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: indexGroup == i
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,
                                                color: colorFiolet),
                                          ),
                                        ),
                                      )))
                                  .values
                                  .toList(),
                            ),
                          );
                        }
                        if (index == 2) {
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
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: context.isDarkMode
                                                  ? Colors.grey[300]
                                                  : Colors.grey[600]),
                                        ),
                                      ]),
                                  onTap: () => Get.to(TestPage()))
                              : SizedBox();
                        }
                        final song = state.songs[index - 3];
                        return ListTile(
                          onLongPress: () async => await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title:
                                        Text(tr(LocaleKeys.confirmation_title)),
                                    content: Text(tr(LocaleKeys
                                        .edit_song_confirmation_content_delete)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                              tr(LocaleKeys.confirmation_no))),
                                      TextButton(
                                          onPressed: () async {
                                            try {
                                              await deleteFile(
                                                  song.path_music!);
                                              deleteSong(song.id!);
                                              // final GuitarController
                                              //     guitar = Get.put(
                                              //         GuitarController());
                                              // guitar.refreshSongs();
                                              Get.back();
                                              Get.back();
                                              Get.back();
                                            } catch (ex) {
                                              print("delete ex ${ex}");
                                              await showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: Text(tr(LocaleKeys
                                                            .alertDialog_error_title)),
                                                        content: Text(tr(LocaleKeys
                                                            .alertDialog_error_delete_content)),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Get.back();
                                                              },
                                                              child: Text(tr(
                                                                  LocaleKeys
                                                                      .alertDialog_error_OK)))
                                                        ],
                                                      ));
                                            }
                                          },
                                          child: Text(
                                              tr(LocaleKeys.confirmation_yes)))
                                    ],
                                  )),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(song.name_song,
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                "${song.name_singer}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: context.isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Get.to(GuitarDetal(
                              id: song.id,
                            ));
                          },
                        );

                        //       controller.songs.isEmpty
                        // ? return const SizedBox()
                        // return ListTile(
                        //   title: Text(song.name_song),
                        //   subtitle: Text(song.name_singer),
                        //   trailing: IconButton(
                        //     icon: Icon(Icons.delete),
                        //     onPressed: () {
                        //       BlocProvider.of<SongsBloc>(context).add(DeleteSong(song.id!));
                        //     },
                        //   ),
                        // );
                      },
                    );
                  } else if (state is SongsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('No data available'));
                  }
                }),

                // ListView.builder(
                //   // physics: BouncingScrollPhysics(),
                //   itemCount: controller.songs.length + 3,
                //   itemBuilder: (context, index) {
                //     if (index == 0) {
                //       return CardNews();
                //     }
                //     if (index == 1) {
                //       return Container(
                //         margin: EdgeInsets.only(top: 10, left: 5),
                //         height: 30,
                //         child: ListView(
                //           scrollDirection: Axis.horizontal,
                //           children: groups
                //               .asMap()
                //               .map((i, group) => MapEntry(
                //                   i,
                //                   GestureDetector(
                //                     behavior: HitTestBehavior.opaque,
                //                     onTap: () {
                //                       setState(() {
                //                         indexGroup = i;
                //                       });
                //                       // controller.indexGroup
                //                     },
                //                     child: Container(
                //                       alignment: Alignment.center,
                //                       margin: EdgeInsets.only(left: 10),
                //                       padding:
                //                           EdgeInsets.symmetric(horizontal: 8),
                //                       decoration: BoxDecoration(
                //                           color: indexGroup == i
                //                               ? colorFiolet.withOpacity(.3)
                //                               : Colors.transparent,
                //                           borderRadius:
                //                               BorderRadius.circular(10),
                //                           border:
                //                               Border.all(color: colorFiolet)),
                //                       child: Text(
                //                         group.name,
                //                         style: TextStyle(
                //                             fontSize: 13,
                //                             fontWeight: FontWeight.w600,
                //                             color: colorFiolet),
                //                       ),
                //                     ),
                //                   )))
                //               .values
                //               .toList(),
                //         ),
                //       );
                //       //return Align(
                //       //   alignment: Alignment.bottomCenter,
                //       //   child: ADSBanner()
                //       // );
                //       // return controller.isBannerAlreadyCreated.value ? AdWidget(bannerAd: controller.banner) : SizedBox();
                //     }
                //     if (index == 2) {
                //       return !isDeleteTest
                //       ? ListTile(
                //           onLongPress: () async => await showDialog(
                //               context: context,
                //               builder: (context) => AlertDialog(
                //                       title: Text(tr(
                //                           LocaleKeys.confirmation_title)),
                //                       content: Text(tr(LocaleKeys
                //                           .edit_song_confirmation_content_delete)),
                //                       actions: [
                //                         TextButton(
                //                             onPressed: () {
                //                               Get.back();
                //                             },
                //                             child: Text(tr(LocaleKeys
                //                                 .confirmation_no))),
                //                         TextButton(
                //                             onPressed: () async {
                //                               // setState(() {
                //                               isDeleteTest = true;
                //                               isDeleteTestPut(isDeleteTest);
                //                               // });
                //                               Get.back();
                //                               Get.back();
                //                               Get.back();
                //                             },
                //                             child: Text(tr(LocaleKeys
                //                                 .confirmation_yes)))
                //                       ])),
                //           title: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               crossAxisAlignment:
                //                   CrossAxisAlignment.stretch,
                //               children: [
                //                 Row(
                //                   children: [
                //                     Text(tr(LocaleKeys.ex_name_song),
                //                         style: TextStyle(fontSize: 16)),
                //                     SizedBox(
                //                       width: 5,
                //                     ),
                //                     ClipRRect(
                //                       borderRadius:
                //                           BorderRadius.circular(15),
                //                       child: Container(
                //                         color: colorFiolet,
                //                         child: Text(tr(LocaleKeys.example),
                //                             style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 10)),
                //                         padding: EdgeInsets.symmetric(
                //                             horizontal: 5, vertical: 3),
                //                       ),
                //                     )
                //                   ],
                //                 ),
                //                 Text(
                //                   tr(LocaleKeys.ex_name_singer),
                //                   style: TextStyle(fontSize: 14),
                //                 ),
                //               ]),
                //           onTap: () => Get.to(TestPage()))
                //       : SizedBox();
                // }
                // //       controller.songs.isEmpty
                // // ? return const SizedBox()
                // return controller.isLoading.value
                //     ? const Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     : controller.songs.isEmpty
                //         ? const SizedBox()
                // : ListTile(
                //     onLongPress: () async => await showDialog(
                //         context: context,
                //         builder: (context) => AlertDialog(
                //               title: Text(tr(
                //                   LocaleKeys.confirmation_title)),
                //               content: Text(tr(LocaleKeys
                //                   .edit_song_confirmation_content_delete)),
                //               actions: [
                //                 TextButton(
                //                     onPressed: () {
                //                       Get.back();
                //                     },
                //                     child: Text(tr(LocaleKeys
                //                         .confirmation_no))),
                //                 TextButton(
                //                     onPressed: () async {
                //                       try {
                //                         await deleteFile(controller
                //                             .songs[index - 3]
                //                             .path_music!);
                //                         deleteSong(controller
                //                             .songs[index - 3].id!);
                //                         // final GuitarController
                //                         //     guitar = Get.put(
                //                         //         GuitarController());
                //                         // guitar.refreshSongs();
                //                         Get.back();
                //                         Get.back();
                //                         Get.back();
                //                       } catch (ex) {
                //                         print("delete ex ${ex}");
                //                         await showDialog(
                //                             context: context,
                //                             builder:
                //                                 (context) =>
                //                                     AlertDialog(
                //                                       title: Text(tr(
                //                                           LocaleKeys
                //                                               .alertDialog_error_title)),
                //                                       content: Text(tr(
                //                                           LocaleKeys
                //                                               .alertDialog_error_delete_content)),
                //                                       actions: [
                //                                         TextButton(
                //                                             onPressed:
                //                                                 () {
                //                                               Get.back();
                //                                             },
                //                                             child: Text(
                //                                                 tr(LocaleKeys.alertDialog_error_OK)))
                //                                       ],
                //                                     ));
                //                       }
                //                     },
                //                     child: Text(tr(LocaleKeys
                //                         .confirmation_yes)))
                //               ],
                //             )),
                //     title: Column(
                //       mainAxisSize: MainAxisSize.min,
                //       crossAxisAlignment:
                //           CrossAxisAlignment.stretch,
                //       children: [
                //         Text(song.name_song,
                //             style: TextStyle(fontSize: 16)),
                //         Text(
                //           "${song.name_singer}",
                //           style: TextStyle(
                //             fontSize: 14,
                //             color: context.isDarkMode
                //                 ? Colors.grey[300]
                //                 : Colors.grey[600],
                //           ),
                //         ),
                //       ],
                //     ),
                //     onTap: () {
                //       Get.to(GuitarDetal(
                //         id: song.id,
                //       ));
                //     },
                //   );
                //   },
                // ),
              ))),
    );
  }
}

// final GuitarController controller = Get.put(GuitarController());
