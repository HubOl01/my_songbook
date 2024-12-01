import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/updateApp.dart';
import '../../../generated/locale_keys.g.dart';
import 'aboutController.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _navigatorKey = GlobalKey<NavigatorState>();
    final customTextStyle = TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryTextTheme.titleMedium!.color);
    return Obx(() => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor:
                Theme.of(context).primaryTextTheme.titleMedium!.color,
            elevation: 0,
          ),
          body: controller.isloading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
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
                                "${tr(LocaleKeys.settings_about_version)} ${controller.version.value}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          )),
                      // ListTile(
                      //     title: Text(tr(LocaleKeys.settings_about_subscribe)),
                      //     trailing: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         IconButton(
                      //           onPressed: () {
                      //             launchUrl(
                      //               Uri.parse("https://vk.com/mysongbook01"),
                      //               mode: LaunchMode.externalApplication,
                      //             );
                      //           },
                      //           icon: Logo(
                      //             Logos.vk,
                      //             // size: 30,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         IconButton(
                      //           onPressed: () {
                      //             launchUrl(
                      //               Uri.parse("https://t.me/mysongbook01"),
                      //               mode: LaunchMode.externalApplication,
                      //             );
                      //           },
                      //           icon: Logo(
                      //             Logos.telegram,
                      //             // size: 30,
                      //           ),
                      //         ),
                      //       ],
                      //     )),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: context.width,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                updateApp(_navigatorKey, context);
                              },
                              child: Text(
                                  tr(LocaleKeys.settings_about_check_update))),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}

final AboutController controller = Get.put(AboutController());
