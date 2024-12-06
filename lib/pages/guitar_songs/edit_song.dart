import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_songbook/core/bloc/songs_bloc.dart';
import 'package:my_songbook/core/model/groupModel.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/pages/guitar_songs/guitarDetalController.dart';
import '../../components/customButtonSheet.dart';
import '../../components/customTextField.dart';
import '../../components/player_widget.dart';
import '../../core/data/dbSongs.dart';
import '../../core/model/songsModel.dart';
import '../../core/styles/colors.dart';
import 'works_file.dart';

class Edit_song extends StatefulWidget {
  const Edit_song({required this.songModel, required this.asset, super.key});
  final Song songModel;
  final bool asset;

  @override
  State<Edit_song> createState() => _Edit_songState();
}

class _Edit_songState extends State<Edit_song> {
  TextEditingController name_songController = TextEditingController();
  TextEditingController name_singerController = TextEditingController();
  TextEditingController song_controller = TextEditingController();
  bool isAudio = false;
  GroupModel group = GroupModel(name: "name");
  int groupID = 0;
  int orderID = 0;
  PlatformFile? customFile;
  Future getFile() async {
    // var appDir = (await getTemporaryDirectory()).path;
    // new Directory(appDir).delete(recursive: true);
    FilePickerResult? picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: ['mp3'],
    );
    if (picker != null) {
      setState(() {
        isAudio = false;
        customFile = null;
        PlatformFile file = picker.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        customFile = file;
        isAudio = true;
        autotext(customFile!.name);
      });
    } else {
      return;
    }
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
        if (name_songController.text.trim().isNotEmpty ||
            name_singerController.text.trim().isNotEmpty) {
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
                              name_songController.text = nameSong;
                              name_singerController.text = nameSinger;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          name_songController.text = nameSong;
          name_singerController.text = nameSinger;
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
        if (name_songController.text.trim().isNotEmpty ||
            name_singerController.text.trim().isNotEmpty) {
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
                              name_songController.text = nameSong;
                              name_singerController.text = nameSinger;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          name_songController.text = nameSong;
          name_singerController.text = nameSinger;
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
        if (name_songController.text.trim().isNotEmpty ||
            name_singerController.text.trim().isNotEmpty) {
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
                              name_songController.text = nameSong;
                            });
                            Get.back();
                          },
                          child: Text(context.tr(LocaleKeys.confirmation_yes)))
                    ],
                  ));
        } else {
          name_songController.text = nameSong;
        }
      });
      // name_singerController.text = nameSinger;
    }
  }

  @override
  void initState() {
    print("ID: ${widget.songModel.id}");
    super.initState();
    name_songController.text = widget.songModel.name_song;
    name_singerController.text = widget.songModel.name_singer;
    song_controller.text = widget.songModel.song;
    groupID = widget.songModel.group!;
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
              // foregroundColor: Colors.black,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(tr(LocaleKeys.confirmation_title)),
                                content: Text(tr(LocaleKeys
                                    .edit_song_confirmation_content_delete)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child:
                                          Text(tr(LocaleKeys.confirmation_no))),
                                  TextButton(
                                      onPressed: () async {
                                        try {
                                          await deleteFile(
                                              widget.songModel.path_music!);
                                          deleteSong(widget.songModel.id!);
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        } catch (ex) {
                                          print("delete ex $ex");
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(tr(LocaleKeys
                                                        .alertDialog_error_title)),
                                                    content: Text(tr(LocaleKeys
                                                        .alertDialog_error_delete_content)),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(tr(LocaleKeys
                                                              .alertDialog_error_OK)))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child:
                                          Text(tr(LocaleKeys.confirmation_yes)))
                                ],
                              ));
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
                IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(tr(LocaleKeys.confirmation_title)),
                                content: Text(tr(LocaleKeys
                                    .edit_song_confirmation_content_update)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child:
                                          Text(tr(LocaleKeys.confirmation_no))),
                                  TextButton(
                                      onPressed: () async {
                                        try {
                                          if (isAudio &&
                                              customFile!.path!.isNotEmpty) {
                                            final saveFile =
                                                await saveFilePermanently(
                                                    customFile!);
                                            print(
                                                "SAVEFILE: ${saveFile.path} ${saveFile.path.isEmpty} $saveFile");
                                            updateSong(
                                                name_songController.text,
                                                name_singerController.text,
                                                song_controller.text,
                                                saveFile.path,
                                                groupID,
                                                orderID);
                                          } else {
                                            updateSong(
                                                name_songController.text,
                                                name_singerController.text,
                                                song_controller.text,
                                                "",
                                                groupID,
                                                orderID);
                                          }

                                          final GuitarDetalController
                                              guitarDetal = Get.put(
                                                  GuitarDetalController(
                                                      id: widget.songModel.id));
                                          guitarDetal.refreshSong();
                                          Get.back();
                                          Get.back();
                                        } catch (ex) {
                                          print("update ex $ex");
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text(tr(LocaleKeys
                                                        .alertDialog_error_title)),
                                                    content: Text(tr(LocaleKeys
                                                        .alertDialog_error_update_content)),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(tr(LocaleKeys
                                                              .alertDialog_error_OK)))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child:
                                          Text(tr(LocaleKeys.confirmation_yes)))
                                ],
                              ));
                    },
                    icon: const Icon(Icons.check)),
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
                      widget.songModel.path_music != ''
                          ? PlayerWidget(
                              name_song: widget.songModel.name_song,
                              name_singer: widget.songModel.name_singer,
                              audio: widget.songModel.path_music,
                              asset: widget.asset)
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: name_songController,
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
                        controller: name_singerController,
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
                        controller: song_controller,
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
                      widget.songModel.group == null || groupID == 0
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
                                    showModalBottomSheet(
                                        useSafeArea: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                topRight: Radius.circular(15))),
                                        context: context,
                                        builder: (context) =>
                                            DraggableScrollableSheet(
                                                expand: false,
                                                builder: (context,
                                                    scrollController) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    20.0),
                                                        child: Align(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .topStart,
                                                            child: Text(
                                                              "${tr(LocaleKeys.confirmation_group_title_select)}: ",
                                                              style: const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      CustomTextField(
                                                          controller:
                                                              controller,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                                controller
                                                                        .text =
                                                                    value;
                                                              }),
                                                          title: tr(LocaleKeys
                                                              .title_new_group)),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      BlocListener<SongsBloc,
                                                          SongsState>(
                                                        listener:
                                                            (context, state) {
                                                          if (state
                                                                  is SongsLoaded &&
                                                              state.groups
                                                                  .isNotEmpty) {
                                                            final lastGroupId =
                                                                state.groups
                                                                    .first.id;

                                                            int lastOrderId =
                                                                getLastOrderIdForGroup(
                                                                        lastGroupId!,
                                                                        state
                                                                            .songs)! +
                                                                    1;
                                                            setState(() {
                                                              groupID =
                                                                  lastGroupId;
                                                              orderID =
                                                                  lastOrderId;
                                                            });
                                                          }
                                                        },
                                                        child:
                                                            CustomButtonSheet(
                                                                title: tr(LocaleKeys
                                                                    .confirmation_create),
                                                                onPressed: () {
                                                                  context
                                                                      .read<
                                                                          SongsBloc>()
                                                                      .add(AddGroup(
                                                                          GroupModel(
                                                                              name: controller.text)));

                                                                  Get.back();
                                                                }),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Expanded(child:
                                                          BlocBuilder<SongsBloc,
                                                                  SongsState>(
                                                              builder: (context,
                                                                  state) {
                                                        if (state
                                                            is SongsLoading) {
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        } else if (state
                                                            is SongsLoaded) {
                                                          return ListView
                                                              .builder(
                                                            controller:
                                                                scrollController,
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            itemCount: state
                                                                .groups.length,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    ListTile(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              // horizontalTitleGap: 0,
                                                              minTileHeight: 45,
                                                              onTap: () {
                                                                // изменение на существующую группу
                                                                int lastOrderId = getLastOrderIdForGroup(
                                                                        state
                                                                            .groups[
                                                                                index]
                                                                            .id!,
                                                                        state
                                                                            .songs)! +
                                                                    1;
                                                                setState(() {
                                                                  groupID = state
                                                                      .groups[
                                                                          index]
                                                                      .id!;
                                                                  orderID =
                                                                      lastOrderId;
                                                                });
                                                                Get.back();
                                                              },
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      top: 0,
                                                                      bottom:
                                                                          0),
                                                              title: Text(state
                                                                  .groups[index]
                                                                  .name),
                                                            ),
                                                          );
                                                        } else if (state
                                                            is SongsError) {
                                                          return const SizedBox();
                                                        } else {
                                                          return const SizedBox();
                                                        }
                                                      }))
                                                    ],
                                                  );
                                                }));
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
                                return Row(
                                  children: [
                                    Text(
                                        "${tr(LocaleKeys.confirmation_delete_group_content1)}: "),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          setState(() {
                                            groupID = 0;
                                            orderID = 0;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: colorFiolet.withOpacity(.3),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border:
                                                Border.all(color: colorFiolet),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                getNameGroup(
                                                  groupID,
                                                  groups,
                                                ),
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorFiolet,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.close,
                                                size: 15,
                                                color: colorFiolet,
                                              )
                                            ],
                                          ),
                                        )),
                                    const Spacer(),
                                  ],
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
        order: order);
    await DBSongs.instance.update(songM);
    context.read<SongsBloc>().add(LoadSongs());
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
