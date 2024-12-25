import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../components/updateApp.dart';
import '../../../generated/locale_keys.g.dart';
import 'aboutController.dart';

class AboutPage extends GetView<AboutController> {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final navigatorKey = GlobalKey<NavigatorState>();
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
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          width: context.width,
                          height: context.height / 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  "assets/icon/my_songbook.png",
                                  height: 100,
                                ),
                              ),
                              Text(
                                controller.appName.value,
                                style: customTextStyle,
                              ),
                              Text(
                                "${tr(LocaleKeys.settings_about_version)} ${controller.version.value}",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          )),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Text(
                          "Device Information",
                          style: customTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        // elevation: 3,
                        onTap: () {
                          final allInfo = controller.deviceInfo.entries
                              .map((entry) => "${entry.key}: ${entry.value}")
                              .join('\n');
                          controller.copyToClipboard(allInfo, context);
                        },
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...controller.deviceInfo.entries.map((entry) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        "${entry.key}:",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        entry.value.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                        trailing: const Icon(Icons.copy),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: SizedBox(
                      //     width: context.width,
                      //     height: 50,
                      //     child: ElevatedButton(
                      //         onPressed: () {
                      //           // updateApp(navigatorKey, context);
                      //         },
                      //         child: Text(
                      //             tr(LocaleKeys.settings_about_check_update))),
                      //   ),
                      // ),
                    ],
                  ),
                ),
        ));
  }
}

final AboutController controller = Get.put(AboutController());
