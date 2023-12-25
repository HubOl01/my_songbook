import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../Storage/storage.dart';
import '../components/player_widget.dart';
import '../generated/locale_keys.g.dart';
import '../settings/currentNumber.dart';
import 'db/dbSongs.dart';
import 'guitarController.dart';
import 'model/songsModel.dart';
import 'works_file.dart';

class Create_song extends StatefulWidget {
  const Create_song({super.key});

  @override
  State<Create_song> createState() => _Create_songState();
}

class _Create_songState extends State<Create_song> {
  TextEditingController name_songController = new TextEditingController();
  TextEditingController name_singerController = new TextEditingController();
  TextEditingController songController = new TextEditingController();
  String name_song = "";
  String name_singer = "";
  // late String number;
  // late String title;
  // late String content;
  PlatformFile? customFile;

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
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // !isClosedWarring
                //     ? SizedBox(
                //         // color: Colors.blue,
                //         height: 90,
                //         child: Stack(children: [
                //           Positioned(
                //               top: -10,
                //               right: -10,
                //               child: IconButton(
                //                 onPressed: () {
                //                   setState(() {
                //                     isClosedWarring = true;
                //                     isClosedWarringPut(isClosedWarring);
                //                   });
                //                 },
                //                 icon: Icon(Icons.close),
                //                 color: Colors.red,
                //                 iconSize: 22,
                //               )),
                //           Align(
                //             alignment: Alignment.bottomCenter,
                //             child: Text(
                //               tr(LocaleKeys.add_song_attention),
                //               textAlign: TextAlign.center,
                //               style: TextStyle(color: Colors.red),
                //             ),
                //           ),
                //         ]),
                //       )
                //     : SizedBox(),
                SizedBox(
                  height: !isClosedWarring ? 10 : 0,
                ),
                TextField(
                  controller: name_songController,
                  // maxLines: 30,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_name_song)),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: name_singerController,
                  // maxLines: 30,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_name_singer)),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: songController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                      label: Text(tr(LocaleKeys.add_song_label_text_song)),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  tr(LocaleKeys.add_song_add_audiofile),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
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
                          child: Icon(
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
                    : SizedBox(),
                SizedBox(
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
                                      "SAVEFILE: ${saveFile.path} ${saveFile.path.isEmpty} ${saveFile}");
                                  addSongAudio(
                                      name_songController.text,
                                      name_singerController.text,
                                      songController.text,
                                      saveFile.path);
                                } else {
                                  addSongAudio(
                                      name_songController.text,
                                      name_singerController.text,
                                      songController.text,
                                      "");
                                }

                                final GuitarController guitar =
                                    Get.put(GuitarController());
                                guitar.refreshSongs();
                                AppMetrica.reportEvent('create_song: successed!!! (${name_songController.text} - ${name_singerController.text} (audio = ${isAudio}))');
                                // if (isSuccess) {
                                Get.back();
                                // } else {
                              } catch (ex) {
                                print("exxe => ${ex}");
                                AppMetrica.reportEvent('create_song: ${ex}');
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
                            print("EXEPTION ===> ${ex}");
                          }
                        },
                        child: Text(
                          tr(LocaleKeys.add_song_save),
                          style: TextStyle(fontSize: 18),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addSongAudio(String name_song, String name_singer, String song,
      String path_music) async {
    final songM = Song(
        name_song: name_song,
        name_singer: name_singer,
        song: song,
        path_music: path_music,
        date_created: DateTime.now());
    DBSongs.instance.create(songM);
  }

  Future addSong(String name_song, String name_singer, String song) async {
    final songM = Song(
        name_song: name_song,
        name_singer: name_singer,
        song: song,
        date_created: DateTime.now());
    DBSongs.instance.create(songM);
  }

  bool isAudio = false;
  Future getFile() async {
    // var appDir = (await getTemporaryDirectory()).path;
    // new Directory(appDir).delete(recursive: true);
    FilePickerResult? _picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: ['mp3'],
    );
    if (_picker != null) {
      setState(()  {
        isAudio = false;
        customFile = null;
        PlatformFile file = _picker.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
        customFile = file;
        isAudio = true;
        autotext(customFile!.name);
        // xfile = file;
      });

      // return file;
      // final saveFile = await saveFilePermanently(file);
      // print("From path: ${file.path!}");
      // print("To path: ${saveFile.path}");
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
    } else {
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
