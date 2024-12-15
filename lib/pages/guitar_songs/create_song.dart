import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../components/customButtonSheet.dart';
import '../../components/customTextField.dart';
import '../../components/player_widget.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/model/groupModel.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';
import '../../core/utils/currentNumber.dart';
import '../../core/model/songsModel.dart';
import 'edit_song.dart';
import 'works_file.dart';

class Create_song extends StatefulWidget {
  const Create_song({super.key});

  @override
  State<Create_song> createState() => _Create_songState();
}

class _Create_songState extends State<Create_song> {
  TextEditingController name_songController = TextEditingController();
  TextEditingController name_singerController = TextEditingController();
  TextEditingController songController = TextEditingController();
  String name_song = "";
  String name_singer = "";
  // late String number;
  // late String title;
  // late String content;
  PlatformFile? customFile;
  int groupID = 0;
  int orderID = 0;

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
    super.initState();
  }

  @override
  void dispose() {
    name_songController.clear();
    name_singerController.clear();
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
                  controller: name_songController,
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
                  controller: name_singerController,
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
                groupID == 0
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
                              Widget buildCreateGroupField(
                                  BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState1) {
                                  return BlocBuilder<SongsBloc, SongsState>(
                                    builder: (context, state) {
                                      if (state is SongsLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is SongsLoaded) {
                                        final groups = state.groups;

                                        // Если групп 5 или больше, не показывать поле создания
                                        if (groups.length >= 5) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              tr(LocaleKeys.info_max_group),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: context.isDarkMode
                                                    ? Colors.white70
                                                    : Colors.black54,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        }

                                        return Container(
                                          height: 140,
                                          alignment: Alignment.bottomCenter,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Column(
                                            children: [
                                              // Поле ввода
                                              CustomTextField(
                                                controller: controller,
                                                title: tr(
                                                    LocaleKeys.title_new_group),
                                                onChanged: (value) =>
                                                    setState1(() {}),
                                              ),
                                              // Счетчик символов
                                              Text(
                                                "${controller.text.length}/20",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                          .withValues(alpha: .7)
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              // Кнопки подтверждения
                                              if (controller.text.isNotEmpty)
                                                SizedBox(
                                                  height: 30,
                                                  width: 200,
                                                  child: Row(
                                                    children: [
                                                      // Кнопка "Создать" или "Обновить"
                                                      Expanded(
                                                        child: BlocListener<
                                                            SongsBloc,
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
                                                                  title: tr(
                                                                      LocaleKeys
                                                                          .confirmation_create),
                                                                  onPressed:
                                                                      () {
                                                                    // context
                                                                    //     .read<
                                                                    //         SongsBloc>()
                                                                    //     .add(AddGroup(GroupModel(
                                                                    //         name:
                                                                    //             controller.text)));
                                                                    if (groups.any((group) =>
                                                                        group
                                                                            .name
                                                                            .toLowerCase() ==
                                                                        controller
                                                                            .text
                                                                            .toLowerCase())) {
                                                                      Get.snackbar(
                                                                        tr(LocaleKeys
                                                                            .error_duplicate_group_title),
                                                                        tr(LocaleKeys
                                                                            .error_duplicate_group_message),
                                                                        backgroundColor: Colors
                                                                            .red
                                                                            .withValues(alpha: 0.8),
                                                                        colorText:
                                                                            Colors.white,
                                                                      );
                                                                      return;
                                                                    }

                                                                    // Добавление группы
                                                                    context
                                                                        .read<
                                                                            SongsBloc>()
                                                                        .add(AddGroup(GroupModel(
                                                                            name:
                                                                                controller.text)));
                                                                    Get.back();
                                                                  }),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      // Кнопка "Отмена"
                                                      Expanded(
                                                        child:
                                                            CustomButtonSheet(
                                                          isSecond: true,
                                                          onPressed: () {
                                                            setState1(() {
                                                              controller
                                                                  .clear();
                                                            });
                                                          },
                                                          title: tr(LocaleKeys
                                                              .confirmation_cancel),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      } else if (state is SongsError) {
                                        return Center(
                                          child: Text(
                                            "Error: ${state.message}",
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  );
                                });
                              }

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
                                          initialChildSize: 0.8,
                                          expand: false,
                                          builder: (context, scrollController) {
                                            return ListView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              controller: scrollController,
                                              children: [
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20.0),
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
                                                // CustomTextField(
                                                //     controller: controller,
                                                //     onChanged: (value) =>
                                                //         setState(() {
                                                //           controller.text =
                                                //               value;
                                                //         }),
                                                //     title: tr(LocaleKeys
                                                //         .title_new_group)),
                                                // const SizedBox(
                                                //   height: 10,
                                                // ),
                                                buildCreateGroupField(context),
                                                // const SizedBox(
                                                //   height: 10,
                                                // ),
                                                BlocBuilder<SongsBloc,
                                                        SongsState>(
                                                    builder: (context, state) {
                                                  if (state is SongsLoading) {
                                                    return const Center(
                                                        child:
                                                            CircularProgressIndicator());
                                                  } else if (state
                                                      is SongsLoaded) {
                                                    return Column(
                                                      children: state.groups
                                                          .asMap()
                                                          .map(
                                                              (index, title) =>
                                                                  MapEntry(
                                                                      index,
                                                                      ListTile(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        // horizontalTitleGap: 0,
                                                                        minTileHeight:
                                                                            45,
                                                                        onTap:
                                                                            () {
                                                                          // изменение на существующую группу
                                                                          int lastOrderId =
                                                                              getLastOrderIdForGroup(state.groups[index].id!, state.songs)! + 1;
                                                                          setState(
                                                                              () {
                                                                            groupID =
                                                                                state.groups[index].id!;
                                                                            orderID =
                                                                                lastOrderId;
                                                                          });
                                                                          Get.back();
                                                                        },
                                                                        contentPadding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20,
                                                                            top:
                                                                                0,
                                                                            bottom:
                                                                                0),
                                                                        title: Text(state
                                                                            .groups[index]
                                                                            .name),
                                                                      )))
                                                          .values
                                                          .toList(),
                                                    );
                                                  } else if (state
                                                      is SongsError) {
                                                    return const SizedBox();
                                                  } else {
                                                    return const SizedBox();
                                                  }
                                                })
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
                                      color: colorFiolet.withValues(alpha: .3),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorFiolet),
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
                SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (name_songController.text.trim().isNotEmpty &&
                                name_singerController.text.trim().isNotEmpty &&
                                songController.text.trim().isNotEmpty) {
                              try {
                                if (isAudio && customFile!.path!.isNotEmpty) {
                                  final saveFile =
                                      await saveFilePermanently(customFile!);
                                  print(
                                      "SAVEFILE: ${saveFile.path} ${saveFile.path.isEmpty} $saveFile");
                                  // addSongAudio(
                                  //     name_songController.text,
                                  //     name_singerController.text,
                                  //     songController.text,
                                  //     saveFile.path,
                                  //     groupID,
                                  //     orderID);
                                  context.read<SongsBloc>().add(AddSong(Song(
                                      name_song: name_songController.text,
                                      name_singer: name_singerController.text,
                                      song: songController.text,
                                      path_music: saveFile.path,
                                      group: groupID,
                                      order: orderID,
                                      date_created: DateTime.now())));
                                } else {
                                  // addSongAudio(
                                  //     name_songController.text,
                                  //     name_singerController.text,
                                  //     songController.text,
                                  //     "",
                                  //     groupID,
                                  //     orderID);
                                  context.read<SongsBloc>().add(AddSong(Song(
                                      name_song: name_songController.text,
                                      name_singer: name_singerController.text,
                                      song: songController.text,
                                      path_music: "",
                                      group: groupID,
                                      order: orderID,
                                      date_created: DateTime.now())));
                                }

                                // final GuitarController guitar =
                                //     Get.put(GuitarController());
                                // guitar.refreshSongs();
                                AppMetrica.reportEvent(
                                    'create_song: successed!!! (${name_songController.text} - ${name_singerController.text} (audio = $isAudio))');
                                // if (isSuccess) {
                                Get.back();
                                // } else {
                              } catch (ex) {
                                print("exxe => $ex");
                                AppMetrica.reportEvent('create_song: $ex');
                                await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: Text(tr(LocaleKeys
                                                .alertDialog_error_title)),
                                            content: Text(tr(LocaleKeys
                                                .alertDialog_error_create_content)),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(tr(LocaleKeys
                                                      .alertDialog_error_OK)))
                                            ]));
                              }
                            } else {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: Text(tr(LocaleKeys
                                              .alertDialog_error_title)),
                                          content: Text(tr(LocaleKeys
                                              .alertDialog_error_not_data_content)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(tr(LocaleKeys
                                                    .alertDialog_error_OK)))
                                          ]));
                            }
                          } catch (ex) {
                            print("EXEPTION ===> $ex");
                          }
                        },
                        child: Text(
                          tr(LocaleKeys.add_song_save),
                          style: const TextStyle(fontSize: 18),
                        ))),
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
        date_created: DateTime.now());
    context.read<SongsBloc>().add(AddSong(songM));
  }

  bool isAudio = false;
  Future getFile() async {
    FilePickerResult? picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
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
}
