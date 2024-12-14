import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/pages/settings/Themes/themePage.dart';
import 'package:my_songbook/pages/settings/Translate/translatePage.dart';

import '../../components/sendToSupport.dart';
import '../../core/api/variable_firebase.dart';
import '../../core/styles/colors.dart';
import '../../generated/locale_keys.g.dart';
import 'About/aboutPage.dart';
import 'Helper/HelperPage.dart';
import 'Premium/premiumPage.dart';
import 'import_exportPage/ImportExportPage.dart';
import 'settingsController.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  tr(LocaleKeys.bottom_settings),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 35),
                )),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.photo_outlined),
          title: Text(tr(LocaleKeys.settings_theme_mode)),
          onTap: () {
            AppMetrica.reportEvent('ThemePage');
            Get.to(const ThemePage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.translate),
          title: Text(tr(LocaleKeys.settings_translate)),
          onTap: () {
            AppMetrica.reportEvent('TranslatePage');
            Get.to(const TranslatePage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: Text(tr(LocaleKeys.settings_help)),
          onTap: () {
            AppMetrica.reportEvent('HelperPage');
            Get.to(const HelperPage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.support_agent),
          title: Text(tr(LocaleKeys.settings_call_tech)),
          onTap: () async {
            sendToSupport();
          },
        ),
        ListTile(
            leading: const Icon(Icons.import_export),
            title: Row(
              children: [
                Text(tr(LocaleKeys.data_export_import_title)),
                FutureBuilder<bool>(
                  future: getBetaData(),
                  builder: (context, snapshot) {
                    return snapshot.data == true
                        ? Container(
                            // height: 20,
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorFiolet.withValues(alpha: .3),
                              borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: colorFiolet),
                            ),
                            child: Text(
                              "beta",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: colorFiolet,
                              ),
                            ),
                          )
                        : const SizedBox();
                  },
                )
              ],
            ),
            onTap: () async {
              Get.to(const ImportExportPage());
            }),
        context.locale == const Locale('ru')
            ? ListTile(
                leading: const Icon(Icons.workspace_premium),
                title: const Text("My Songbook Pro"),
                onTap: () {
                  AppMetrica.reportEvent('PremiumPage');
                  Get.to(const PremiumPage());
                },
              )
            : const SizedBox(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(tr(LocaleKeys.settings_about)),
          onTap: () {
            AppMetrica.reportEvent('AboutPage');
            Get.to(const AboutPage());
          },
        ),
      ],
    ));
  }
}
