// import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../components/customButton.dart';
import '../../core/bloc/song_bloc.dart';
import '../../core/bloc/songs_bloc.dart' hide UpdateSong;
import '../../components/auto_scroll.dart';
import '../../components/player_widget.dart';
import '../../core/storage/storage.dart';
import '../../core/styles/colors.dart';
import '../../core/utils/currentNumber.dart';
import '../../generated/locale_keys.g.dart';
import 'edit_song.dart';
import '../../core/model/songsModel.dart';

class TitleContent extends StatelessWidget {
  final Song song;
  const TitleContent({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        song.name_song != ""
            ? Text(
                song.name_song,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
        song.name_song != ""
            ? const SizedBox(
                height: 4,
              )
            : const SizedBox(),
        song.name_singer != ""
            ? Text(
                song.name_singer,
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )
            : const SizedBox(),
      ],
    );
  }
}

class GuitarDetal extends StatefulWidget {
  final int id;
  final int speedTextSong;
  const GuitarDetal({required this.id, super.key, required this.speedTextSong});

  @override
  State<GuitarDetal> createState() => _GuitarDetalState();
}

class _GuitarDetalState extends State<GuitarDetal> {
  final ScrollController scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();
  double sizeTextCo = 14.0;
  int speedTextCo = 0;
  void initSpeed() {
    setState(() {
      speed = speedTextCo;
    });
  }

