import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
// import 'package:yandex_mobileads/mobile_ads.dart';
import '../../components/customButtonSheet.dart';
import '../../components/customTextField.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/cubit/group_id_cubit.dart';
import '../../core/cubit/index_group_cubit.dart';
import '../../core/cubit/songs1_cubit.dart';
import '../../core/model/groupModel.dart';
import '../../core/model/songsModel.dart';
import '../../core/storage/storage.dart';
import '../../core/styles/colors.dart';
import '../../core/utils/currentNumber.dart';
import '../../generated/locale_keys.g.dart';
import 'Card_for_news/cardNews.dart';
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
  String getNameGroup(int groupId, List<GroupModel> groups) {
    final group = groups.firstWhere(
      (g) => g.id == groupId,
      orElse: () => GroupModel(id: -1, name: ""),
    );
    return group.name;
  }

  List<int> selectedSongsId = [];
  List<Song> selectedSongs = [];
  bool isSecondButton = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: isSecondButton
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isSecondButton = false;
                    // indexAdd = 0;
                    selectedSongsId.clear();
                    selectedSongs.clear();
                  });
                },
                icon: const Icon(Icons.close),
              )
            : null,
        title: isSecondButton
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
                                  // if (indexGroup != i) {
                                  //   context.read<IndexGroupCubit>().swither(i);
                                  //   context.read<GroupCubit>().swither(GroupModel(group.id!);
                                  // }
                                  // else {
                                  context.read<IndexGroupCubit>().swither(-1);
                                  context
                                      .read<GroupCubit>()
                                      .swither(GroupModel(name: ""));
                                  // }
                                },
                                child: Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? colorFiolet.withOpacity(.3)
                                        : Colors.white.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: context.isDarkMode
                                            ? colorFiolet
                                            : Colors.white),
                                  ),
                                  child: Text(
                                    groupState.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: context.isDarkMode
                                          ? colorFiolet
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
        actions: isSecondButton
            ? [
                IconButton(
                  onPressed: () {
                    TextEditingController controller = TextEditingController();
                    Widget buildCreateGroupField(BuildContext context) {
                      return StatefulBuilder(builder: (context, setState1) {
                        return BlocBuilder<SongsBloc, SongsState>(
                          builder: (context, state) {
                            if (state is SongsLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is SongsLoaded) {
                              final groups = state.groups;

                              // Если групп 5 или больше, не показывать поле создания
                              if (groups.length >= 5) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    tr(LocaleKeys.info_max_group),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: context.isDarkMode
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }

                              return Container(
                                height: 140,
                                alignment: Alignment.bottomCenter,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    // Поле ввода
                                    CustomTextField(
                                      controller: controller,
                                      title: tr(LocaleKeys.title_new_group),
                                      onChanged: (value) => setState1(() {}),
                                    ),
                                    // Счетчик символов
                                    Text(
                                      "${controller.text.length}/20",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.isDarkMode
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    // Кнопки подтверждения
                                    if (controller.text.isNotEmpty)
                                      SizedBox(
                                        height: 30,
                                        width: 200,
                                        child: Row(
                                          children: [
                                            // Кнопка "Создать" или "Обновить"
                                            Expanded(
                                              child: CustomButtonSheet(
                                                title: tr(LocaleKeys
                                                    .confirmation_create),
                                                onPressed: () async {
                                                  // Добавление группы
                                                  context.read<SongsBloc>().add(
                                                      AddGroup(GroupModel(
                                                          name: controller
                                                              .text)));
                                                  // context.read<SongsBloc>().add(LoadSongs());
                                                  // Дождитесь обновления состояния
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 300));

                                                  // Получение группы и обновление песен
                                                  final state = context
                                                      .read<SongsBloc>()
                                                      .state;
                                                  if (state is SongsLoaded &&
                                                      state.groups.isNotEmpty) {
                                                    final lastGroupId =
                                                        state.groups.first.id;
                                                    for (int i = 0;
                                                        i <
                                                            selectedSongs
                                                                .length;
                                                        i++) {
                                                      context
                                                          .read<SongsBloc>()
                                                          .add(
                                                            UpdateSong(
                                                                selectedSongs[i]
                                                                    .copy(
                                                              order: i + 1,
                                                              group:
                                                                  lastGroupId,
                                                            )),
                                                          );
                                                    }
                                                  }
                                                  setState1(() {
                                                    isSecondButton = false;
                                                    // indexAdd = 0;
                                                    selectedSongsId.clear();
                                                    selectedSongs.clear();
                                                  });
                                                  Get.back();
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            // Кнопка "Отмена"
                                            Expanded(
                                              child: CustomButtonSheet(
                                                isSecond: true,
                                                onPressed: () {
                                                  setState1(() {
                                                    controller.clear();
                                                  });
                                                },
                                                title: tr(LocaleKeys
                                                    .confirmation_cancel),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            } else if (state is SongsError) {
                              return Center(
                                child: Text(
                                  "Error: ${state.message}",
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        );
                      });
                    }

                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      context: context,
                      builder: (context) => DraggableScrollableSheet(
                        initialChildSize: 0.8,
                        expand: false,
                        builder: (context, scrollController) {
                          return ListView(
                            physics: const BouncingScrollPhysics(),
                            controller: scrollController,
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    "${tr(LocaleKeys.confirmation_group_title_select)}:",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // CustomTextField(
                              //   onChanged: (value) => setState(() {
                              //     controller.text = value;
                              //   }),
                              //   controller: controller,
                              //   title: tr(LocaleKeys.title_new_group),
                              // ),
                              buildCreateGroupField(context),

                              BlocBuilder<SongsBloc, SongsState>(
                                builder: (context, state) {
                                  if (state is SongsLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (state is SongsLoaded) {
                                    return Column(
                                      children: state.groups
                                          .asMap()
                                          .map((index, title) => MapEntry(
                                              index,
                                              ListTile(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                minVerticalPadding: 10,
                                                onTap: () {
                                                  final groupId =
                                                      state.groups[index].id;
                                                  for (int i = 0;
                                                      i < selectedSongs.length;
                                                      i++) {
                                                    context
                                                        .read<SongsBloc>()
                                                        .add(
                                                          UpdateSong(
                                                              selectedSongs[i]
                                                                  .copy(
                                                            order: i + 1,
                                                            group: groupId,
                                                          )),
                                                        );
                                                  }
                                                  setState(() {
                                                    isSecondButton = false;
                                                    // indexAdd = 0;
                                                    selectedSongsId.clear();
                                                    selectedSongs.clear();
                                                  });
                                                  Get.back();
                                                },
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 5),
                                                title: Text(
                                                  state.groups[index].name,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ),
                                              )))
                                          .values
                                          .toList(),
                                    );
                                  } else if (state is SongsError) {
                                    return Center(
                                        child: Text(tr(
                                            LocaleKeys.error_loading_group)));
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(EvaIcons.folder_add),
                ),
                BlocBuilder<Songs1Cubit, Songs1State>(
                  builder: (context, state) {
                    if (state is Songs1Loading) {
                      return const SizedBox();
                    } else if (state is Songs1Loaded) {
                      bool allSelected = state.songs
                          .every((song) => selectedSongsId.contains(song.id));
                      return IconButton(
                        onPressed: () {
                          if (allSelected) {
                            _toggleAllSelections(state.songs, false);
                          } else {
                            _toggleAllSelections(state.songs, true);
                          }
                        },
                        icon: const Icon(Icons.select_all),
                      );
                    } else if (state is Songs1Error) {
                      return const SizedBox();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15))),
                        context: context,
                        builder: (modalContext) => Padding(
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
                                        fontWeight: FontWeight.bold),
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
                                      for (int id in selectedSongsId) {
                                        context
                                            .read<SongsBloc>()
                                            .add(DeleteSong(id));
                                      }
                                      setState(() {
                                        isSecondButton = false;
                                        // indexAdd = 0;
                                        selectedSongsId.clear();
                                        selectedSongs.clear();
                                      });
                                      Get.back();
                                    },
                                    title: tr(LocaleKeys.confirmation_delete),
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
                                    title: tr(LocaleKeys.confirmation_cancel),
                                    fontSize: 14,
                                  ),
                                ],
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
                      Get.to(const Create_song());
                    },
                    icon: const Icon(Icons.add)),
              ],
      ),
      body: RefreshIndicator(
        color: colorFiolet,
        backgroundColor: context.isDarkMode
            ? backgroundColorDark.withOpacity(.1)
            : Colors.white,
        onRefresh: () {
          return controller.refreshSongs();
        },
        child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: colorFiolet.withOpacity(0.3),
                child: ListView(controller: controllerScroll, children: [
                  _buildHeader(context, 0),
                  // _buildHeader(context, 1),

                  BlocBuilder<IndexGroupCubit, int>(
                    builder: (context, indexGroup) {
                      return BlocBuilder<SongsBloc, SongsState>(
                        builder: (context, state) {
                          if (state is SongsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is SongsLoaded) {
                            // List<Song> filteredSongs = indexGroup == -1
                            //     ? state.songs
                            //     : state.songs
                            //         .where((song) =>
                            //             song.group ==
                            //             state.groups[indexGroup].id)
                            //         .toList()
                            //   ..sort((a, b) => a.order!.compareTo(b.order!));
                            List<Song> filteredSongs = indexGroup == -1
                                ? (state.songs
                                  ..sort((a, b) => b.id!.compareTo(
                                      a.id!))) // Сортировка по id desc
                                : (state.songs
                                    .where((song) =>
                                        song.group ==
                                        state.groups[indexGroup].id)
                                    .toList()
                                  ..sort((a, b) => a.order!.compareTo(
                                      b.order!))); // Сортировка по order asc

                            return Column(
                              children: [
                                _buildHorizontalGroupSelector(state.groups),
                                _buildHeader(context, 2),
                                filteredSongs.isEmpty &&
                                        context.read<IndexGroupCubit>().state !=
                                            -1
                                    ? SizedBox(
                                        height: 100,
                                        child: Center(
                                          child: Text(tr(
                                              LocaleKeys.no_data_select_songs)),
                                        ),
                                      )
                                    : Column(
                                        children: filteredSongs
                                            .map((song) => ListTile(
                                                  key: ValueKey(song.id),
                                                  minLeadingWidth:
                                                      !isSecondButton
                                                          ? null
                                                          : 0,
                                                  leading: isSecondButton
                                                      ? _buildSelectionIndicator(
                                                          song.id!)
                                                      : null,
                                                  onLongPress: () {
                                                    setState(() {
                                                      isSecondButton = true;
                                                    });
                                                    _toggleSongSelection(
                                                        song.id!, song);
                                                  },
                                                  title: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: [
                                                      Text(song.name_song,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      16)),
                                                      Text(
                                                        song.name_singer ?? "",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: context
                                                                  .isDarkMode
                                                              ? Colors.grey[300]
                                                              : Colors
                                                                  .grey[600],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  subtitle:
                                                      song.group == null ||
                                                              song.group == 0
                                                          ? null
                                                          : BlocBuilder<
                                                              SongsBloc,
                                                              SongsState>(
                                                              // Если уже есть группа и по возможности можно поменять
                                                              builder: (context,
                                                                  state) {
                                                                List<GroupModel>
                                                                    groups = [];

                                                                if (state
                                                                    is SongsLoaded) {
                                                                  groups = state
                                                                      .groups;
                                                                }
                                                                return Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          20,
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: colorFiolet
                                                                            .withOpacity(.3),
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border: Border.all(
                                                                            color:
                                                                                colorFiolet),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        getNameGroup(
                                                                          song.group!,
                                                                          groups,
                                                                        ),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              10,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              colorFiolet,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                  onTap: isSecondButton
                                                      ? () =>
                                                          _toggleSongSelection(
                                                              song.id!, song)
                                                      : () {
                                                          Get.to(GuitarDetal(
                                                            id: song.id,
                                                          ));
                                                        },
                                                ))
                                            .toList(),
                                      ),
                              ],
                            );
                          } else if (state is SongsError) {
                            return const SizedBox();
                          } else {
                            return _buildHeader(context, 2);
                          }
                        },
                      );
                    },
                  )
                ]))),
      ),
    );
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
                  fontSize: songIndex! >= 99 ? 12 : 14),
            )
          : null,
    );
  }

  void _toggleSongSelection(int songId, Song song) {
    setState(() {
      if (selectedSongsId.contains(songId)) {
        selectedSongsId.remove(songId);
        selectedSongs.remove(songId);
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

  Widget _buildHeader(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const CardNews();
      // case 1:
      //   return !isSecondButton ? _buildHorizontalGroupSelector() : SizedBox();
      case 2:
        return !isSecondButton
            ? _buildTestDeleteWidget(context)
            : const SizedBox();
      default:
        return const SizedBox();
    }
  }

  void _toggleAllSelections(List<Song> songs, bool selectAll) {
    setState(() {
      if (selectAll) {
        selectedSongsId.addAll(songs
            .map((song) => song.id!)
            .where((id) => !selectedSongsId.contains(id)));
        isSecondButton = true;
      } else {
        // selectedSongsId.clear();
        // isSecondButton = false;
        isSecondButton = false;
        selectedSongsId.clear();
        selectedSongs.clear();
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
                    // padding: EdgeInsets.symmetric(horizontal: 15),
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
                    return Row(
                      children: groups
                          .asMap()
                          .map((i, group) => MapEntry(
                                i,
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (indexGroup != i) {
                                      context
                                          .read<IndexGroupCubit>()
                                          .swither(i);
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
                                      right: i == groups.length - 1 ? 15 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: indexGroup == i
                                          ? colorFiolet.withOpacity(.3)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: colorFiolet),
                                    ),
                                    child: Text(
                                      group.name,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: indexGroup == i
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: indexGroup == i
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

// final GuitarController controller = Get.put(GuitarController());
