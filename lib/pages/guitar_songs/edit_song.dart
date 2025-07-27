import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../components/bottomSheetEditGroup.dart';
import '../../components/player_widget.dart';
import '../../core/bloc/song_bloc.dart';
import '../../core/bloc/songs_bloc.dart' hide UpdateSong;
import '../../core/data/dbSongs.dart';
import '../../core/model/groupModel.dart';
import '../../core/model/songsModel.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';
import 'works_file.dart';

class EditSong extends StatefulWidget {
  const EditSong({required this.songModel, required this.asset, super.key});
  final Song songModel;
  final bool asset;

  @override
  State<EditSong> createState() => _EditSongState();
}

class _EditSongState extends State<EditSong> {
  TextEditingController nameSongController = TextEditingController();
  TextEditingController nameSingerController = TextEditingController();
  TextEditingController songController = TextEditingController();
  bool isAudio = false;
  GroupModel group = GroupModel(name: "name");
  // int groupID = 0;
  // int orderID = 0;
  PlatformFile? customFile;
  String audioFile = "";

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

  Future<void> getFile() async {
    FilePickerResult? picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (picker != null) {
      PlatformFile file = picker.files.first;
      File renamedFile = await saveFileToCache(file);

      setState(() {
        audioFile = "";
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

  String getNameGroup(int groupId, List<GroupModel> groups) {
    final group = groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => GroupModel(id: -1, name: ""),
    );
    return group.name;
  }

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
    }
  }

  @override
  void initState() {
    super.initState();
    nameSongController =
        TextEditingController(text: widget.songModel.name_song);
    nameSingerController =
        TextEditingController(text: widget.songModel.name_singer);
    songController = TextEditingController(text: widget.songModel.song);

    if (widget.songModel.path_music != null &&
        widget.songModel.path_music!.isNotEmpty) {
      customFile = PlatformFile(
        name: widget.songModel.path_music!.split('/').last,
        path: widget.songModel.path_music,
        size: 0,
      );
      isAudio = true;
    }

    _loadSongGroups();
  }

  Future<void> _loadSongGroups() async {
    final db = DBSongs.instance;
    final groups = await db.getGroupsBySong(widget.songModel.id!);
    setState(() {
      selectedGroups = groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
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
              actions: [
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(tr(LocaleKeys.confirmation_title)),
                        content: Text(tr(
                            LocaleKeys.edit_song_confirmation_content_delete)),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(tr(LocaleKeys.confirmation_no)),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                await deleteFile(
                                    widget.songModel.path_music ?? "");

                                await DBSongs.instance.clearAllGroupsFromSong(
                                    widget.songModel.id!);
                                await DBSongs.instance
                                    .delete(widget.songModel.id!);

                                context.read<SongsBloc>().add(LoadSongs());

                                Get.back();
                                Get.back();
                                Get.back();
                              } catch (ex) {
                                print("delete ex $ex");
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        tr(LocaleKeys.alertDialog_error_title)),
                                    content: Text(tr(LocaleKeys
                                        .alertDialog_error_delete_content)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text(tr(
                                            LocaleKeys.alertDialog_error_OK)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(tr(LocaleKeys.confirmation_yes)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                IconButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(tr(LocaleKeys.confirmation_title)),
                        content: Text(tr(
                            LocaleKeys.edit_song_confirmation_content_update)),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(tr(LocaleKeys.confirmation_no)),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                String updatedPath = audioFile;

                                if (isAudio &&
                                    customFile?.path?.isNotEmpty == true) {
                                  final saveFile =
                                      await saveFilePermanently(customFile!);
                                  updatedPath = saveFile.path;
                                }

                                final updated = widget.songModel.copy(
                                  name_song: nameSongController.text,
                                  name_singer: nameSingerController.text,
                                  song: songController.text,
                                  path_music: updatedPath,
                                );

                                await DBSongs.instance.update(updated);

                                // Получаем текущие связи
                                final currentGroups = await DBSongs.instance
                                    .getGroupsBySong(updated.id!);
                                final currentGroupIds =
                                    currentGroups.map((g) => g.id).toSet();
                                final selectedGroupIds =
                                    selectedGroups.map((g) => g.id).toSet();

                                // Удаляем те группы, которых больше нет
                                final toRemove = currentGroupIds
                                    .difference(selectedGroupIds);
                                for (final groupId in toRemove) {
                                  await DBSongs.instance
                                      .clearSongGroups(updated.id!, groupId!);
                                }

                                // Добавляем новые группы
                                final toAdd = selectedGroupIds
                                    .difference(currentGroupIds);
                                for (final groupId in toAdd) {
                                  final groupSongs = await DBSongs.instance
                                      .getSongsByGroup(groupId!);
                                  final nextOrder = groupSongs.isEmpty
                                      ? 1
                                      : groupSongs
                                              .map((s) => s.order ?? 0)
                                              .reduce((a, b) => a > b ? a : b) +
                                          1;

                                  await DBSongs.instance.addSongToGroup(
                                      updated.id!, groupId, nextOrder);
                                }

                                context.read<SongsBloc>().add(LoadSongs());
                                context
                                    .read<SongBloc>()
                                    .add(ReadSong(updated.id!));

                                Get.back();
                                Get.back();
                              } catch (ex) {
                                print("update ex $ex");
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        tr(LocaleKeys.alertDialog_error_title)),
                                    content: Text(tr(LocaleKeys
                                        .alertDialog_error_update_content)),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text(tr(
                                            LocaleKeys.alertDialog_error_OK)),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Text(tr(LocaleKeys.confirmation_yes)),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.check),
                ),
              ],
            )
          ],
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      audioFile != ''
                          ? Stack(
                              children: [
                                PlayerWidget(
                                    name_song: widget.songModel.name_song,
                                    name_singer: widget.songModel.name_singer,
                                    audio: audioFile,
                                    asset: widget.asset),
                                Positioned(
                                    top: -10,
                                    right: 5,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          audioFile = '';
                                        });
                                      },
                                      padding: const EdgeInsets.all(0),
                                      splashRadius: 20,
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                    ))
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nameSongController,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: colorFiolet,
                        decoration: InputDecoration(
                            label:
                                Text(tr(LocaleKeys.add_song_label_name_song)),
                            contentPadding: const EdgeInsets.all(8),
                            floatingLabelStyle: TextStyle(color: colorFiolet),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorFiolet)),
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: nameSingerController,
                        textCapitalization: TextCapitalization.sentences,
                        cursorColor: colorFiolet,
                        decoration: InputDecoration(
                            label:
                                Text(tr(LocaleKeys.add_song_label_name_singer)),
                            contentPadding: const EdgeInsets.all(8),
                            floatingLabelStyle: TextStyle(color: colorFiolet),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorFiolet)),
                            border: const OutlineInputBorder()),
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
                            label:
                                Text(tr(LocaleKeys.edit_song_label_text_song)),
                            contentPadding: const EdgeInsets.all(8),
                            floatingLabelStyle: TextStyle(color: colorFiolet),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colorFiolet)),
                            border: const OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      widget.songModel.group == null
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
                                                              HitTestBehavior
                                                                  .opaque,
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
                                                                  Alignment
                                                                      .center,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          8),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: colorFiolet
                                                                    .withValues(
                                                                        alpha:
                                                                            .3),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                border: Border.all(
                                                                    color:
                                                                        colorFiolet),
                                                              ),
                                                              child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                    getNameGroup(
                                                                      item.id!,
                                                                      groups,
                                                                    ),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
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
                                PlayerWidget(
                                    audio: customFile!.path!, asset: false),
                                Text(customFile!.path!),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future updateSong(String nameSong, String nameSinger, String song,
      String pathMusic, int group, int order) async {
    final songM = widget.songModel.copy(
      name_song: nameSong,
      name_singer: nameSinger,
      song: song,
      path_music: pathMusic,
      group: group,
      order: order,
    );
    // await DBSongs.instance.update(songM);
    context.read<SongBloc>().add(UpdateSong(songM));
    context.read<SongsBloc>().add(LoadSongs());
    context.read<SongBloc>().add(ReadSong(widget.songModel.id!));
  }
}

Future deleteSong(int id) async {
  await DBSongs.instance.delete(id);
}

int? getLastOrderIdForGroup(int groupId, List<Song> songs) {
  final filteredSongs = songs.where((song) => song.group == groupId).toList();
  if (filteredSongs.isEmpty) {
    return 0; // Возвращаем 0, если нет песен в этой группе
  }
  filteredSongs.sort((a, b) => b.order!.compareTo(a.order!));
  return filteredSongs.first.order;
}
