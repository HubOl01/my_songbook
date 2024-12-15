// import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chord/flutter_chord.dart';
import 'package:get/get.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/bloc/song_bloc.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../components/auto_scroll.dart';
import '../../components/player_widget.dart';
import '../../core/storage/storage.dart';
import '../../core/utils/currentNumber.dart';
import 'edit_song.dart';
import '../../core/model/songsModel.dart';

// class GuitarDetal extends StatefulWidget {
//   final id;
//   const GuitarDetal({required this.id, super.key});

//   @override
//   State<GuitarDetal> createState() => _GuitarDetalState();
// }

// class _GuitarDetalState extends State<GuitarDetal> {
//   final scrollController = ScrollController();
//   var sizeTextCo = 14.0;
//   var speedTextCo = 0;

//   @override
//   void initState() {
//     print("ID ---> ${widget.id}");
//     setState(() {
//       speedTextCo = speed;
//     });

//     context.read<SongsBloc>().add(LoadSong(widget.id));

//     super.initState();
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//           physics: const NeverScrollableScrollPhysics(),
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//                 SliverAppBar(
//                   leading: IconButton(
//                       onPressed: () {
//                         context.read<SongsBloc>().add(LoadSongs());
//                         Get.back();
//                       },
//                       icon: const Icon(Icons.arrow_back)),
//                   forceElevated: innerBoxIsScrolled,
//                   snap: false,
//                   floating: true,
//                   pinned: false,
//                   backgroundColor: Colors.transparent,
//                   foregroundColor:
//                       Theme.of(context).primaryTextTheme.titleMedium!.color,
//                   elevation: 0,
//                   // backgroundColor: Colors.white,
//                   actions: [
//                     BlocBuilder<SongsBloc, SongsState>(
//                       builder: (context, songState) {
//                         if (songState is SongLoaded) {
//                           Song songModel = songState.song;
//                           return IconButton(
//                               onPressed: () async {
//                                 try {
//                                   if (songModel.path_music != '') {
//                                     try {
//                                       await Share.shareXFiles(
//                                           [XFile(songModel.path_music!)],
//                                           text:
//                                               "${tr(LocaleKeys.edit_song_name_song)}${songModel.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${songModel.name_singer}\n\n${songModel.song}",
//                                           subject:
//                                               "${songModel.name_song} from My Songbook");
//                                       AppMetrica.reportEvent(
//                                           'Share successed!!! (audio)');
//                                     } catch (e) {
//                                       print("file exception: $e");
//                                       AppMetrica.reportEvent(
//                                           'Share: file exception $e');
//                                       Share.share(
//                                           "${tr(LocaleKeys.edit_song_name_song)}${songModel.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${songModel.name_singer}\n\n${songModel.song}",
//                                           subject:
//                                               "${songModel.name_song} from My Songbook");
//                                     }
//                                   } else {
//                                     AppMetrica.reportEvent(
//                                         'Share successed!!! (not audio)');
//                                     await Share.share(
//                                         "${tr(LocaleKeys.edit_song_name_song)}${songModel.name_song}\n${tr(LocaleKeys.edit_song_name_singer)}${songModel.name_singer}\n\n${songModel.song}",
//                                         subject:
//                                             "${songModel.name_song} from My Songbook");
//                                   }
//                                 } catch (e) {
//                                   print("share_plus exception: $e");
//                                 }
//                               },
//                               icon: const Icon(Icons.share));
//                         } else if (songState is SongsLoading) {
//                           return const SizedBox();
//                         } else if (songState is SongsError) {
//                           return const SizedBox();
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                     Tooltip(
//                       message: tr(LocaleKeys.tooltip_autoscroll),
//                       child: IconButton(
//                           onPressed: () {
//                             autoScroll(scrollController);
//                             setState(() {
//                               speedTextCo = speed;
//                             });
//                             print("Speed: ");
//                           },
//                           icon: const Icon(Icons.arrow_circle_down)),
//                     ),
//                     Tooltip(
//                       message: tr(LocaleKeys.tooltip_text_down),
//                       child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               sizeTextCo -= 0.5;
//                               sizeTextPut(sizeTextCo);
//                               initSizedText();
//                             });
//                           },
//                           icon: const Icon(Icons.text_decrease)),
//                     ),
//                     Tooltip(
//                       message: tr(LocaleKeys.tooltip_text_up),
//                       child: IconButton(
//                           onPressed: () {
//                             setState(() {
//                               sizeTextCo += 0.5;
//                               sizeTextPut(sizeTextCo);
//                               initSizedText();
//                             });
//                           },
//                           icon: const Icon(Icons.text_increase)),
//                     ),
//                     BlocBuilder<SongsBloc, SongsState>(
//                       builder: (context, songState) {
//                         if (songState is SongLoaded) {
//                           Song songModel = songState.song;
//                           return Tooltip(
//                             message: tr(LocaleKeys.tooltip_edit_song),
//                             child: IconButton(
//                                 onPressed: () {
//                                   Get.to(Edit_song(
//                                     songModel: songModel,
//                                     asset: false,
//                                   ));
//                                 },
//                                 icon: const Icon(Icons.edit_note)),
//                           );
//                         } else if (songState is SongsLoading) {
//                           return const SizedBox();
//                         } else if (songState is SongsError) {
//                           return const SizedBox();
//                         }
//                         return const SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//           body: SingleChildScrollView(
//             controller: scrollController,
//             physics: const BouncingScrollPhysics(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   BlocBuilder<SongsBloc, SongsState>(
//                       builder: (context, songState) {
//                     if (songState is SongLoaded) {
//                       Song songModel = songState.song;
//                       speedTextCo = songModel.speedScroll!;
//                       return Row(
//                         children: [
//                           Text(tr(LocaleKeys.text_speed_scroll)),
//                           IconButton(
//                               onPressed: () {
//                                 setState(() {
//                                   // speedTextCo += 5;
//                                   speedTextCo += 5;
//                                   context.read<SongsBloc>().add(
//                                       UpdateSpeedScroll(
//                                           songModel.id!, speedTextCo));
//                                   speedPut(speedTextCo);
//                                   initSpeed();
//                                 });
//                               },
//                               icon: const Icon(Icons.keyboard_double_arrow_up)),
//                           Text(songModel.speedScroll.toString()),
//                           IconButton(
//                               onPressed: () {
//                                 if (songModel.speedScroll! > 0) {
//                                   setState(() {
//                                     speedTextCo -= 5;
//                                     // updateSpeedScroll(speedTextCo.value);
//                                     context.read<SongsBloc>().add(
//                                         UpdateSpeedScroll(
//                                             songModel.id!, speedTextCo));
//                                     speedPut(speedTextCo);
//                                     initSpeed();
//                                   });
//                                 }
//                               },
//                               icon:
//                                   const Icon(Icons.keyboard_double_arrow_down)),
//                         ],
//                       );
//                     } else if (songState is SongsLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (songState is SongsError) {
//                       return Center(
//                           child: Text(
//                         'Error: ${songState.message}',
//                         style: const TextStyle(color: Colors.black),
//                       ));
//                     }
//                     return const SizedBox();
//                   }),
//                   BlocBuilder<SongsBloc, SongsState>(
//                       builder: (context, songState) {
//                     if (songState is SongLoaded) {
//                       Song songModel = songState.song;

//                       return Column(
//                         children: [
//                           songModel.path_music != ''
//                               ? PlayerWidget(
//                                   name_song: songModel.name_song,
//                                   name_singer: songModel.name_singer,
//                                   audio: songModel.path_music,
//                                   asset: false)
//                               : TitleContent(song: songModel),
//                           LyricsRenderer(
//                             // horizontalAlignment: CrossAxisAlignment.stretch,
//                             lyrics: songModel.song,
//                             textStyle: TextStyle(
//                                 fontSize: sizeTextCo,
//                                 color: Theme.of(context)
//                                     .primaryTextTheme
//                                     .titleMedium!
//                                     .color),
//                             chordStyle: TextStyle(
//                                 fontSize: sizeTextCo, color: Colors.red),
//                             // widgetPadding: 50,
//                             onTapChord: (String chord) {
//                               print('pressed chord: $chord');
//                             },
//                           ),
//                           const SizedBox(
//                             height: 12,
//                           )
//                         ],
//                       );
//                     } else if (songState is SongsLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (songState is SongsError) {
//                       return Center(
//                           child: Text(
//                         'Error: ${songState.message}',
//                         style: const TextStyle(color: Colors.black),
//                       ));
//                     }
//                     return const Center(child: Text("No Data"));
//                   }),
//                 ],
//               ),
//             ),
//           )),
//     );
//   }

// }

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
              )
            : const SizedBox(),
        song.name_song != ""
            ? const SizedBox(
                height: 4,
              )
            : const SizedBox(),
        song.name_singer != ""
            ? Text(song.name_singer, style: const TextStyle(fontSize: 20))
            : const SizedBox(),
      ],
    );
  }
}

