import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutController.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final customTextStyle = TextStyle(
        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
    return Obx(() => Scaffold(
          body: controller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: context.width,
                        height: context.height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                "assets/icon/my_songbook.png",
                                height: 100,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            Text(
                              controller.appName.value,
                              style: customTextStyle,
                            ),
                            Text(
                              "Версия: ${controller.version.value}",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        )),
                    ListTile(
                        title: Text("Подпишитесь на наше сообщество, чтобы не пропустить новости"),
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                                "https://vk.com/mysongbook01"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        trailing: Logo(
                          Logos.vk,
                          // size: 30,
                        )),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: context.width,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.updateApp();
                            },
                            child: Text("Проверить наличие обновлений")),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

final AboutController controller = Get.put(AboutController());
