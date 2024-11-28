import 'dart:async';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_songbook/core/styles/colors.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({
    this.name_song = '',
    this.name_singer = '',
    required this.audio,
    required this.asset,
    super.key,
  });
  final String name_song;
  final String name_singer;
  final audio;
  final bool asset;
  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
    var stream;

  @override
  void initState() {
    if (widget.asset) {
      assetAudio();
      AppMetrica.reportEvent('Катюша');
    } else {
      setAudio();
      AppMetrica.reportEvent('${widget.name_song} - ${widget.name_singer} (${widget.audio})');
    }

    stream = audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
    super.initState();
  }

  Future assetAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    final player = AudioCache(prefix: "assets/audio/");
    final urlRU = await player.load("katusha.mp3");
    final urlEN = await player.load("katushaEN.mp3");
    audioPlayer.setSourceUrl(
      context.locale == Locale('ru') ?
      urlRU.path : urlEN.path,
    );
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    // final player = AudioCache(prefix: "assets/audio/");
    // final url = await player.load("kino-kukushka-mp3.mp3");
  
    // File file = File(widget.audio);
    // String content = await file.readAsString(encoding: latin1);
    String encodedUrl = Uri.encodeFull(widget.audio);
    audioPlayer.setSourceUrl(widget.audio);
    print("set audio: ${widget.audio} = $encodedUrl");
  }

  @override
  void dispose() {
    audioPlayer.stop();
    stream.cancel();
    audioPlayer.dispose();
    stream.cancel();
    super.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.name_song != ""
            ? Text(
                widget.name_song,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : SizedBox(),
        widget.name_song != ""
            ? SizedBox(
                height: 4,
              )
            : SizedBox(),
        widget.name_singer != ""
            ? Text(widget.name_singer, style: TextStyle(fontSize: 20))
            : SizedBox(),
        Slider(
          min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position);

            await audioPlayer.resume();
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(position)),
              Text(formatTime(duration - position)),
            ],
          ),
        ),
        CircleAvatar(
          radius: 25,
          backgroundColor: colorFiolet,
          child: IconButton(
            splashColor: colorFiolet.withOpacity(0.3),
            color: Colors.white,
            onPressed: () async {
              isPlaying
                  ? await audioPlayer.pause()
                  : await audioPlayer.resume();
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
            ),
            iconSize: 30,
          ),
        )
      ],
    );
  }
}
