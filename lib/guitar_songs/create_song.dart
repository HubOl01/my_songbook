import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../Storage/storage.dart';
import '../components/player_widget.dart';
import '../settings/currentNumber.dart';
import 'db/dbSongs.dart';
import 'guitarController.dart';
import 'model/songsModel.dart';

class Create_song extends StatefulWidget {
  const Create_song({super.key});

  @override
  State<Create_song> createState() => _Create_songState();
}

class _Create_songState extends State<Create_song> {
  TextEditingController name_songController = new TextEditingController();
  TextEditingController name_singerController = new TextEditingController();
  TextEditingController songController = new TextEditingController();
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
            title: Text("Добавление песни"),
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
                !isClosedWarring
                    ? SizedBox(
                        // color: Colors.blue,
                        height: 90,
                        child: Stack(children: [
                          Positioned(
                              top: -10,
                              right: -10,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isClosedWarring = true;
                                    isClosedWarringPut(isClosedWarring);
                                  });
                                },
                                icon: Icon(Icons.close),
                                color: Colors.red,
                                iconSize: 22,
                              )),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              "Внимание! Заполняйте пожалуйста название песни, исполнителя и аудиофайла корректно, т.к. в будущем вы не сможете изменить. Только можно удалить и заново заполнить!",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ]),
                      )
                    : SizedBox(),
                SizedBox(
                  height: !isClosedWarring ? 10 : 0,
                ),
                TextField(
                  controller: name_songController,
                  // maxLines: 30,
                  decoration: InputDecoration(
                      label: Text("Название песни"),
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
                      label: Text("Исполнитель"),
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
                      label: Text("Текст песни"),
                      contentPadding: EdgeInsets.all(8),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Добавление аудиофайла",
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
                            await FilePicker.platform.clearTemporaryFiles();
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
                                // if (isSuccess) {
                                Get.back();
                                // } else {
                              } catch (ex) {
                                print("exxe => ${ex}");
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                            title: Text("Ошибка"),
                                            content: Text(
                                                "Не удалось создать песню, попробуйте еще раз"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text("Ок"))
                                            ]));
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                          title: Text("Ошибка"),
                                          content:
                                              Text("Вы не заполнили данные"),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text("Ок"))
                                          ]));
                            }
                          } catch (ex) {
                            print("EXEPTION ===> ${ex}");
                          }
                        },
                        child: Text(
                          "Сохранить",
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
    var appDir = (await getTemporaryDirectory()).path;
    new Directory(appDir).delete(recursive: true);
    FilePickerResult? _picker = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // allowedExtensions: ['mp3'],
    );
    if (_picker != null) {
      setState(() {
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

        if (name_singerController.text.trim().isEmpty ||
            name_songController.text.trim().isEmpty) {
          autotext(file.name);
        } else {
          showDialog(
              context: context,
              builder: (builder) => AlertDialog(
                    title: Text("Подтверждение"),
                    content:
                        Text("Переименовать название песни и исполнителя?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text("Нет")),
                      Spacer(),
                      TextButton(
                          onPressed: () {
                            autotext(file.name);
                            Get.back();
                          },
                          child: Text("Да"))
                    ],
                  ));
        }
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

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');
    return File(file.path!).copy(newFile.path);
  }

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
      name_singerController.text = nameSinger;
      name_songController.text = nameSong;
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
      // name_singerController.text = nameSinger;
      name_songController.text = nameSong;
    }
  }
}
