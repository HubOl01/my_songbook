import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_songbook/components/customButtonSheet.dart';
import '../core/bloc/songs_bloc.dart';
import '../core/model/groupModel.dart';
import '../core/model/songsModel.dart';
import '../core/styles/colors.dart';
import '../generated/locale_keys.g.dart';
import 'buildCreateGroupField.dart';

Future<List<GroupModel>?> showBottomSheetGroup(
    BuildContext context,
    TextEditingController controller,
    List<Song>? selectedSongs,
    bool? isSecondButton,
    List<int>? selectedSongsId,
    List<GroupModel>? selectedGroup,
    VoidCallback? resetSelectionCallback,
    {bool isEdit = false}) async {
  final selectedGroupIds = selectedGroup ?? <GroupModel>[];
  final removedGroupIds = <GroupModel>[];
  return await showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    ),
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setModalState) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return ListView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${tr(LocaleKeys.confirmation_group_title_select)}:",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CustomButtonSheet(
                        title: tr(LocaleKeys.add_song_save),
                        height: 30,
                        onPressed: () {
                          if (isEdit) {
                            Get.back(result: selectedGroupIds.toList());
                          } else {
                            final bloc = context.read<SongsBloc>();

                            for (final song in selectedSongs!) {
                              for (final groupId in removedGroupIds) {
                                bloc.add(
                                    DeleteSongFromGroup(song.id!, groupId.id!));
                              }

                              for (final groupId in selectedGroupIds) {
                                final groupLinks = bloc.state is SongsLoaded
                                    ? (bloc.state as SongsLoaded)
                                        .songGroups
                                        .where((sg) => sg.groupId == groupId)
                                        .toList()
                                    : [];

                                final maxOrder = groupLinks.isEmpty
                                    ? 0
                                    : groupLinks
                                        .map((sg) => sg.orderId ?? 0)
                                        .reduce((a, b) => a > b ? a : b);

                                bloc.add(AddSongToGroup(
                                    song.id!, groupId.id!, maxOrder + 1));
                              }
                            }

                            resetSelectionCallback?.call();
                            Get.back();
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                buildCreateGroupField(
                    context,
                    controller,
                    selectedSongs!,
                    isSecondButton!,
                    selectedSongsId!,
                    ((val) => setModalState(() {})),
                    () => setModalState(() {
                          controller.clear();
                        }),
                    resetSelectionCallback!,
                    selectedGroupIds,
                    isEdit: isEdit),
                BlocBuilder<SongsBloc, SongsState>(
                  builder: (context, state) {
                    if (state is SongsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SongsLoaded) {
                      final List<GroupModel> sortedGroups =
                          List.from(state.groups)
                            ..sort((a, b) =>
                                (a.orderId ?? 0).compareTo(b.orderId ?? 0));
                      List<GroupModel> filteredGroups =
                          sortedGroups.where((group) {
                        final query = controller.text.toLowerCase().trim();
                        return group.name.toLowerCase().contains(query);
                      }).toList();
                      final initialSelectedGroups = <int>{};

                      if (selectedGroup != null && selectedGroup.isNotEmpty) {
                        initialSelectedGroups
                            .addAll(selectedGroup.map((g) => g.id!));
                      }
                      return Column(
                        children: filteredGroups.map((group) {
                          final isSelected = selectedGroupIds.contains(group) ||
                              (initialSelectedGroups.contains(group.id) &&
                                  !removedGroupIds.contains(group));

                          return ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            minTileHeight: 45,
                            contentPadding: const EdgeInsets.only(
                                left: 20, right: 20, top: 0, bottom: 0),
                            selected: isSelected,
                            selectedColor: colorFiolet,
                            selectedTileColor:
                                colorFiolet.withValues(alpha: .15),
                            textColor: isSelected ? colorFiolet : null,
                            tileColor: isSelected ? colorFiolet : null,
                            trailing: isSelected
                                ? Icon(Icons.check, color: colorFiolet)
                                : const SizedBox(),
                            onTap: () {
                              setModalState(() {
                                if (isSelected) {
                                  selectedGroupIds.remove(group);
                                  removedGroupIds.add(group);
                                } else {
                                  selectedGroupIds.add(group);
                                  removedGroupIds.remove(group);
                                }
                              });
                            },
                            title: Text(
                              group.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      );
                    } else if (state is SongsError) {
                      return Center(
                          child: Text(tr(LocaleKeys.error_loading_group)));
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
