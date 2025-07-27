import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../components/bottomSheetEditGroup.dart';
import '../../components/player_widget.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/data/dbSongs.dart';
import '../../core/model/groupModel.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';
import '../../core/utils/currentNumber.dart';
import '../../core/model/songsModel.dart';
import 'works_file.dart';

class CreateSong extends StatefulWidget {
  final GroupModel? group;
  final Function()? onSave;
  const CreateSong({super.key, this.group, this.onSave});

  @override
  State<CreateSong> createState() => _CreateSongState();
}

class _CreateSongState extends State<CreateSong> {
  TextEditingController nameSongController = TextEditingController();
  TextEditingController nameSingerController = TextEditingController();
  TextEditingController songController = TextEditingController();
  String nameSong = "";
  String nameSinger = "";
  PlatformFile? customFile;
  List<GroupModel> selectedGroups = [];

  void getBottom(TextEditingController controller) async {
    final selectedGroupIds = await showBottomSheetGroup(
      context,
      controller,
      [],
      false,
      [],
      selectedGroups,
      () {},
      isEdit: true,
    );

    if (selectedGroupIds != null) {
      setState(() {
        selectedGroups = List.from(selectedGroupIds);
      });
    }
  }

  String getNameGroup(int groupId, List<GroupModel> groups) {
    final group = groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => GroupModel(id: -1, name: ""),
    );
    return group.name;
  }

  @override
  void initState() {
    AppMetrica.reportEvent('Song added');
    if (widget.group != null) {
      setState(() {
        selectedGroups.add(widget.group!);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    nameSongController.clear();
    nameSingerController.clear();
    songController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            snap: false,
            floating: true,
            pinned: false,
            title: Text(tr(LocaleKeys.appbar_add_song)),
            // backgroundColor: Colors.transparent,
            // foregroundColor: Colors.black,
            elevation: 0,
          )
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: !isClosedWarring ? 10 : 0,
                ),
                TextField(
                  controller: nameSongController,
                  // maxLines: 30,
                  cursorColor: colorFiolet,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_name_song)),
                      contentPadding: const EdgeInsets.all(8),
                      // labelStyle: ,
                      floatingLabelStyle: TextStyle(color: colorFiolet),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameSingerController,
                  cursorColor: colorFiolet,
                  // maxLines: 30,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_name_singer)),
                      contentPadding: const EdgeInsets.all(8),
                      floatingLabelStyle: TextStyle(color: colorFiolet),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet))),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: songController,
                  cursorColor: colorFiolet,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_text_song)),
                      contentPadding: const EdgeInsets.all(8),
                      floatingLabelStyle: TextStyle(color: colorFiolet),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: colorFiolet))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  tr(LocaleKeys.title_add_group),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                selectedGroups.isEmpty
                    ? Row(
                        children: [
                          Text(
                            "${tr(LocaleKeys.confirmation_group_title_select)}:",
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              TextEditingController controller =
                                  TextEditingController();
                              getBottom(controller);
                            },
                            child: const Icon(EvaIcons.folder_add),
                          ),
                        ],
                      )
                    : BlocBuilder<SongsBloc, SongsState>(
                        // Если уже есть группа и по возможности можно поменять
                        builder: (context, state) {
                          List<GroupModel> groups = [];

                          if (state is SongsLoaded) {
                            groups = state.groups;
                          }
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                    "${selectedGroups.length <= 1 ? tr(LocaleKeys.title_group) : tr(LocaleKeys.title_groups)}: "),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  child: const Icon(EvaIcons.folder_add),
                                  onTap: () {
                                    TextEditingController controller =
                                        TextEditingController();
                                    getBottom(controller);
                                  },
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                selectedGroups.isEmpty
                                    ? const SizedBox()
                                    : Wrap(
                                        spacing: 8,
                                        runSpacing: 5,
                                        children: selectedGroups
                                            .asMap()
                                            .map((i, item) => MapEntry(
                                                i,
                                                GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGroups
                                                            .remove(item);
                                                      });
                                                      // setState(() {
                                                      //   groupID = 0;
                                                      //   orderID = 0;
                                                      // });
                                                    },
                                                    child: Container(
                                                        height: 30,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: colorFiolet
                                                              .withValues(
                                                                  alpha: .3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          border: Border.all(
                                                              color:
                                                                  colorFiolet),
                                                        ),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              getNameGroup(
                                                                item.id!,
                                                                groups,
                                                              ),
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      colorFiolet),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Icon(
                                                              Icons.close,
                                                              size: 15,
                                                              color:
                                                                  colorFiolet,
                                                            )
                                                          ],
                                                        )))))
                                            .values
                                            .toList()),
                                const SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  tr(LocaleKeys.add_song_add_audiofile),
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      height: 50,
                      width: 70,
                      child: ElevatedButton(
                          onPressed: () async {
                            getFile();
                            setState(() {
                              isAudio = false;
                              customFile = null;
                            });

                            // await FilePicker.platform.clearTemporaryFiles();
                          },
                          child: const Icon(
                            Icons.audio_file,
                            size: 25,
                          ))),
                ),
                isAudio && customFile!.path!.isNotEmpty
                    ? Column(
                        children: [
                          PlayerWidget(audio: customFile!.path!, asset: false),
                          Text(customFile!.path!),
                        ],
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          final name = nameSongController.text.trim();
                          final singer = nameSingerController.text.trim();
                          final lyrics = songController.text.trim();

                          if (name.isEmpty ||
                              singer.isEmpty ||
                              lyrics.isEmpty) {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    tr(LocaleKeys.alertDialog_error_title)),
                                content: Text(tr(LocaleKeys
                                    .alertDialog_error_not_data_content)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                        tr(LocaleKeys.alertDialog_error_OK)),
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          try {
                            String path = "";
                            if (isAudio &&
                                customFile?.path?.isNotEmpty == true) {
                              final saveFile =
                                  await saveFilePermanently(customFile!);
                              path = saveFile.path;
                            }

                            final newSong = Song(
                              name_song: name,
                              name_singer: singer,
                              song: lyrics,
                              path_music: path,
                              speedScroll: 150,
                              fontSizeText: 14,
                              date_created: DateTime.now(),
                            );

                            final db = DBSongs.instance;
                            final savedSong = await db.create(newSong);

                            final createdId = savedSong.id;
                            if (createdId == null) {
                              throw Exception("ID of saved song is null");
                            }

                            for (final group in selectedGroups) {
                              final groupId = group.id!;
                              final groupSongs =
                                  await db.getSongsByGroup(groupId);

                              final nextOrder = groupSongs.isEmpty
                                  ? 1
                                  : groupSongs
                                          .map((s) => s.order ?? 0)
                                          .reduce((a, b) => a > b ? a : b) +
                                      1;

                              context.read<SongsBloc>().add(AddSongToGroup(
                                  createdId, groupId, nextOrder));
                            }

                            context.read<SongsBloc>().add(LoadSongs());
                            widget.onSave?.call();
                            Get.back();
                          } catch (ex) {
                            print("EXCEPTION => $ex");

                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    tr(LocaleKeys.alertDialog_error_title)),
                                content: Text(tr(LocaleKeys
                                    .alertDialog_error_create_content)),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text(
                                        tr(LocaleKeys.alertDialog_error_OK)),
                                  ),
                                ],
                              ),
                            );
                          }
                        } catch (e) {
                          print("OUTER EXCEPTION => $e");
                        }
                      },
                      child: Text(
                        tr(LocaleKeys.add_song_save),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addSongAudio(String nameSong, String nameSinger, String song,
      String pathMusic, int group, int order) async {
    final songM = Song(
        name_song: nameSong,
        name_singer: nameSinger,
        song: song,
        path_music: pathMusic,
        group: group,
        order: order,
        speedScroll: 150,
        fontSizeText: 14,
        date_created: DateTime.now());
    // DBSongs.instance.create(songM);
    context.read<SongsBloc>().add(AddSong(songM));
  }

  Future addSong(String nameSong, String nameSinger, String song, int group,
      int order) async {
    final songM = Song(
        name_song: nameSong,
        name_singer: nameSinger,
        song: song,
        group: group,
        order: order,
        speedScroll: 150,
        fontSizeText: 14,
        date_created: DateTime.now());
    context.read<SongsBloc>().add(AddSong(songM));
  }

  bool isAudio = false;
  Future<void> getFile() async {
    FilePickerResult? picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (picker != null) {
      PlatformFile file = picker.files.first;
      File renamedFile = await saveFileToCache(file);

      setState(() {
        customFile = PlatformFile(
          name: renamedFile.path.split('/').last,
          path: renamedFile.path,
          size: file.size,
          bytes: file.bytes,
        );
        isAudio = true;
        autotext(file.name);
      });

      print("Файл в кеше: ${renamedFile.path}");
    }
  }

// Функция переименования и сохранения в кеш
  Future<File> saveFileToCache(PlatformFile file) async {
    final tempDir = await getTemporaryDirectory();
    String newFileName = transliterateFileName(file.name);
    String newPath = '${tempDir.path}/$newFileName.${file.extension}';

    return File(file.path!).copy(newPath);
  }

  // Future<File> saveFilePermanently(PlatformFile file) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final newFile = File('${appStorage.path}/${file.name}');
  //   return File(file.path!).copy(newFile.path);
  // }

  void autotext(String name) {
    if (name.contains(" - ")) {
      setState(() {
        RegExp exp = RegExp(r'\(.*?\)');
        name = name.replaceAll(exp, '');
      });
      List<String> words = name.split(' - ');
      String nameSinger = words[0];
      String nameSong = words[1];
      if (nameSong.contains(".mp3")) {
        nameSong = words[1].replaceAll(".mp3", "");
        if (nameSong.contains("-")) {
          nameSong = words[1].replaceAll("-", " ");
        }
      }
      if (nameSong.contains(".m4a")) {
        nameSong = words[1].replaceAll(".m4a", "");
        if (nameSong.contains("-")) {
          nameSong = words[1].replaceAll("-", " ");
        }
      }
      setState(() {
        if (nameSongController.text.trim().isNotEmpty ||
            nameSingerController.text.trim().isNotEmpty) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(context.tr(LocaleKeys.confirmation_title)),
                    content: Text(
                        context.tr(LocaleKeys.add_song_confirmation_content)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_no))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              nameSongController.text = nameSong;
                              nameSingerController.text = nameSinger;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          nameSongController.text = nameSong;
          nameSingerController.text = nameSinger;
        }
      });
    } else if (name.contains(" — ")) {
      setState(() {
        RegExp exp = RegExp(r'\(.*?\)');
        name = name.replaceAll(exp, '');
      });
      List<String> words = name.split(' — ');
      String nameSinger = words[0];
      String nameSong = words[1];
      if (nameSong.contains(".mp3")) {
        nameSong = words[1].replaceAll(".mp3", "");
        if (nameSong.contains("—")) {
          nameSong = words[1].replaceAll("—", " ");
        }
      }
      if (nameSong.contains(".m4a")) {
        nameSong = words[1].replaceAll(".m4a", "");
        if (nameSong.contains("—")) {
          nameSong = words[1].replaceAll("—", " ");
        }
      }
      setState(() {
        if (nameSongController.text.trim().isNotEmpty ||
            nameSingerController.text.trim().isNotEmpty) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(context.tr(LocaleKeys.confirmation_title)),
                    content: Text(
                        context.tr(LocaleKeys.add_song_confirmation_content)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_no))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              nameSongController.text = nameSong;
                              nameSingerController.text = nameSinger;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          nameSongController.text = nameSong;
          nameSingerController.text = nameSinger;
        }
      });
    } else {
      setState(() {
        RegExp exp = RegExp(r'\(.*?\)');
        name = name.replaceAll(exp, '');
      });
      String nameSong = name;
      if (nameSong.contains(".mp3")) {
        nameSong = nameSong.replaceAll(".mp3", "");
        if (nameSong.contains("-")) {
          nameSong = nameSong.replaceAll("-", " ");
        }
      }
      if (nameSong.contains(".m4a")) {
        nameSong = nameSong.replaceAll(".m4a", "");
        if (nameSong.contains("-")) {
          nameSong = nameSong.replaceAll("-", " ");
        }
      }
      setState(() {
        if (nameSongController.text.trim().isNotEmpty ||
            nameSingerController.text.trim().isNotEmpty) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(context.tr(LocaleKeys.confirmation_title)),
                    content: Text(
                        context.tr(LocaleKeys.add_song_confirmation_content)),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_no))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              nameSongController.text = nameSong;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          nameSongController.text = nameSong;
        }
      });
      // name_singerController.text = nameSinger;
    }
  }
}
