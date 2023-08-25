import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/Storage/storage.dart';
import 'package:my_songbook/settings/currentNumber.dart';
import '../components/player_widget.dart';

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
    TextEditingController song_controller = new TextEditingController();
    song_controller.text = widget.song;
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
                                        setState(() {
                                          isDeleteTest = true;
                                          isDeleteTestPut(isDeleteTest);
                                        });
                                      Get.back();
                                      Get.back();
                                      Get.back();
                                      },
                                      child: Text("Да"))
                                ]));
                          
                    },
                    icon: Icon(
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
              physics: BouncingScrollPhysics(),
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
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Название песни: ${widget.name_song}",
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      Text(
                        "Исполнитель: ${widget.name_singer}",
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: song_controller,
                        // maxLines: 30,
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
}
