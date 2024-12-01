import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_songbook/components/customButtonSheet.dart';
import 'package:my_songbook/components/customTextField.dart';

class EditGroupPage extends StatefulWidget {
  const EditGroupPage({super.key});

  @override
  State<EditGroupPage> createState() => _EditGroupPageState();
}

class _EditGroupPageState extends State<EditGroupPage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Управление группами")),
      body: Column(
        children: [
          Container(
            height: 100,
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(bottom: 10, top: 10),
            child: Column(
              children: [
                CustomTextField(
                  controller: controller,
                  title: "Назовите новую группу",
                  onChanged: (value) => setState(() {
                    controller.text = value;
                  }),
                ),
                Text(
                  "${controller.text.length}/20",
                  style: TextStyle(
                      fontSize: 12,
                      color: context.isDarkMode
                          ? Colors.white.withOpacity(.7)
                          : Colors.grey[600]),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          controller.text.isNotEmpty
              ? SizedBox(
                  height: 30,
                  width: 200,
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomButtonSheet(
                        onPressed: () {},
                        title: "Создать",
                      )),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: CustomButtonSheet(
                        isSecond: true,
                        onPressed: () {
                          setState(() {
                            controller.clear();
                          });
                        },
                        title: "Отменить",
                      ))
                    ],
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 15,
          ),
          Expanded(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                // horizontalTitleGap: 0,
                minTileHeight: 45,
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      context: context,
                      builder: (context) => Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Удалить группу?",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Группа ___ пропадет и вы не сможете восстановить, а песни которые были сохранены в группе будут разбросаны в общий список.",
                                  style: TextStyle(
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
                                  onPressed: () {},
                                  title: "Удалить",
                                  fontSize: 14,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomButtonSheet(
                                  width: context.width,
                                  height: 40,
                                  isSecond: true,
                                  onPressed: () {},
                                  title: "Отменить",
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ));
                },
                contentPadding:
                    EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                title: Text("Text"),
                trailing: Icon(
                  EvaIcons.minus_circle_outline,
                  size: 20,
                  color: context.isDarkMode
                      ? Colors.white.withOpacity(.7)
                      : Colors.grey[600],
                )),
          ))
        ],
      ),
    );
  }
}
