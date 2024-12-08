import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/storage/storage.dart';
import 'package:my_songbook/core/utils/currentNumber.dart';
import '../../components/player_widget.dart';
import '../../generated/locale_keys.g.dart';

class TestEdit_song extends StatefulWidget {
  const TestEdit_song(
      {
      required this.name_song,
      required this.name_singer,
      required this.song,
      this.audio,
      required this.asset,
      super.key});
  final name_song;
  final name_singer;
  final song;
  final audio;
  final asset;

  @override
  State<TestEdit_song> createState() => _TestEdit_songState();
}

class _TestEdit_songState extends State<TestEdit_song> {
  @override
  void initState() {
    // print("ID: ${widget.id}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController songController = TextEditingController();
    songController.text = widget.song;
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
                                        setState(() {
                                          isDeleteTest = true;
                                          isDeleteTestPut(isDeleteTest);
                                        });
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                      },
                                      child: Text(tr(LocaleKeys.confirmation_yes)))
                                ]));
                          
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
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
                      PlayerWidget(
                          name_song: widget.name_song,
                          name_singer: widget.name_singer,
                          audio: widget.audio,
                          asset: widget.asset),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${tr(LocaleKeys.edit_song_name_song)} ${widget.name_song}",
                        style: const TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "${tr(LocaleKeys.edit_song_name_singer)} ${widget.name_singer}",
                        style: const TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: songController,
                        // maxLines: 30,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            label: Text(tr(LocaleKeys.edit_song_label_text_song)),
                            contentPadding: const EdgeInsets.all(8),
                            border: const OutlineInputBorder()),
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
}
