import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:my_songbook/Storage/storage.dart';
import 'package:my_songbook/guitar_songs/testEdit_song.dart';

import '../components/auto_scroll.dart';
import '../components/player_widget.dart';
import '../settings/currentNumber.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: sizeText, color: Colors.black);
    final chordStyle = TextStyle(fontSize: sizeText, color: Colors.red);
    final _lyrics = '''
Am                  E7
Расцветали яблони и груши 
 E7                 Am
Поплыли туманы над рекой 
 A7      Dm         Am
Выходила на берег Катюша  
 Dm  Am    E7         Am 
На высокий берег на крутой 
 A7      Dm         Am
Выходила на берег Катюша  
 Dm  Am    E7         Am 
На высокий берег на крутой 
 
 Am                  E7
Выходила песню заводила 
 E7                 Am
Про степного сизого орла 
 A7      Dm         Am
Про того которого любила  
 Dm  Am    E7         Am 
Про того чьи письма берегла 
 A7      Dm         Am
Про того которого любила 
 Dm  Am    E7         Am  
Про того чьи письма берегла 
 
 Am                  E7
Ой ты песня песенка девичья 
 E7                 Am
Ты лети за ясным солнцем вслед 
 A7      Dm         Am
И бойцу на дальнем пограничье  
 Dm  Am    E7         Am 
От Катюши передай привет 
 A7      Dm         Am
И бойцу на дальнем пограничье  
 Dm  Am    E7         Am 
От Катюши передай привет 
 
 Am                  E7
Пусть он вспомнит девушку простую 
 E7                 Am
Пусть услышит как она поет 
 A7      Dm         Am
Пусть он землю бережет родную 
 Dm  Am    E7         Am 
А любовь Катюша сбережет
 A7      Dm         Am
Пусть он землю бережет родную 
 Dm  Am    E7         Am 
А любовь Катюша сбережет
''';
    return Scaffold(
      body: NestedScrollView(
        // controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            snap: false,
            floating: true,
            pinned: false,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            // backgroundColor: Colors.white,
            actions: [
              Tooltip(
                message: "Авто-прокрутка",
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        autoScroll(_scrollController);
                        speed = speed;
                        print("Speed: ${speed}");
                      });
                    },
                    icon: Icon(Icons.arrow_circle_down)),
              ),
              Tooltip(
                message: "Уменьшить размер текста",
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        sizeText -= 0.5;
                        sizeTextPut(sizeText);
                      });
                    },
                    icon: Icon(Icons.text_decrease)),
              ),
              Tooltip(
                message: "Увеличить размер текста",
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        sizeText += 0.5;
                        sizeTextPut(sizeText);
                      });
                    },
                    icon: Icon(Icons.text_increase)),
              ),
              Tooltip(
                message: "Редактор песни",
                child: IconButton(
                    onPressed: () {
                      Get.to(TestEdit_song(
                        name_song: "Катюша",
                        name_singer: "Военные песни",
                        song: _lyrics,
                        // audio: "",
                        asset: true,
                        // date_created: DateTime.now(),
                      ));
                    },
                    icon: Icon(Icons.edit_note)),
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text("Скорость прокрутки: "),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            speed += 5;
                            speedPut(speed);
                          });
                        },
                        icon: Icon(Icons.keyboard_double_arrow_up)),
                    Text(speed.toString()),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (speed > 0) {
                              speed -= 5;
                              speedPut(speed);
                            }
                          });
                        },
                        icon: Icon(Icons.keyboard_double_arrow_down)),
                  ],
                ),
                PlayerWidget(
                  name_song: "Катюша",
                  name_singer: "Военные песни",
                  audio: "",
                  asset: true,
                ),
                LyricsRenderer(
                  lyrics: _lyrics,
                  textStyle: textStyle,
                  chordStyle: chordStyle,
                  onTapChord: (String chord) {
                    print('pressed chord: $chord');
                  },
                  transposeIncrement: 0,
                  scrollSpeed: 0,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void akkord(String song){

}