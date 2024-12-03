import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:my_songbook/components/customButtonSheet.dart';
import 'package:my_songbook/components/customTextField.dart';
import 'package:my_songbook/core/cubit/group_id_cubit.dart';
import 'package:my_songbook/core/cubit/index_group_cubit.dart';

import '../../core/bloc/songs_bloc.dart';
import '../../core/model/groupModel.dart';

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
        appBar: AppBar(title: Text("Управление группами")),
        body: Column(
          children: [
            _buildCreateGroupField(context),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<SongsBloc, SongsState>(
                builder: (context, state) {
                  if (state is SongsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SongsLoaded) {
                    final groups = state.groups;

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: groups.length,
                      itemBuilder: (context, index) {
                        final group = groups[index];
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          title: Text(group.name),
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
                        "Ошибка загрузки групп: ${state.message}",
                        style: TextStyle(color: Colors.red),
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
    return Container(
      height: 150,
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(bottom: 10, top: 10),
      child: Column(
        children: [
          CustomTextField(
            controller: controller,
            title: "Назовите новую группу",
            onChanged: (value) {
              setState(() {
                controller.text = value;
              });
            },
          ),
          Text(
            "${controller.text.length}/20",
            style: TextStyle(
              fontSize: 12,
              color: context.isDarkMode
                  ? Colors.white.withOpacity(.7)
                  : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          controller.text.isNotEmpty
              ? SizedBox(
                  height: 30,
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButtonSheet(
                          onPressed: groupModel.id == null
                              ? () {
                                  context.read<SongsBloc>().add(AddGroup(
                                      GroupModel(name: controller.text)));
                                  setState(() {
                                    groupModel = GroupModel(name: "");
                                    controller.clear();
                                  });
                                }
                              : () {
                                  context.read<SongsBloc>().add(UpdateGroup(
                                      groupModel.copy(name: controller.text)));
                                  setState(() {
                                    groupModel = GroupModel(name: "");
                                    controller.clear();
                                  });
                                },
                          title: groupModel.id == null ? "Создать" : "Изменить",
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
                          title: "Отменить",
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  // Модальное окно подтверждения удаления группы
  void _showDeleteConfirmation(BuildContext context, GroupModel group) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (contextModal) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              Text(
                "Удалить группу?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Группа \"${group.name}\" будет удалена, и вы не сможете её восстановить. Сохранённые в группе песни будут перемещены в общий список.",
                style: TextStyle(fontSize: 14),
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
                title: "Удалить",
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
                title: "Отменить",
                fontSize: 14,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMenuConfirmation(BuildContext context, GroupModel group) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (contextModal) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 10),
              Text(
                group.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                title: "Изменить",
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
                title: "Удалить",
                fontSize: 14,
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