  void initSizedText() {
    setState(() {
      sizeText = sizeTextCo;
    });
  }

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    setState(() {
      sizeTextCo = sizeText;
      speedTextCo = widget.speedTextSong;
    });
    initSpeed();
    context.read<SongBloc>().add(ReadSong(widget.id));
  }

  @override
  void dispose() {
    commentController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            forceElevated: innerBoxIsScrolled,
            floating: true,
            pinned: false,
            backgroundColor: Colors.transparent,
            foregroundColor:
                Theme.of(context).primaryTextTheme.titleMedium?.color,
            elevation: 0,
            actions: _buildAppBarActions(context),
          ),
        ],
        body: SingleChildScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<SongBloc, SongState>(
            builder: (context, songState) {
              if (songState is SongLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: _buildSongSpeedScroll(songState.song, context),
                    ),
                    InkWell(
                      onTap: () async {
                        setState(() {
                          commentController.text =
                              songState.song.comment ?? "";
                        });
        
                        await showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          context: context,
                          builder: (context) => StatefulBuilder(
                              builder: (context, setStateBottom) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: context.isLandscape
                                      ? 0
                                      : MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                              child: DraggableScrollableSheet(
                                initialChildSize: 0.5,
                                expand: false,
                                builder: (context, scrollController) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          child: Text(
                                            tr(LocaleKeys
                                                .summary_of_the_song),
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          controller: scrollController,
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: TextField(
                                                controller: commentController,
                                                maxLines: null,
                                                onChanged: (v) =>
                                                    setStateBottom(() {}),
                                                cursorColor: colorFiolet,
                                                decoration: InputDecoration(
                                                    hintText: tr(LocaleKeys
                                                        .write_something),
                                                    hintStyle: TextStyle(
                                                        color: context
                                                                .isDarkMode
                                                            ? Colors.white
                                                                .withValues(
                                                                    alpha: .7)
                                                            : Colors
                                                                .grey[600]),
                                                    alignLabelWithHint: true,
                                                    disabledBorder:
                                                        const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                    enabledBorder:
                                                        const OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    focusedBorder:
                                                        const OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SafeArea(
                                        top: false,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 10),
                                          child: SizedBox(
                                            height: 40,
                                            width: context.width,
                                            child: CustomButton(
                                              onPressed: commentController
                                                          .text ==
                                                      songState.song.comment
                                                  ? null
                                                  : () {
                                                      context
                                                          .read<SongBloc>()
                                                          .add(UpdateSong(
                                                              songState.song.copy(
                                                                  comment:
                                                                      commentController
                                                                          .text)));
                                                      context
                                                          .read<SongsBloc>()
                                                          .add(LoadSongs());
                                                      context
                                                          .read<SongBloc>()
                                                          .add(ReadSong(
                                                              songState
                                                                  .song.id!));
                                                      Get.back();
                                                    },
                                              child: Text(tr(
                                                  LocaleKeys.add_song_save)),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            );
                          }),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          children: [
                            Text(
                              tr(LocaleKeys.summary_of_the_song),
                            ),
                            const Spacer(),
                            Icon(
                              songState.song.comment == ""
                                  ? Icons.comments_disabled
                                  : Icons.comment,
                              color: songState.song.comment == ""
                                  ? null
                                  : colorFiolet,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: _buildSongContent(songState.song, context),
                    ),
                  ],
                );
              } else if (songState is SongsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (songState is SongError) {
                return Center(
                  child: Text(
                    'Error: ${songState.message}',
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  // Построение списка действий в AppBar
  List<Widget> _buildAppBarActions(BuildContext context) {
    return [
      BlocBuilder<SongBloc, SongState>(
        builder: (context, songState) {
          if (songState is SongLoaded) {
            return IconButton(
              onPressed: () => _shareSong(songState.song),
              icon: const Icon(Icons.share),
            );
          }
          return const SizedBox();
        },
      ),
      Tooltip(
        message: tr(LocaleKeys.tooltip_autoscroll),
        child: IconButton(
          onPressed: () {
            autoScroll(scrollController);
            setState(() {
              speedTextCo = speed;
            });
          },
          icon: const Icon(Icons.arrow_circle_down),
        ),
      ),
      Tooltip(
        message: tr(LocaleKeys.tooltip_text_down),
        child: IconButton(
          onPressed: () {
            setState(() {
              sizeTextCo =
                  (sizeTextCo - 0.5).clamp(10.0, 24.0); // Ограничиваем диапазон
              initSizedText();
            });
            sizeTextPut(sizeTextCo);
          },
          icon: const Icon(Icons.text_decrease),
        ),
      ),
      Tooltip(
        message: tr(LocaleKeys.tooltip_text_up),
        child: IconButton(
          onPressed: () {
            setState(() {
              sizeTextCo =
                  (sizeTextCo + 0.5).clamp(10.0, 24.0); // Ограничиваем диапазон
              initSizedText();
            });
            sizeTextPut(sizeTextCo);
          },
          icon: const Icon(Icons.text_increase),
        ),
      ),
      BlocBuilder<SongBloc, SongState>(
        builder: (context, songState) {
          if (songState is SongLoaded) {
            return IconButton(
              onPressed: () => _editSong(songState.song),
              icon: const Icon(Icons.edit_note),
            );
          }
          return const SizedBox();
        },
      ),
    ];
  }

  // Построение контента песни
  // Widget _buildSongContent(Song song, BuildContext context) {
  //   speedTextCo = song.speedScroll ?? 0;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       if (song.path_music != null && song.path_music!.isNotEmpty)
  //         Column(
  //           children: [
  //             PlayerWidget(
  //               name_song: song.name_song,
  //               name_singer: song.name_singer,
  //               audio: song.path_music.toString(),
  //               asset: false,
  //             ),
  //             Text(song.path_music.toString()),
  //           ],
  //         )
  //       else
  //         TitleContent(song: song),
  //       LyricsRenderer(
  //         lyrics: song.song,

  //         // textStyle: TextStyle(fontSize: sizeTextCo),
  //         textStyle: TextStyle(
  //             fontSize: sizeText,
  //             color: Theme.of(context).primaryTextTheme.titleMedium!.color),
  //         chordStyle: TextStyle(fontSize: sizeTextCo, color: Colors.red),
  //         // chordStyle: const TextStyle(fontSize: 14, color: Colors.red),
  //         onTapChord: (String chord) => print('Pressed chord: $chord'),
  //       ),
  //       const SizedBox(height: 12),
  //     ],
  //   );
  // }
  Widget _buildSongContent(Song song, BuildContext context) {
    speedTextCo = song.speedScroll ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (song.path_music != null && song.path_music!.isNotEmpty)
          FutureBuilder<bool>(
            future: _checkAudioFileExists(song.path_music!),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              if (!snapshot.data!) {
                return const Center(
                  child: Text("Аудиофайл не найден"),
                );
              }
              return PlayerWidget(
                name_song: song.name_song,
                name_singer: song.name_singer,
                audio: song.path_music.toString(),
                asset: false,
              );
            },
          )
        else
          TitleContent(song: song),
        LyricsRenderer(
          lyrics: song.song,
          textStyle: TextStyle(
            fontSize: sizeText,
            color: Theme.of(context).primaryTextTheme.titleMedium!.color,
          ),
          chordStyle: TextStyle(fontSize: sizeTextCo, color: Colors.red),
          onTapChord: (String chord) => print('Pressed chord: $chord'),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Future<bool> _checkAudioFileExists(String path) async {
    File file = File(path);
    return await file.exists();
  }

  Widget _buildSongSpeedScroll(Song song, BuildContext context) {
    speedTextCo = song.speedScroll ?? 0;
    return Row(
      children: [
        Text(tr(LocaleKeys.text_speed_scroll)),
        IconButton(
          onPressed: () {
            setState(() {
              speedTextCo += 5;
            });
            context
                .read<SongBloc>()
                .add(UpdateSpeedScroll(song.id!, speedTextCo));
            speedPut(speedTextCo);
            initSpeed();
          },
          icon: const Icon(Icons.keyboard_double_arrow_up),
        ),
        Text(speedTextCo.toString()),
        IconButton(
          onPressed: () {
            if (speedTextCo > 0) {
              setState(() {
                speedTextCo -= 5;
              });
              context
                  .read<SongBloc>()
                  .add(UpdateSpeedScroll(song.id!, speedTextCo));
              speedPut(speedTextCo);
              initSpeed();
            }
          },
          icon: const Icon(Icons.keyboard_double_arrow_down),
        ),
      ],
    );
  }

  // Функция для шаринга
  Future<void> _shareSong(Song song) async {
    try {
      await Share.share(
        "${tr(LocaleKeys.edit_song_name_song)} ${song.name_song}\n${tr(LocaleKeys.edit_song_name_singer)} ${song.name_singer}\n\n${song.song}",
        subject: "${song.name_song} from My Songbook",
      );
    } catch (e) {
      print("Share error: $e");
    }
  }

  // Переход в режим редактирования песни
  void _editSong(Song song) {
    Get.to(Edit_song(songModel: song, asset: false));
  }
}
