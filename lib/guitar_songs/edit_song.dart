import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/guitar_songs/guitarDetalController.dart';

import '../components/player_widget.dart';
import 'db/dbSongs.dart';
import 'guitarController.dart';

class Edit_song extends StatefulWidget {
  const Edit_song({this.songModel, required this.asset, super.key});
  final songModel;
  final asset;

  @override
  State<Edit_song> createState() => _Edit_songState();
}

class _Edit_songState extends State<Edit_song> {
  @override
  void initState() {
    print("ID: ${widget.songModel.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController song_controller = new TextEditingController();
    song_controller.text = widget.songModel.song;
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
              foregroundColor: Colors.black,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Подтверждение"),
                                content: Text("Вы хотите удалить?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Нет")),
                                  TextButton(
                                      onPressed: () async {
                                        try {
                                          deleteSong(widget.songModel.id!);
                                          final GuitarController guitar =
                                              Get.put(GuitarController());
                                          guitar.refreshSongs();
                                          Get.back();
                                          Get.back();
                                          Get.back();
                                        } catch (ex) {
                                          print("delete ex ${ex}");
                                          await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Ошибка"),
                                                    content: Text(
                                                        "Не удалось удалить песню, попробуйте еще раз"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("ОК"))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: Text("Да"))
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
                                title: Text("Подтверждение"),
                                content: Text("Вы хотите изменить?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Нет")),
                                  TextButton(
                                      onPressed: () async {
                                        try {
                                          updateSong(song_controller.text);
                                          final GuitarController guitar =
                                              Get.put(GuitarController());
                                          guitar.refreshSongs();
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
                                                    title: Text("Ошибка"),
                                                    content: Text(
                                                        "Не удалось изменить песню, попробуйте еще раз"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text("ОК"))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: Text("Да"))
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
                      Text(
                        "Название песни: ${widget.songModel.name_song}",
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "Исполнитель: ${widget.songModel.name_singer}",
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: song_controller,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            label: Text("Текст песни"),
                            contentPadding: EdgeInsets.all(8),
                            border: OutlineInputBorder()),
                      )
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

  Future updateSong(String song) async {
    final songM = widget.songModel!.copy(song: song);
    await DBSongs.instance.update(songM);
  }
}

Future deleteSong(int id) async {
  await DBSongs.instance.delete(id);
}