class GuitarDetal extends StatefulWidget {
  final int id;
  const GuitarDetal({required this.id, super.key});

  @override
  State<GuitarDetal> createState() => _GuitarDetalState();
}

class _GuitarDetalState extends State<GuitarDetal> {
  final ScrollController scrollController = ScrollController();
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
    setState(() {
      sizeTextCo = sizeText;
    });
    initSpeed();
    context.read<SongBloc>().add(ReadSong(widget.id));
  }

  @override
  void dispose() {
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
            // leading: IconButton(
            //   onPressed: () {
            //     context.read<SongsBloc>().add(LoadSongs());
            //     Get.back();
            //   },
            //   icon: const Icon(Icons.arrow_back),
            // ),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                BlocBuilder<SongBloc, SongState>(
                  builder: (context, songState) {
                    if (songState is SongLoaded) {
                      return _buildSongSpeedScroll(songState.song, context);
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
                BlocBuilder<SongBloc, SongState>(
                  builder: (context, songState) {
                    if (songState is SongLoaded) {
                      return _buildSongContent(songState.song, context);
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
                    return const Center(child: Text("No Data"));
                  },
                ),
              ],
            ),
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
  Widget _buildSongContent(Song song, BuildContext context) {
    speedTextCo = song.speedScroll ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (song.path_music != null && song.path_music!.isNotEmpty)
          PlayerWidget(
            name_song: song.name_song,
            name_singer: song.name_singer,
            audio: song.path_music,
            asset: false,
          )
        else
          TitleContent(song: song),
        LyricsRenderer(
          lyrics: song.song,

          // textStyle: TextStyle(fontSize: sizeTextCo),
          textStyle: TextStyle(
              fontSize: sizeText,
              color: Theme.of(context).primaryTextTheme.titleMedium!.color),
          chordStyle: TextStyle(fontSize: sizeTextCo, color: Colors.red),
          // chordStyle: const TextStyle(fontSize: 14, color: Colors.red),
          onTapChord: (String chord) => print('Pressed chord: $chord'),
        ),
        const SizedBox(height: 12),
      ],
    );
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
