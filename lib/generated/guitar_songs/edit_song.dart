import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/generated/guitar_songs/guitarDetalController.dart';

import '../../components/player_widget.dart';
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
              foregroundColor: Theme.of(context).primaryTextTheme.titleMedium!.color,
              // foregroundColor: Colors.black,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(tr(LocaleKeys.confirmation_title)),
                                content: Text(tr(LocaleKeys.edit_song_confirmation_content_delete)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(tr(LocaleKeys.confirmation_no))),
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
                                                    title: Text(tr(LocaleKeys.alertDialog_error_title)),
                                                    content: Text(
                                                        tr(LocaleKeys.alertDialog_error_delete_content)),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(tr(LocaleKeys.alertDialog_error_OK)))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: Text(tr(LocaleKeys.confirmation_yes)))
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
                                content: Text(tr(LocaleKeys.edit_song_confirmation_content_update)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text(tr(LocaleKeys.confirmation_no))),
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
                                                    title: Text(tr(LocaleKeys.alertDialog_error_title)),
                                                    content: Text(
                                                        tr(LocaleKeys.alertDialog_error_update_content)),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Text(tr(LocaleKeys.alertDialog_error_OK)))
                                                    ],
                                                  ));
                                        }
                                      },
                                      child: Text(tr(LocaleKeys.confirmation_yes)))
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
                        "${tr(LocaleKeys.edit_song_name_song)} ${widget.songModel.name_song}",
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "${tr(LocaleKeys.edit_song_name_singer)} ${widget.songModel.name_singer}",
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
                            label: Text(tr(LocaleKeys.edit_song_label_text_song)),
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
