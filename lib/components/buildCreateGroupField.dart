import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_songbook/components/customTextField.dart';

import '../core/bloc/songs_bloc.dart';
import '../core/model/groupModel.dart';
import '../core/model/songsModel.dart';
import '../generated/locale_keys.g.dart';
import 'customButtonSheet.dart';

Widget buildCreateGroupField(
    BuildContext context,
    TextEditingController controller,
    List<Song> selectedSongs,
    bool isSecondButton,
    List<int> selectedSongsId,
    Function(String value) onChangeTextEditing,
    VoidCallback clearController,
    VoidCallback resetSelectionCallback,
    List<GroupModel> selectedGroupIds,
    {bool isEdit = false}) {
  return StatefulBuilder(builder: (context, setState1) {
    return BlocBuilder<SongsBloc, SongsState>(
      builder: (context, state) {
        if (state is SongsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SongsLoaded) {
          final groups = state.groups;

          if (groups.length >= 5) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                tr(LocaleKeys.info_max_group),
                style: TextStyle(
                  fontSize: 14,
                  color: context.isDarkMode ? Colors.white70 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
          return Container(
            height: 140,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                CustomTextField(
                  isUpperLetter: true,
                  controller: controller,
                  title: tr(LocaleKeys.title_new_group),
                  onChanged: onChangeTextEditing,
                ),
                Text(
                  "${controller.text.length}/20",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.isDarkMode
                        ? Colors.white.withValues(alpha: 0.7)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                if (controller.text.isNotEmpty)
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButtonSheet(
                            title: tr(LocaleKeys.confirmation_create),
                            onPressed: () async {
                              final groupName = controller.text.trim();

                              if (groups.any((group) =>
                                  group.name.toLowerCase() ==
                                  groupName.toLowerCase())) {
                                Get.snackbar(
                                  tr(LocaleKeys.error_duplicate_group_title),
                                  tr(LocaleKeys.error_duplicate_group_message),
                                  backgroundColor:
                                      Colors.red.withValues(alpha: 0.8),
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              context.read<SongsBloc>().add(
                                    AddGroup(GroupModel(name: groupName)),
                                  );
                              AppMetrica.reportEvent(
                                  'Added group name: $groupName');
                              controller.clear();

                              // await Future.delayed(
                              //     const Duration(milliseconds: 300));

                              // final updatedState =
                              //     context.read<SongsBloc>().state;
                              // if (updatedState is SongsLoaded &&
                              //     updatedState.groups.isNotEmpty) {
                              //   final createdGroup = updatedState.groups
                              //       .firstWhere(
                              //           (g) =>
                              //               g.name.toLowerCase() ==
                              //               groupName.toLowerCase(),
                              //           orElse: () => GroupModel(name: ''));

                              //   if (!selectedGroupIds
                              //       .any((g) => g.id == createdGroup.id)) {
                              //     setState1(() {
                              //       selectedGroupIds.add(createdGroup);
                              //     });
                              //   }
                              // }
                              final bloc = context.read<SongsBloc>();
                              context
                                  .read<SongsBloc>()
                                  .add(AddGroup(GroupModel(name: groupName)));
                              controller.clear();

                              await for (final state in bloc.stream) {
                                if (state is SongsLoaded) {
                                  final createdGroup = state.groups.firstWhere(
                                    (g) =>
                                        g.name.toLowerCase() ==
                                        groupName.toLowerCase(),
                                    orElse: () => GroupModel(name: ''),
                                  );

                                  if (!selectedGroupIds
                                      .any((g) => g.id == createdGroup.id)) {
                                    setState1(() {
                                      selectedGroupIds.add(createdGroup);
                                    });
                                  }
                                  break;
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomButtonSheet(
                            isSecond: true,
                            onPressed: () {
                              setState1(() {
                                controller.clear();
                                clearController();
                              });
                            },
                            title: tr(LocaleKeys.confirmation_cancel),
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

// Widget buildCreateGroupField(
//     BuildContext context,
//     TextEditingController controller,
//     List<Song> selectedSongs,
//     bool isSecondButton,
//     List<int> selectedSongsId,
//     VoidCallback resetSelectionCallback) {
//   return StatefulBuilder(builder: (context, setState1) {
//     return BlocBuilder<SongsBloc, SongsState>(
//       builder: (context, state) {
//         if (state is SongsLoading) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (state is SongsLoaded) {
//           final groups = state.groups;

//           return Container(
//             height: 140,
//             alignment: Alignment.bottomCenter,
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: Column(
//               children: [
//                 // Поле ввода
//                 CustomTextField(
//                   controller: controller,
//                   title: tr(LocaleKeys.title_new_group),
//                   onChanged: (value) => setState1(() {}),
//                 ),
//                 // Счетчик символов
//                 Text(
//                   "${controller.text.length}/20",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: context.isDarkMode
//                         ? Colors.white.withValues(alpha: 0.7)
//                         : Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 // Кнопки подтверждения
//                 if (controller.text.isNotEmpty)
//                   SizedBox(
//                     height: 30,
//                     width: 200,
//                     child: Row(
//                       children: [
//                         // Кнопка "Создать" или "Обновить"
//                         Expanded(
//                           child: CustomButtonSheet(
//                             title: tr(LocaleKeys.confirmation_create),
//                             onPressed: () async {
//                               // Добавление группы
//                               if (groups.any((group) =>
//                                   group.name.toLowerCase() ==
//                                   controller.text.toLowerCase())) {
//                                 Get.snackbar(
//                                   tr(LocaleKeys.error_duplicate_group_title),
//                                   tr(LocaleKeys.error_duplicate_group_message),
//                                   backgroundColor:
//                                       Colors.red.withValues(alpha: 0.8),
//                                   colorText: Colors.white,
//                                 );
//                                 return;
//                               }

//                               // Добавление группы
//                               context.read<SongsBloc>().add(
//                                     AddGroup(GroupModel(name: controller.text)),
//                                   );
//                               AppMetrica.reportEvent(
//                                   'Added group name: ${controller.text}');
//                               // setState(() {
//                               // groupModel =
//                               //     GroupModel(
//                               //         name: "");
//                               controller.clear();

//                               // });

//                               // Get.back();
//                               // context.read<SongsBloc>().add(LoadSongs());
//                               // Дождитесь обновления состояния
//                               await Future.delayed(
//                                   const Duration(milliseconds: 300));

//                               // Получение группы и обновление песен
//                               final state = context.read<SongsBloc>().state;
//                               if (state is SongsLoaded &&
//                                   state.groups.isNotEmpty) {
//                                 final lastGroupId = state.groups.first.id;
//                                 for (int i = 0; i < selectedSongs.length; i++) {
//                                   context.read<SongsBloc>().add(
//                                         UpdateSong(selectedSongs[i].copy(
//                                           order: i + 1,
//                                           group: lastGroupId,
//                                         )),
//                                       );
//                                 }
//                               }
//                               // resetSelectionCallback();
//                               // setState1(() {
//                               //   isSecondButton = false;
//                               //   // indexAdd = 0;
//                               //   selectedSongsId.clear();
//                               //   selectedSongs.clear();
//                               // });
//                               // Get.back();
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 15),
//                         // Кнопка "Отмена"
//                         Expanded(
//                           child: CustomButtonSheet(
//                             isSecond: true,
//                             onPressed: () {
//                               setState1(() {
//                                 controller.clear();
//                               });
//                             },
//                             title: tr(LocaleKeys.confirmation_cancel),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         } else if (state is SongsError) {
//           return Center(
//             child: Text(
//               "Error: ${state.message}",
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }
//         return const SizedBox();
//       },
//     );
//   });
// }
