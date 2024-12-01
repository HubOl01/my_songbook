import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/pages/guitar_songs/guitarDetalController.dart';
import '../../components/player_widget.dart';
import '../../core/data/dbSongs.dart';
import '../../core/model/songsModel.dart';
import 'works_file.dart';

class Edit_song extends StatefulWidget {
  const Edit_song({required this.songModel, required this.asset, super.key});
  final Song songModel;
  final bool asset;

  @override
  State<Edit_song> createState() => _Edit_songState();
}

class _Edit_songState extends State<Edit_song> {
  TextEditingController name_songController = new TextEditingController();
  TextEditingController name_singerController = new TextEditingController();
  TextEditingController song_controller = new TextEditingController();
  bool isAudio = false;
  PlatformFile? customFile;
  Future getFile() async {
    // var appDir = (await getTemporaryDirectory()).path;
    // new Directory(appDir).delete(recursive: true);
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

  // Future<File> saveFilePermanentlyOld(PlatformFile file) async {
  //   final appStorage = await getApplicationDocumentsDirectory();
  //   final newFile = File('${appStorage.path}/${file.name}');
  //   return File(file.path!).copy(newFile.path);
  // }

  // Future<File> saveFilePermanently(PlatformFile file) async {
  //   final mySongsDirectory = Directory('/storage/emulated/0/My Songbook');
  //   // final directory = await getApplicationDocumentsDirectory();
  //   // final newFile = File('${appStorage.path}/${file.name}');
  //   if (!await mySongsDirectory.exists()) {
  //     await mySongsDirectory .create(recursive: true);
  //   }
  //   // final mySongsDirectory = Directory('${directory.path}');

  //   final filePath = File('${mySongsDirectory.path}/${file.name}');
  //   return filePath;
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

  @override
  void initState() {
    print("ID: ${widget.songModel.id}");
    super.initState();
    name_songController.text = widget.songModel.name_song;
    name_singerController.text = widget.songModel.name_singer;
    song_controller.text = widget.songModel.song;
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
                                          // final GuitarController guitar =
                                          //     Get.put(GuitarController());
                                          // guitar.refreshSongs();
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        } catch (ex) {
                                          print("delete ex ${ex}");
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
                    icon: Icon(
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
                                                "SAVEFILE: ${saveFile.path} ${saveFile.path.isEmpty} ${saveFile}");
                                            updateSong(
                                                name_songController.text,
                                                name_singerController.text,
                                                song_controller.text,
                                                saveFile.path);
                                          } else {
                                            updateSong(
                                                name_songController.text,
                                                name_singerController.text,
                                                song_controller.text,
                                                "");
                                          }

                                          // final GuitarController guitar =
                                          //     Get.put(GuitarController());
                                          // guitar.refreshSongs();
                                          final GuitarDetalController
                                              guitarDetal = Get.put(
                                                  GuitarDetalController(
                                                      id: widget.songModel.id));
                                          guitarDetal.refreshSong();
                                          Get.back();
                                          Get.back();
                                        } catch (ex) {
                                          print("update ex ${ex}");
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
                    icon: Icon(Icons.check)),
              ],
            )
          ],
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(
                      //   "${tr(LocaleKeys.edit_song_name_song)} ${widget.songModel.name_song}",
                      //   style: TextStyle(fontSize: 15),
                      //   // textAlign: TextAlign.center,
                      // ),
                      // Text(
                      //   "${tr(LocaleKeys.edit_song_name_singer)} ${widget.songModel.name_singer}",
                      //   style: TextStyle(fontSize: 15),
                      //   // textAlign: TextAlign.center,
                      // ),
                      TextField(
                        controller: name_songController,
                        // maxLines: 30,
                        decoration: InputDecoration(
                            label:
                                Text(tr(LocaleKeys.add_song_label_name_song)),
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
                            label:
                                Text(tr(LocaleKeys.add_song_label_name_singer)),
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: song_controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            label:
                                Text(tr(LocaleKeys.edit_song_label_text_song)),
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()),
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
                                PlayerWidget(
                                    audio: customFile!.path!, asset: false),
                                Text(customFile!.path!),
                              ],
                            )
                          : SizedBox(),
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

  Future updateSong(String name_song, String name_singer, String song,
      String path_music) async {
    final songM = widget.songModel.copy(
        name_song: name_song,
        name_singer: name_singer,
        song: song,
        path_music: path_music);
    await DBSongs.instance.update(songM);
  }
}

Future deleteSong(int id) async {
  await DBSongs.instance.delete(id);
}
