import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_songbook/core/styles/colors.dart';
import 'package:my_songbook/pages/guitar_songs/editGroupPage.dart';
// import 'package:yandex_mobileads/mobile_ads.dart';
import '../../components/customButtonSheet.dart';
import '../../components/customTextField.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/cubit/songs_cubit.dart';
import '../../core/data/testDataGroup.dart';
import '../../core/model/songsModel.dart';
import '../../core/storage/storage.dart';
import '../../core/utils/currentNumber.dart';
import '../../generated/locale_keys.g.dart';
import 'Card_for_news/cardNews.dart';
import 'create_song.dart';
import 'guitarDetal.dart';
import 'search/searchPage.dart';
import 'testPage.dart';

ScrollController controllerScroll = ScrollController();

class GuitarPage extends StatefulWidget {
  const GuitarPage({super.key});

  @override
  State<GuitarPage> createState() => _GuitarPageState();
}

class _GuitarPageState extends State<GuitarPage> {
  int indexGroup = -1;
  int indexAdd = 0;
  List<int> selectedSongs = [];
  bool isSecondButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isSecondButton
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSecondButton = false;
                    indexAdd = 0;
                    selectedSongs.clear();
                  });
                },
                icon: Icon(Icons.close),
              )
            : null,
        title: isSecondButton ? null : Text("List of Songs"),
        actions: isSecondButton
            ? [
                IconButton(
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    showModalBottomSheet(
                        useSafeArea: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        context: context,
                        builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.8,
                            expand: false,
                            builder: (context, scrollController) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Align(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: Text(
                                          "Выберите группу:",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextField(
                                        controller: controller,
                                        onChanged: (value) => setState(() {
                                              controller.text = value;
                                            }),
                                        title: "Название группы"),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomButtonSheet(
                                        // width: context.width,
                                        title: "Добавить",
                                        onPressed: () {
                                          Get.back();
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                      controller: scrollController,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: 20,
                                      itemBuilder: (context, index) => ListTile(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        // horizontalTitleGap: 0,
                                        minTileHeight: 45,
                                        onTap: () {
                                          Get.back();
                                        },
                                        contentPadding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 0,
                                            bottom: 0),
                                        title: Text("Text"),
                                      ),
                                    ))
                                  ],
                                ),
                              );
                            }));
                  },
                  icon: Icon(EvaIcons.folder_add),
                ),
                BlocBuilder<Songs1Cubit, Songs1State>(
                  builder: (context, state) {
                    if (state is Songs1Loading) {
                      return const SizedBox();
                    } else if (state is Songs1Loaded) {
                      bool allSelected = state.songs
                          .every((song) => selectedSongs.contains(song.id));
                      return IconButton(
                        onPressed: () {
                          if (allSelected) {
                            _toggleAllSelections(state.songs, false);
                          } else {
                            _toggleAllSelections(state.songs, true);
                          }
                        },
                        icon: Icon(Icons.select_all),
                      );
                    } else if (state is Songs1Error) {
                      return const SizedBox();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        context: context,
                        builder: (context) => Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Удалить ${selectedSongs.length == 1 ? "песню" : "песни"}?",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "${selectedSongs.length == 1 ? "Песня будет удалена" : "Песни будут удалены"}, и их нельзя будет восстановить. Вы уверены, что хотите удалить их?",
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButtonSheet(
                                    width: context.width,
                                    height: 40,
                                    onPressed: () {
                                      for (int id in selectedSongs) {
                                        context
                                            .read<SongsBloc>()
                                            .add(DeleteSong(id));
                                      }
                                    },
                                    title: "Удалить",
                                    fontSize: 14,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButtonSheet(
                                    width: context.width,
                                    height: 40,
                                    isSecond: true,
                                    onPressed: () {
                                      Get.back();
                                    },
                                    title: "Отменить",
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ));
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red[400],
                  ),
                )
              ]
            : [
                IconButton(
                    onPressed: () {
                      Get.to(SearchPage());
                    },
                    icon: Icon(Icons.search)),
                IconButton(
                    onPressed: () {
                      Get.to(Create_song());
                    },
                    icon: Icon(Icons.add)),
              ],
      ),
      body: RefreshIndicator(
        color: colorFiolet,
        backgroundColor: context.isDarkMode
            ? backgroundColorDark.withOpacity(.1)
            : Colors.white,
        onRefresh: () {
          return controller.refreshSongs();
        },
        child: BlocBuilder<SongsBloc, SongsState>(
          builder: (context, state) {
            if (state is SongsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is SongsLoaded) {
              return ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: colorFiolet.withOpacity(0.3),
                  child: ListView.builder(
                    controller: controllerScroll,
                    itemCount: state.songs.length + 3,
                    itemBuilder: (context, index) {
                      if (index < 3) {
                        return _buildHeader(context, index);
                      }
                      final song = state.songs[index - 3];
                      return ListTile(
                        key: ValueKey(song.id),
                        minLeadingWidth: !isSecondButton ? null : 0,
                        leading: isSecondButton
                            ? _buildSelectionIndicator(song.id!)
                            : null,
                        onLongPress: () {
                          setState(() {
                            isSecondButton = true;
                          });
                          _toggleSongSelection(song.id!);
                        },
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(song.name_song,
                                style: TextStyle(fontSize: 16)),
                            Text(
                              song.name_singer ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                color: context.isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        onTap: isSecondButton
                            ? () => _toggleSongSelection(song.id!)
                            : () {
                                Get.to(GuitarDetal(
                                  id: song.id,
                                ));
                              },
                      );
                    },
                  ),
                ),
              );
            } else if (state is SongsError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(int songId) {
    final isSelected = selectedSongs.contains(songId);
    final songIndex = isSelected ? selectedSongs.indexOf(songId) + 1 : null;

    return Container(
      alignment: Alignment.center,
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colorFiolet : Colors.grey,
          width: 2,
        ),
        color: isSelected ? colorFiolet : Colors.transparent,
      ),
      child: isSelected
          ? Text(
              songIndex.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: songIndex! >= 99 ? 12 : 14),
            )
          : null,
    );
  }

  void _toggleSongSelection(int songId) {
    setState(() {
      if (selectedSongs.contains(songId)) {
        selectedSongs.remove(songId);
        if (selectedSongs.isEmpty) {
          isSecondButton = false;
        }
      } else {
        selectedSongs.add(songId);
      }
      indexAdd = selectedSongs.length;
    });
  }

  Widget _buildHeader(BuildContext context, int index) {
    switch (index) {
      case 0:
        return CardNews();
      case 1:
        return !isSecondButton ? _buildHorizontalGroupSelector() : SizedBox();
      case 2:
        return !isSecondButton ? _buildTestDeleteWidget(context) : SizedBox();
      default:
        return SizedBox();
    }
  }

  void _toggleAllSelections(List<Song> songs, bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedSongs.addAll(songs
            .map((song) => song.id!)
            .where((id) => !selectedSongs.contains(id)));
        isSecondButton = true;
      } else {
        selectedSongs.clear();
        isSecondButton = false;
      }
      indexAdd = selectedSongs.length;
    });
  }

  Widget _buildHorizontalGroupSelector() {
    return Container(
        margin: EdgeInsets.only(top: 15, bottom: 8),
        alignment: Alignment.center,
        height: 30,
        child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(EditGroupPage());
              },
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                      color: colorFiolet,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorFiolet)),
                  child: Icon(
                    EvaIcons.folder_outline,
                    color: Colors.white,
                  )),
            ),
            Row(
              children: groups
                  .asMap()
                  .map((i, group) => MapEntry(
                      i,
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (indexGroup != i) {
                            setState(() {
                              indexGroup = i;
                            });
                          } else {
                            setState(() {
                              indexGroup = -1;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: i == 0 ? 10 : 10,
                              right: i == groups.length - 1 ? 15 : 0),
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              color: indexGroup == i
                                  ? colorFiolet.withOpacity(.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: colorFiolet)),
                          child: Text(
                            group.name,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: indexGroup == i
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: indexGroup == i ? colorFiolet : null),
                          ),
                        ),
                      )))
                  .values
                  .toList(),
            )
          ],
        ));
  }

  Widget _buildTestDeleteWidget(BuildContext context) {
    return !isDeleteTest
        ? ListTile(
            onLongPress: () async => await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        title: Text(tr(LocaleKeys.confirmation_title)),
                        content: Text(tr(
                            LocaleKeys.edit_song_confirmation_content_delete)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(tr(LocaleKeys.confirmation_no))),
                          TextButton(
                              onPressed: () async {
                                // setState(() {
                                isDeleteTest = true;
                                isDeleteTestPut(isDeleteTest);
                                // });
                                Get.back();
                                Get.back();
                                Get.back();
                              },
                              child: Text(tr(LocaleKeys.confirmation_yes)))
                        ])),
            title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(tr(LocaleKeys.ex_name_song),
                          style: TextStyle(fontSize: 16)),
                      SizedBox(
                        width: 5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: colorFiolet,
                          child: Text(tr(LocaleKeys.example),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
}

// final GuitarController controller = Get.put(GuitarController());
