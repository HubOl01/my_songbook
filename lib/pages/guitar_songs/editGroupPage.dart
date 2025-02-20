import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_songbook/pages/settings/Premium/premiumPage.dart';

import '../../components/customButtonSheet.dart';
import '../../components/customTextField.dart';
import '../../core/bloc/songs_bloc.dart';
import '../../core/cubit/group_id_cubit.dart';
import '../../core/cubit/index_group_cubit.dart';
import '../../core/model/groupModel.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  TextEditingController controller = TextEditingController();
  GroupModel groupModel = GroupModel(name: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(tr(LocaleKeys.managing_groups_title))),
        body: Column(
          children: [
            _buildCreateGroupField(context),
            Expanded(
              child: BlocBuilder<SongsBloc, SongsState>(
                builder: (context, state) {
                  if (state is SongsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is SongsLoaded) {
                    final groups = state.groups;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return ListTile(
                          tileColor:
                              context.read<IndexGroupCubit>().state == index
                                  ? colorFiolet.withValues(alpha: .1)
                                  : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          title: Text(group.name),
                          trailing:
                              context.read<IndexGroupCubit>().state == index
                                  ? Icon(
                                      Icons.check,
                                      color: colorFiolet,
                                    )
                                  : null,
                          // Icon(
                          //   EvaIcons.minus_circle_outline,
                          //   size: 20,
                          //   color: context.isDarkMode
                          //       ? Colors.white.withOpacity(.7)
                          //       : Colors.grey[600],
                          // ),
                          onTap: () {
                            // _showDeleteConfirmation(context, group);
                            context.read<GroupCubit>().swither(group);
                            context.read<IndexGroupCubit>().swither(index);
                            Get.back();
                          },
                          onLongPress: () {
                            _showMenuConfirmation(context, group);
                          },
                        );
                      },
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
              ),
            ),
          ],
        ));
  }

  Widget _buildCreateGroupField(BuildContext context) {
    return BlocBuilder<SongsBloc, SongsState>(
      builder: (context, state) {
        if (state is SongsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SongsLoaded) {
          final groups = state.groups;

          // Если групп 5 или больше, не показывать поле создания
          if (groups.length >= 5 &&
              controller.text.isEmpty &&
              groupModel.id == null) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    tr(LocaleKeys.info_max_group),
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          context.isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  context.locale == const Locale('ru')
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              tr(LocaleKeys.pro_version_content),
                              style: TextStyle(
                                fontSize: 14,
                                color: context.isDarkMode
                                    ? Colors.white70
                                    : Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomButtonSheet(
                                height: 30,
                                onPressed: () {
                                  Get.to(const PremiumPage());
                                },
                                title: tr(LocaleKeys.pro_version_button)),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            );
          }

          return Container(
            height: 140,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                // Поле ввода
                CustomTextField(
                  controller: controller,
                  title: tr(LocaleKeys.title_new_group),
                  onChanged: (value) => setState(() {}),
                ),
                // Счетчик символов
                Text(
                  "${controller.text.length}/20",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.isDarkMode
                        ? Colors.white.withValues(alpha: .7)
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 5),
                // Кнопки подтверждения
                // if (controller.text.isNotEmpty)
                //   SizedBox(
                //     height: 30,
                //     width: 200,
                //     child: Row(
                //       children: [
                //         // Кнопка "Создать" или "Обновить"
                //         Expanded(
                //           child: CustomButtonSheet(
                //             onPressed: groupModel.id == null
                //                 ? () {
                //                     // Добавление группы
                //                     context.read<SongsBloc>().add(
                //                           AddGroup(GroupModel(
                //                               name: controller.text)),
                //                         );
                //                     setState(() {
                //                       groupModel = GroupModel(name: "");
                //                       controller.clear();
                //                     });
                //                   }
                //                 : () {
                //                     // Обновление группы
                //                     context.read<SongsBloc>().add(
                //                           UpdateGroup(groupModel.copy(
                //                               name: controller.text)),
                //                         );
                //                     setState(() {
                //                       groupModel = GroupModel(name: "");
                //                       controller.clear();
                //                     });
                //                   },
                //             title: groupModel.id == null
                //                 ? tr(LocaleKeys.confirmation_create)
                //                 : tr(LocaleKeys.confirmation_changing),
                //           ),
                //         ),
                //         const SizedBox(width: 15),
                //         // Кнопка "Отмена"
                //         Expanded(
                //           child: CustomButtonSheet(
                //             isSecond: true,
                //             onPressed: () {
                //               setState(() {
                //                 controller.clear();
                //                 groupModel = GroupModel(name: "");
                //               });
                //             },
                //             title: tr(LocaleKeys.confirmation_cancel),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                if (controller.text.isNotEmpty)
                  SizedBox(
                    height: 30,
                    width: 200,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomButtonSheet(
                            onPressed: groupModel.id == null
                                ? () {
                                    // Проверка на дубликат
                                    if (groups.any((group) =>
                                        group.name.toLowerCase() ==
                                        controller.text.toLowerCase())) {
                                      Get.snackbar(
                                        tr(LocaleKeys
                                            .error_duplicate_group_title),
                                        tr(LocaleKeys
                                            .error_duplicate_group_message),
                                        // snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            Colors.red.withValues(alpha: .8),
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // Добавление группы
                                    context.read<SongsBloc>().add(
                                          AddGroup(GroupModel(
                                              name: controller.text)),
                                        );
                                    AppMetrica.reportEvent(
                                        'Added group name: ${controller.text}');
                                    setState(() {
                                      groupModel = GroupModel(name: "");
                                      controller.clear();
                                    });
                                  }
                                : () {
                                    // Проверка на дубликат при обновлении
                                    if (groups.any((group) =>
                                        group.name.toLowerCase() ==
                                            controller.text.toLowerCase() &&
                                        group.id != groupModel.id)) {
                                      Get.snackbar(
                                        tr(LocaleKeys
                                            .error_duplicate_group_title),
                                        tr(LocaleKeys
                                            .error_duplicate_group_message),
                                        // snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor:
                                            Colors.red.withValues(alpha: .8),
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // Обновление группы
                                    context.read<SongsBloc>().add(
                                          UpdateGroup(groupModel.copy(
                                              name: controller.text)),
                                        );
                                    setState(() {
                                      groupModel = GroupModel(name: "");
                                      controller.clear();
                                    });
                                  },
                            title: groupModel.id == null
                                ? tr(LocaleKeys.confirmation_create)
                                : tr(LocaleKeys.confirmation_changing),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: CustomButtonSheet(
                            isSecond: true,
                            onPressed: () {
                              setState(() {
                                controller.clear();
                                groupModel = GroupModel(name: "");
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
  }

  // Модальное окно подтверждения удаления группы
  void _showDeleteConfirmation(BuildContext context, GroupModel group) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (contextModal) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                Text(
                  tr(LocaleKeys.confirmation_delete_group_title),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  "${tr(LocaleKeys.confirmation_delete_group_content1)} \"${group.name}\" ${tr(LocaleKeys.confirmation_delete_group_content2)}",
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButtonSheet(
                  width: context.width,
                  height: 40,
                  onPressed: () {
                    context.read<SongsBloc>().add(DeleteGroup(group.id!));
                    Navigator.pop(context);
                  },
                  title: tr(LocaleKeys.confirmation_delete),
                  fontSize: 14,
                ),
                const SizedBox(height: 10),
                CustomButtonSheet(
                  width: context.width,
                  height: 40,
                  isSecond: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  title: tr(LocaleKeys.confirmation_cancel),
                  fontSize: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMenuConfirmation(BuildContext context, GroupModel group) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (contextModal) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const SizedBox(height: 10),
                Text(
                  group.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButtonSheet(
                  width: context.width,
                  height: 40,
                  // isSecond: true,
                  onPressed: () {
                    setState(() {
                      controller.text = group.name;
                      groupModel = group;
                    });
                    Navigator.pop(context);
                  },
                  title: tr(LocaleKeys.confirmation_changing),
                  fontSize: 14,
                ),
                const SizedBox(height: 10),
                CustomButtonSheet(
                  width: context.width,
                  height: 40,
                  isDelete: true,
                  onPressed: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(context, group);
                  },
                  title: tr(LocaleKeys.confirmation_delete),
                  fontSize: 14,
                ),
                // const SizedBox(height: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
