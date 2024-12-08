import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/storage/storage.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/pages/guitar_songs/testEdit_song.dart';

import '../../components/auto_scroll.dart';
import '../../components/player_widget.dart';
import '../../core/utils/currentNumber.dart';

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
    final textStyle = TextStyle(fontSize: sizeText, color: Theme.of(context).primaryTextTheme.titleMedium!.color);
    final chordStyle = TextStyle(fontSize: sizeText, color: Colors.red);
    const lyricsRU = '''
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
    const lyricsEN = '''
Apple trees and pear trees were a flower,
River mist was rising all around.
Young Katyusha went strolling by the hour
On the steep banks,
O’er the rocky ground.

By the river’s bank she sang a love song
Of her hero in a distant land.
Of the one she’d dearly loved for so long,
Holding tight his letters in her hand.

Oh, my song, song of a maiden’s true love,
To my dear one travel with the sun.
To the one who Katyusha loves so,
Bring my greetings to him, one by one.

Let him know that I am true and faithful,
Let him hear the love song that I send.
Tell him as he defends our home that grateful,
True Katyusha our love will defend.

Apple trees and pear trees were a flower,
River mist was rising all around.
Young Katyusha went strolling by the hour
On the steep banks,
O’er the rocky ground.
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
            foregroundColor: Theme.of(context).primaryTextTheme.titleMedium!.color,
            elevation: 0,
            // backgroundColor: Colors.white,
            actions: [
              Tooltip(
                message: tr(LocaleKeys.tooltip_autoscroll),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        autoScroll(_scrollController);
                        speed = speed;
                        print("Speed: $speed");
                      });
                    },
                    icon: const Icon(Icons.arrow_circle_down)),
              ),
              Tooltip(
                message: tr(LocaleKeys.tooltip_text_down),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        sizeText -= 0.5;
                        sizeTextPut(sizeText);
                      });
                    },
                    icon: const Icon(Icons.text_decrease)),
              ),
              Tooltip(
                message: tr(LocaleKeys.tooltip_text_up),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        sizeText += 0.5;
                        sizeTextPut(sizeText);
                      });
                    },
                    icon: const Icon(Icons.text_increase)),
              ),
              Tooltip(
                message: tr(LocaleKeys.tooltip_edit_song),
                child: IconButton(
                    onPressed: () {
                      Get.to(TestEdit_song(
                        name_song: tr(LocaleKeys.ex_name_song),
                        name_singer: tr(LocaleKeys.ex_name_singer),
                        song: context.locale == const Locale('ru')
                            ? lyricsRU
                            : lyricsEN,
                        audio: "",
                        asset: true,
                        // date_created: DateTime.now(),
                      ));
                    },
                    icon: const Icon(Icons.edit_note)),
              ),
            ],
          ),
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(tr(LocaleKeys.text_speed_scroll)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            speed += 5;
                            speedPut(speed);
                          });
                        },
                        icon: const Icon(Icons.keyboard_double_arrow_up)),
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
                        icon: const Icon(Icons.keyboard_double_arrow_down)),
                  ],
                ),
                PlayerWidget(
                  name_song: tr(LocaleKeys.ex_name_song),
                  name_singer: tr(LocaleKeys.ex_name_singer),
                  audio: "",
                  asset: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  context.tr(LocaleKeys.testWarning),
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 5,
                ),
                LyricsRenderer(
                    lyrics:
                        context.locale == const Locale('ru') ? lyricsRU : lyricsEN,
                    textStyle: textStyle,
                    chordStyle: chordStyle,
                    onTapChord: () {}),
                // Text(
                //   context.locale == Locale('ru') ? _lyricsRU : _lyricsEN,
                //   style: textStyle,
                // ),
                const SizedBox(
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

void akkord(String song) {}
