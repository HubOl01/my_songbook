import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:my_songbook/settings/Themes/Themes.dart';
import 'package:my_songbook/settings/currentNumber.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'applications_guitar/applicationsPage.dart';
import 'guitar_songs/guitarPage.dart';
import 'settings/settingsPage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Material();
  };
  var app = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(app.path);
  var box = await Hive.openBox('my_songbook');
  speed = box.get("speedText") ?? 150;
  sizeText = box.get("sizeText") ?? 14.0;
  isClosedWarring = box.get("isClosedWarring") ?? false;
  isDeleteTest = box.get("isDeleteTest") ?? false;
  try {
    AppMetrica.activate(
        AppMetricaConfig("1d6d9a9b-318d-47c3-aac4-1a83f5ba93ff"));
  } catch (ex) {
    print("app_metrica: ${ex}");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ru', 'RU'),
        Locale('en', ''),
        Locale('ar', ''),
        Locale('fr', ''),
      ],
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get.put(MyHomePageController());
    // return GetBuilder<MyHomePageController>(builder: (controller) {
    return GetBuilder<MyHomePageController>(
        init: MyHomePageController(),
        initState: (controller) {},
        builder: (controller) {
          return Scaffold(
              body: IndexedStack(
                index: controller.tabIndex.value,
                children: pages,
              ),
              bottomNavigationBar: Obx(() => BottomNavigationBar(
                    onTap: controller.changeTabIndex,
                    unselectedItemColor: Colors.black,
                    selectedItemColor: Colors.redAccent,
                    currentIndex: controller.tabIndex.value,
                    showSelectedLabels: false,
                    showUnselectedLabels: false,
                    enableFeedback: true,
                    landscapeLayout:
                        BottomNavigationBarLandscapeLayout.centered,
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(LineAwesome.file_audio),
                          label: "Песни",
                          tooltip: "Песни"),
                      BottomNavigationBarItem(
                          icon: Icon(LineAwesome.guitar_solid),
                          label: "Аппликатура аккордов",
                          tooltip: "Аппликатура аккордов для гитары"),
                      BottomNavigationBarItem(
                          icon: Icon(LineAwesome.cog_solid),
                          label: "Настройки",
                          tooltip: "Настройки"),
                    ],
                  )));
        });
  }
}

List<Widget> pages = [GuitarPage(), ApplicationsPage(), SettingsPage()];

class MyHomePageController extends GetxController {
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    update();
  }
}
