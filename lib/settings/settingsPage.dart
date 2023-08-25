import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/settings/CallPage/callPage.dart';

import 'About/aboutPage.dart';
import 'Helper/HelperPage.dart';
import 'settingsController.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      physics: BouncingScrollPhysics(),
      children: [
        Container(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Настройки",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                )),
          ),
        ),
        ListTile(
          leading: Icon(Icons.photo_outlined),
          title: Text("Режим темы"),
          onTap: () {
            final snackBar = SnackBar(
              content: const Text('Эта опция в разработке'),
            );

            // Find the ScaffoldMessenger in the widget tree
            // and use it to show a SnackBar.
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Future.delayed(Duration(seconds: 5), () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            });
            // ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text("Помощь"),
          onTap: () {
            Get.to(HelperPage());
          },
        ),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text("Обратиться в техподдержку"),
          onTap: () {
            Get.to(CallPage());
            // launchUrl(
            //               Uri.parse("https://vk.com/topic-222084855_49405611"),
            //               mode: LaunchMode.externalApplication,
            //             );
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text("О приложении"),
          onTap: () {
            Get.to(AboutPage());
          },
        ),
      ],
    ));
  }
}
