import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:archive/archive_io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:yandex_mobileads/mobile_ads.dart';
import '../../components/bottomSheetEditGroup.dart';
import '../../components/customButtonSheet.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/cubit/group_id_cubit.dart';
import '../../core/cubit/index_group_cubit.dart';
import '../../core/cubit/settings_exit_cubit.dart';
import '../../core/model/groupModel.dart';
import '../../core/model/songTogroupModel.dart';
import '../../core/model/songsModel.dart';
import '../../core/storage/storage.dart';
import '../../core/styles/colors.dart';
import '../../core/utils/currentNumber.dart';
import '../../generated/locale_keys.g.dart';
import '../../main.dart';
import 'create_song.dart';
import 'editGroupPage.dart';
import 'guitarDetal.dart';
import 'search/searchPage.dart';
import 'testPage.dart';

ScrollController controllerScroll = ScrollController();

class GuitarPage extends StatefulWidget {
  const GuitarPage({super.key});

  @override
  State<GuitarPage> createState() => _GuitarPageState();
}

class _GuitarPageState extends State<GuitarPage> {
  GroupModel getNameGroup(int groupId, List<GroupModel> groups) {
    final group = groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => GroupModel(id: -1, name: ""),
    );
    return group;
  }

  List<int> selectedSongsId = [];
  List<Song> selectedSongs = [];
  bool isSecondButton = false;
  bool isReorderMode = false;
  List<Song> reorderedSongs = [];
  int? activatedSongId;
  final ScrollController reorderScrollController = ScrollController();

  @override
  void initState() {
    context.read<SongsBloc>().add(LoadSongs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        MyHomePageController controllerHome =
            Get.put<MyHomePageController>(MyHomePageController());
        if (!didPop) {
          if (controllerHome.tabIndex == 0) {
            if (context.read<IndexGroupCubit>().state == -1 &&
                !isSecondButton &&
                !isReorderMode) {
              await _exitApp(context);
            }
            if (isSecondButton || isReorderMode) {
              setState(() {
                isSecondButton = false;
                isReorderMode = false;
                selectedSongsId.clear();
                selectedSongs.clear();
              });
            } else {
              context.read<GroupCubit>().swither(GroupModel(id: -1, name: ''));
              context.read<IndexGroupCubit>().swither(-1);
            }
          }
          controllerHome.changeTabIndex(0);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: isSecondButton
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isSecondButton = false;
                      isReorderMode = false;
                      // indexAdd = 0;
                      selectedSongsId.clear();
                      selectedSongs.clear();
                    });
                  },
                  icon: const Icon(Icons.close),
                )
              : null,
          title: isReorderMode
              ? Text(tr(LocaleKeys.title_sort))
              : isSecondButton
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tr(LocaleKeys.appbar_list_songs)),
                        const SizedBox(width: 30),
                        // const Spacer(),
                        Flexible(
                          child: BlocBuilder<GroupCubit, GroupModel>(
                            builder: (context, groupState) {
                              return groupState.name == ""
                                  ? const SizedBox()
                                  : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        context
                                            .read<IndexGroupCubit>()
                                            .swither(-1);
                                        context
                                            .read<GroupCubit>()
                                            .swither(GroupModel(name: ""));
                                      },
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 200),
                                        height: 30,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: context.isDarkMode
                                              ? Colors.white
                                                  .withValues(alpha: .2)
                                              : Colors.white
                                                  .withValues(alpha: .2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                      .withValues(alpha: .5)
                                                  : Colors.white),
                                        ),
                                        child: Text(
                                          groupState.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: context.isDarkMode
                                                ? Colors.white
                                                    .withValues(alpha: .8)
                                                : Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                            },
                          ),
                        ),
                      ],
                    ),
          actions: isReorderMode
              ? []
              : isSecondButton
                  ? [
                      IconButton(
                        // minLeadingWidth: 25,
                        tooltip: tr(LocaleKeys.data_export),
                        icon: SvgPicture.asset(
                            "assets/icon/clarity_export-line.svg",
                            alignment: Alignment.center,
                            width: 25,
                            colorFilter: ColorFilter.mode(
                                Theme.of(context).appBarTheme.foregroundColor!,
                                BlendMode.srcIn)),
                        // title: Text(tr(LocaleKeys.data_export)),
                        onPressed: () async {
                          createExport(
                            context,
                            selectedSongs,
                            context.read<SongsBloc>().state is SongsLoaded
                                ? (context.read<SongsBloc>().state
                                        as SongsLoaded)
                                    .songGroups
                                : [],
                            () => setState(() {
                              isSecondButton = false;
                              selectedSongs.clear();
                              selectedSongsId.clear();
                            }),
                          );
                          AppMetrica.reportEvent('data_export');
                        },
                      ),

                      IconButton(
                        onPressed: () async {
                          TextEditingController controller =
                              TextEditingController();

                          final state = context.read<SongsBloc>().state;
                          List<GroupModel> sharedGroups = [];

                          if (state is SongsLoaded &&
                              selectedSongs.isNotEmpty) {
                            final allRelations = state.songGroups;

                            List<Set<int>> songGroupSets = [];

                            for (final song in selectedSongs) {
                              final songGroupIds = allRelations
                                  .where((sg) => sg.songId == song.id)
                                  .map((sg) => sg.groupId)
                                  .toSet();

                              songGroupSets.add(songGroupIds);
                            }

                            if (songGroupSets.isNotEmpty) {
                              Set<int> commonGroupIds =
                                  Set.from(songGroupSets.first);

                              for (int i = 1; i < songGroupSets.length; i++) {
                                commonGroupIds = commonGroupIds
                                    .intersection(songGroupSets[i]);
                              }

                              if (commonGroupIds.isNotEmpty) {
                                sharedGroups = state.groups
                                    .where((group) =>
                                        commonGroupIds.contains(group.id))
                                    .toList();
                              }
                            }
                          }

                          await showBottomSheetGroup(
                            context,
                            controller,
                            selectedSongs,
                            isSecondButton,
                            selectedSongsId,
                            sharedGroups,
                            () {
                              setState(() {
                                isSecondButton = false;
                                selectedSongsId.clear();
                                selectedSongs.clear();
                              });
                            },
                          );
                        },
                        icon: const Icon(EvaIcons.folder_add),
                      ),

                      BlocBuilder<SongsBloc, SongsState>(
                        builder: (context, state) {
                          if (state is SongsLoading) {
                            return const SizedBox();
                          } else if (state is SongsLoaded) {
                            return IconButton(
                              onPressed: () {
                                if (context.read<IndexGroupCubit>().state ==
                                    -1) {
                                  bool allSelected = state.songs.every((song) =>
                                      selectedSongsId.contains(song.id));
                                  if (allSelected) {
                                    _toggleAllSelections(state.songs, false);
                                  } else {
                                    _toggleAllSelections(state.songs, true);
                                  }
                                } else {
                                  final int groupId =
                                      // state
                                      //     .groups[
                                      context.read<IndexGroupCubit>().state;
                                  // ].id!;

                                  final songGroupLinks = state.songGroups
                                      .where((sg) => sg.groupId == groupId)
                                      .toList()
                                    ..sort((a, b) =>
                                        a.orderId!.compareTo(b.orderId!));

                                  final List<Song> filteredSongs =
                                      songGroupLinks
                                          .map((sg) => state.songs.firstWhere(
                                              (s) => s.id == sg.songId))
                                          .toList();
                                  bool allSelected = filteredSongs.every(
                                      (song) =>
                                          selectedSongsId.contains(song.id));

                                  if (allSelected) {
                                    _toggleAllSelections(filteredSongs, false);
                                  } else {
                                    _toggleAllSelections(filteredSongs, true);
                                  }
                                }
                              },
                              icon: const Icon(Icons.select_all),
                            );
                          } else if (state is SongsError) {
                            return const SizedBox();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      // исключение песни из группы
                      context.read<IndexGroupCubit>().state != -1
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    context: context,
                                    builder: (modalContext) => SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  selectedSongsId.length == 1
                                                      ? tr(LocaleKeys
                                                          .exclude_a_song_title)
                                                      : tr(LocaleKeys
                                                          .exclude_a_songs_title),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  selectedSongsId.length == 1
                                                      ? tr(LocaleKeys
                                                          .exclude_a_song_content)
                                                      : tr(LocaleKeys
                                                          .exclude_a_songs_content),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                CustomButtonSheet(
                                                  width: context.width,
                                                  height: 40,
                                                  onPressed: () {
                                                    for (Song song
                                                        in selectedSongs) {
                                                      // context
                                                      //     .read<SongsBloc>()
                                                      //     .add(UpdateSong(song
                                                      //         .copy(group: 0)));
                                                      context
                                                          .read<SongsBloc>()
                                                          .add(DeleteSongFromGroup(
                                                              song.id!,
                                                              context
                                                                  .read<
                                                                      GroupCubit>()
                                                                  .state
                                                                  .id!));
                                                      // context
                                                      //     .read<SongsBloc>()
                                                      //     .add(LoadSongToGroup());
                                                    }
                                                    setState(() {
                                                      isSecondButton = false;
                                                      // indexAdd = 0;
                                                      selectedSongsId.clear();
                                                      selectedSongs.clear();
                                                    });
                                                    Get.back();
                                                  },
                                                  title: tr(LocaleKeys
                                                      .exclude_a_songs_button),
                                                  fontSize: 14,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomButtonSheet(
                                                  width: context.width,
                                                  height: 40,
                                                  isSecond: true,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  title: tr(LocaleKeys
                                                      .confirmation_cancel),
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: Icon(
                                MingCute.exit_line,
                                color: Colors.red[400],
                              ))
                          : IconButton(
                              // удаление песни в общей
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            topRight: Radius.circular(15))),
                                    context: context,
                                    builder: (modalContext) => SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  selectedSongsId.length == 1
                                                      ? tr(LocaleKeys
                                                          .confirmation_delete_song_title)
                                                      : tr(LocaleKeys
                                                          .confirmation_delete_songs_title),
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  selectedSongsId.length == 1
                                                      ? tr(LocaleKeys
                                                          .confirmation_delete_song_content)
                                                      : tr(LocaleKeys
                                                          .confirmation_delete_songs_content),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                CustomButtonSheet(
                                                  width: context.width,
                                                  height: 40,
                                                  onPressed: () {
                                                    for (int id
                                                        in selectedSongsId) {
                                                      context
                                                          .read<SongsBloc>()
                                                          .add(DeleteSong(id));
                                                      context.read<SongsBloc>().add(
                                                          DeleteAllGroupsFromSong(
                                                              id));
                                                    }
                                                    setState(() {
                                                      isSecondButton = false;
                                                      // indexAdd = 0;
                                                      selectedSongsId.clear();
                                                      selectedSongs.clear();
                                                    });
                                                    Get.back();
                                                  },
                                                  title: tr(LocaleKeys
                                                      .confirmation_delete),
                                                  fontSize: 14,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                CustomButtonSheet(
                                                  width: context.width,
                                                  height: 40,
                                                  isSecond: true,
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  title: tr(LocaleKeys
                                                      .confirmation_cancel),
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[400],
                              ),
                            )
                    ]
                  : [
                      IconButton(
                          onPressed: () {
                            Get.to(const SearchPage());
                          },
                          icon: const Icon(Icons.search)),
                      IconButton(
                          onPressed: () {
                            Get.to(const CreateSong());
                          },
                          icon: const Icon(Icons.add)),
                    ],
        ),
        body: RefreshIndicator(
          color: colorFiolet,
          backgroundColor: context.isDarkMode
              ? backgroundColorDark.withValues(alpha: .1)
              : Colors.white,
          onRefresh: () {
            context.read<SongsBloc>().add(LoadSongs());
            return controller.refreshSongs();
          },
          child: BlocBuilder<IndexGroupCubit, int>(
            builder: (context, indexGroup) {
              return BlocBuilder<SongsBloc, SongsState>(
                builder: (context, state) {
                  if (state is SongsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SongsLoaded) {
                    final List<Song> filteredSongs;

                    if (indexGroup == -1) {
                      filteredSongs = [...state.songs]
                        ..sort((a, b) => b.id!.compareTo(a.id!));
                    } else {
                      final groupId = indexGroup;
                      // state.groups[
                      //   ].id;

                      final songGroupRelations = state.songGroups
                          .where((sg) => sg.groupId == groupId)
                          .toList()
                        ..sort((a, b) => a.orderId!.compareTo(b.orderId!));

                      filteredSongs = songGroupRelations
                          .map((sg) => state.songs.firstWhere(
                                (s) => s.id == sg.songId,
                                orElse: () => Song(
                                    id: -1,
                                    name_song: '',
                                    song: '',
                                    name_singer: '',
                                    date_created: DateTime.now()),
                              ))
                          .where((song) => song.id != -1)
                          .toList();
                    }

                    if (isReorderMode &&
                        indexGroup != -1 &&
                        reorderedSongs.isEmpty) {
                      reorderedSongs = [...filteredSongs];
                    }

                    return isReorderMode
                        ? Listener(
                            onPointerMove: (event) {
                              final y = event.position.dy;
                              const edgePadding = 100.0;
                              const scrollSpeed = 15.0;

                              final maxExtent = reorderScrollController
                                  .position.maxScrollExtent;
                              final offset = reorderScrollController.offset;

                              if (y < edgePadding) {
                                reorderScrollController.jumpTo(
                                    (offset - scrollSpeed)
                                        .clamp(0.0, maxExtent));
                              } else if (y >
                                  MediaQuery.of(context).size.height -
                                      edgePadding) {
                                reorderScrollController.jumpTo(
                                    (offset + scrollSpeed)
                                        .clamp(0.0, maxExtent));
                              }
                            },
                            onPointerDown: (_) {
                              if (isReorderMode) {
                                HapticFeedback.lightImpact();
                              }
                            },
                            child: ScrollConfiguration(
                              behavior: const ScrollBehavior(),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: colorFiolet.withValues(alpha: 0.3),
                                child: ReorderableListView(
                                  scrollController: reorderScrollController,
                                  onReorder: (oldIndex, newIndex) {
                                    setState(() {
                                      if (newIndex > oldIndex) newIndex -= 1;
                                      final item =
                                          reorderedSongs.removeAt(oldIndex);
                                      reorderedSongs.insert(newIndex, item);
                                    });

                                    final updated = <Song>[];
                                    for (int i = 0;
                                        i < reorderedSongs.length;
                                        i++) {
                                      updated.add(
                                          reorderedSongs[i].copy(order: i + 1));
                                    }
                                    context
                                        .read<SongsBloc>()
                                        .add(UpdateSongsOrder(
                                            updated,
                                            // state.groups[
                                            indexGroup
                                            // ].id!
                                            ));
                                  },
                                  children: [
                                    for (int index = 0;
                                        index < reorderedSongs.length;
                                        index++)
                                      ListTile(
                                        minTileHeight: 60,
                                        minVerticalPadding: 10,
                                        key: ValueKey(reorderedSongs[index].id),
                                        tileColor: context.isDarkMode
                                            ? backgroundColorDark
                                            : Colors.white
                                                .withValues(alpha: .1),
                                        horizontalTitleGap: 13.5,
                                        leading: Text(
                                          "${index + 1}.",
                                          style: TextStyle(
                                              fontSize: (index + 1) > 9 &&
                                                      (index + 1) <= 99
                                                  ? 14
                                                  : (index + 1) > 99
                                                      ? 13
                                                      : 16,
                                              color: context.isDarkMode
                                                  ? Colors.white
                                                      .withValues(alpha: .5)
                                                  : Colors.black
                                                      .withValues(alpha: .5)),
                                        ),
                                        minLeadingWidth: 1,
                                        title: Text(
                                            reorderedSongs[index].name_song),
                                        subtitle: Text(
                                          reorderedSongs[index].name_singer,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: context.isDarkMode
                                                ? Colors.grey[300]
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        trailing: ReorderableDragStartListener(
                                          index: index,
                                          child: const Icon(Icons.drag_handle),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : ScrollConfiguration(
                            behavior: const ScrollBehavior(),
                            child: GlowingOverscrollIndicator(
                              axisDirection: AxisDirection.down,
                              color: colorFiolet.withValues(alpha: 0.3),
                              child: ListView(
                                padding: const EdgeInsets.only(bottom: 5),
                                controller: controllerScroll,
                                children: [
                                  //     : const CardNews(),
                                  _buildHorizontalGroupSelector(state.groups),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  !isSecondButton
                                      ? _buildTestDeleteWidget(context)
                                      : const SizedBox(),
                                  ...filteredSongs.map((song) => ListTile(
                                        key: ValueKey(song.id),
                                        minTileHeight: 60,
                                        isThreeLine: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                    vertical: 4)
                                                .copyWith(left: 15, right: 8),
                                        titleAlignment:
                                            ListTileTitleAlignment.titleHeight,
                                        minLeadingWidth:
                                            !isSecondButton ? null : 0,
                                        leading: isSecondButton
                                            ? _buildSelectionIndicator(song.id!)
                                            : null,
                                        onTap: isSecondButton
                                            ? () => _toggleSongSelection(
                                                song.id!, song)
                                            : () {
                                                Get.to(GuitarDetal(
                                                  id: song.id!,
                                                  speedTextSong:
                                                      song.speedScroll!,
                                                ));
                                              },
                                        onLongPress: () {
                                          setState(() {
                                            isSecondButton = true;
                                          });
                                          _toggleSongSelection(song.id!, song);
                                        },
                                        title: Text(song.name_song,
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        subtitle: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song.name_singer,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: context.isDarkMode
                                                    ? Colors.grey[300]
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                            indexGroup != -1
                                                ? const SizedBox()
                                                : BlocBuilder<SongsBloc,
                                                    SongsState>(
                                                    builder: (context, state) {
                                                      if (state
                                                          is! SongsLoaded) {
                                                        return const SizedBox();
                                                      }

                                                      final songGroups = state
                                                          .songGroups
                                                          .where((sg) =>
                                                              sg.songId ==
                                                              song.id)
                                                          .toList();

                                                      if (songGroups.isEmpty) {
                                                        return const SizedBox();
                                                      }

                                                      return Wrap(
                                                        children: songGroups
                                                            .map((sg) {
                                                          final group = state
                                                              .groups
                                                              .firstWhere(
                                                            (g) =>
                                                                g.id ==
                                                                sg.groupId,
                                                            orElse: () =>
                                                                GroupModel(
                                                                    id: -1,
                                                                    name: ''),
                                                          );

                                                          final backgroundColor =
                                                              colorFiolet
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3);

                                                          final borderColor =
                                                              colorFiolet;

                                                          final textColor =
                                                              borderColor;

                                                          return Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 6,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  backgroundColor,
                                                              border: Border.all(
                                                                  color:
                                                                      borderColor),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Text(
                                                              group.name,
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    textColor,
                                                              ),
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                  } else if (state is SongsError) {
                    return Text(state.message);
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          ),
        ),
        floatingActionButton: context.read<IndexGroupCubit>().state != -1 &&
                isSecondButton
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !isReorderMode
                          ? BlocBuilder<SongsBloc, SongsState>(
                              builder: (context, state) {
                              if (state is SongsLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state is SongsLoaded) {
                                return FloatingActionButton.extended(
                                  backgroundColor: colorFiolet,
                                  onPressed: () {
                                    List<Song> filteredSongs = state.songs
                                        .where((song) =>
                                                song.group ==
                                                context
                                                    .read<IndexGroupCubit>()
                                                    .state
                                            // state
                                            //     .groups[
                                            //         ]
                                            //     .id
                                            )
                                        .toList()
                                      ..sort((a, b) =>
                                          a.order!.compareTo(b.order!));

                                    List<Song> sortedSongs = [
                                      ...selectedSongs,
                                      ...filteredSongs.where((song) =>
                                          !selectedSongs.contains(song)),
                                    ];

                                    for (int i = 0;
                                        i < sortedSongs.length;
                                        i++) {
                                      context.read<SongsBloc>().add(UpdateSong(
                                          sortedSongs[i].copy(order: i + 1)));
                                    }

                                    setState(() {
                                      isSecondButton = false;
                                      selectedSongsId.clear();
                                      selectedSongs.clear();
                                    });
                                  },
                                  label: Text(tr(LocaleKeys.change_the_order)),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })
                          : const SizedBox(),
                      SizedBox(width: !isReorderMode ? 10 : 0),
                      FloatingActionButton(
                        heroTag: "drag_mode_toggle",
                        onPressed: () {
                          setState(() {
                            isReorderMode = !isReorderMode;
                            reorderedSongs.clear();
                          });
                        },
                        backgroundColor:
                            isReorderMode ? colorFiolet : Colors.grey,
                        child: const Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                ),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  Future<void> _exitApp(BuildContext context) async {
    if (!context.read<SettingsExitCubit>().state) {
      SystemNavigator.pop();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(tr(LocaleKeys.exit_title_dialog)),
          content: Text(tr(LocaleKeys.exit_content_dialog)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(tr(LocaleKeys.exit_dialog_cancel)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                SystemNavigator.pop();
              },
              child: Text(tr(LocaleKeys.exit_dialog_exit)),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSelectionIndicator(int songId) {
    final isSelected = selectedSongsId.contains(songId);
    final songIndex = isSelected ? selectedSongsId.indexOf(songId) + 1 : null;

    return Container(
      alignment: Alignment.center,
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? colorFiolet : Colors.grey,
          width: 2,
        ),
        color: isSelected ? colorFiolet : Colors.transparent,
      ),
      child: isSelected
          ? Text(
              songIndex.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: songIndex! > 9 && songIndex <= 99
                    ? 13
                    : songIndex > 99
                        ? 11
                        : 14,
              ),
            )
          : null,
    );
  }

  void _toggleSongSelection(int songId, Song song) {
    setState(() {
      if (selectedSongsId.contains(songId)) {
        selectedSongsId.remove(songId);
        selectedSongs.remove(song);
        if (selectedSongsId.isEmpty) {
          isSecondButton = false;
        }
      } else {
        selectedSongsId.add(songId);
        selectedSongs.add(song);
      }
      // indexAdd = selectedSongsId.length;
    });
  }

  void _toggleAllSelections(List<Song> songs, bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedSongsId.addAll(
          songs
              .map((song) => song.id!)
              .where((id) => !selectedSongsId.contains(id)),
        );
        selectedSongs.addAll(
          songs.where((song) => !selectedSongs.any((s) => s.id == song.id)),
        );

        isSecondButton = true;
      } else {
        selectedSongsId.clear();
        selectedSongs.clear();

        isSecondButton = false;
      }
    });
  }

  Widget _buildHorizontalGroupSelector(List<GroupModel> groups) {
    return isSecondButton
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.only(top: 15, bottom: 8),
            alignment: Alignment.centerLeft,
            height: 30,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(const EditGroupPage());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 15),
                    width: 50,
                    decoration: BoxDecoration(
                      color: colorFiolet,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colorFiolet),
                    ),
                    child: const Icon(
                      EvaIcons.folder_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
                BlocBuilder<IndexGroupCubit, int>(
                  builder: (context, indexGroup) {
                    // Сортируем группы по orderId
                    List<GroupModel> sortedGroups = List.from(groups)
                      ..sort(
                          (a, b) => (a.orderId ?? 0).compareTo(b.orderId ?? 0));

                    return Row(
                      children: sortedGroups
                          .asMap()
                          .map((i, group) => MapEntry(
                                i,
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (indexGroup != group.id) {
                                      context
                                          .read<IndexGroupCubit>()
                                          .swither(group.id!);
                                      context.read<GroupCubit>().swither(group);
                                    } else {
                                      context
                                          .read<IndexGroupCubit>()
                                          .swither(-1);
                                      context
                                          .read<GroupCubit>()
                                          .swither(GroupModel(name: ""));
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                      left: i == 0 ? 10 : 10,
                                      right:
                                          i == sortedGroups.length - 1 ? 15 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: indexGroup == group.id
                                          ? colorFiolet.withValues(alpha: .3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorFiolet),
                                    ),
                                    child: Text(
                                      group.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: indexGroup == group.id
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: indexGroup == group.id
                                            ? colorFiolet
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .values
                          .toList(),
                    );
                  },
                )
              ],
            ));
  }

  Widget _buildTestDeleteWidget(BuildContext context) {
    return !isDeleteTest
        ? ListTile(
            onLongPress: () async => await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                        title: Text(tr(LocaleKeys.confirmation_title)),
                        content: Text(tr(
                            LocaleKeys.edit_song_confirmation_content_delete)),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(tr(LocaleKeys.confirmation_no))),
                          TextButton(
                              onPressed: () async {
                                // setState(() {
                                isDeleteTest = true;
                                isDeleteTestPut(isDeleteTest);
                                // });
                                Get.back();
                                Get.back();
                                Get.back();
                              },
                              child: Text(tr(LocaleKeys.confirmation_yes)))
                        ])),
            title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text(tr(LocaleKeys.ex_name_song),
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(
                        width: 5,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: colorFiolet,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          child: Text(tr(LocaleKeys.example),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        ),
                      )
                    ],
                  ),
                  Text(
                    tr(LocaleKeys.ex_name_singer),
                    style: TextStyle(
                        fontSize: 14,
                        color: context.isDarkMode
                            ? Colors.grey[300]
                            : Colors.grey[600]),
                  ),
                ]),
            onTap: () => Get.to(const TestPage()))
        : const SizedBox();
  }
}

Future<void> createExport(
  BuildContext context,
  List<Song> selectedSongs,
  List<SongToGroupModel> allRelations,
  VoidCallback resetState,
) async {
  await Permission.manageExternalStorage.request();
  await Permission.audio.request();
  if (await Permission.manageExternalStorage.request().isGranted ||
      await Permission.storage.request().isGranted) {
    try {
      final tempDir = await getTemporaryDirectory();
      final backupDir = Directory(join(tempDir.path, 'export'));
      if (!backupDir.existsSync()) backupDir.createSync();

      final songsJson = selectedSongs.map((song) => song.toJson()).toList();
      final songsFilePath = join(backupDir.path, 'selected_songs.json');
      final songsFile = File(songsFilePath);
      songsFile.writeAsStringSync(jsonEncode(songsJson));

      final songGroupRelations = allRelations
          .where((rel) => selectedSongs.any((s) => s.id == rel.songId))
          .map((rel) => rel.toJson())
          .toList();
      final songGroupsFilePath = join(backupDir.path, 'song_to_groups.json');
      final songGroupsFile = File(songGroupsFilePath);
      songGroupsFile.writeAsStringSync(jsonEncode(songGroupRelations));

      for (final song in selectedSongs) {
        if (song.path_music != null && song.path_music!.isNotEmpty) {
          final musicFile = File(song.path_music!);
          if (musicFile.existsSync()) {
            final musicBackupPath =
                join(backupDir.path, basename(song.path_music!));
            await musicFile.copy(musicBackupPath);
          } else {
            print("Файл аудио не найден: ${song.path_music}");
          }
        } else {
          print("У песни отсутствует путь к аудио: ${song.song}");
        }
      }

      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        throw Exception("Папка загрузок недоступна");
      }

      String zipFilePath = join(downloadsDir.path, 'songs_export.zip');
      int counter = 1;
      while (File(zipFilePath).existsSync()) {
        zipFilePath = join(downloadsDir.path, 'songs_export_$counter.zip');
        counter++;
      }

      final encoder = ZipFileEncoder();
      encoder.create(zipFilePath);
      encoder.addDirectory(backupDir);
      encoder.close();

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(tr(LocaleKeys.confirmation_title)),
          content: Text(tr(LocaleKeys.confirmation_content_export_song)),
          actions: [
            TextButton(
              onPressed: () {
                resetState();
                Navigator.pop(context);
              },
              child: Text(tr(LocaleKeys.confirmation_no)),
            ),
            TextButton(
              onPressed: () async {
                resetState();
                Navigator.pop(context);
                await Share.shareXFiles([XFile(zipFilePath)]);
              },
              child: Text(tr(LocaleKeys.confirmation_yes)),
            ),
          ],
        ),
      );

      print('Export создан: $zipFilePath');
    } catch (e, stacktrace) {
      print('Ошибка экспорта: $e');
      print('Stacktrace: $stacktrace');
    }
  } else {
    print('Разрешения отклонены');
  }
}
