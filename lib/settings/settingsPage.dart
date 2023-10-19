import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/settings/Themes/themePage.dart';
import 'package:my_songbook/settings/Translate/translatePage.dart';
import 'package:my_songbook/settings/techSupport/techSupportPage.dart';

import '../generated/locale_keys.g.dart';
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
                  tr(LocaleKeys.bottom_settings),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                )),
          ),
        ),
        ListTile(
          leading: Icon(Icons.photo_outlined),
          title: Text(tr(LocaleKeys.settings_theme_mode)),
          onTap: () {
            AppMetrica.reportEvent('ThemePage');
            Get.to(ThemePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.translate),
          title: Text(tr(LocaleKeys.settings_translate)),
          onTap: () {
            AppMetrica.reportEvent('TranslatePage');
            Get.to(TranslatePage());
          },
        ),
        ListTile(
          leading: Icon(Icons.help_outline),
          title: Text(tr(LocaleKeys.settings_help)),
          onTap: () {
            AppMetrica.reportEvent('HelperPage');
            Get.to(HelperPage());
          },
        ),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text(tr(LocaleKeys.settings_call_tech)),
          onTap: () {
            AppMetrica.reportEvent('TechSupportPage');
            Get.to(TechSupportPage());
          },
        ),
        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text(tr(LocaleKeys.settings_about)),
          onTap: () {
            AppMetrica.reportEvent('AboutPage');
            Get.to(AboutPage());
          },
        ),
      ],
    ));
  }
}
