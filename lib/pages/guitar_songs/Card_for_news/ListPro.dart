import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/model/newsModel.dart';
import 'package:my_songbook/pages/settings/Premium/premiumPage.dart';
// import 'package:url_launcher/url_launcher.dart';

class ListPro extends StatelessWidget {
  final Function() onClose;
  final NewsModel model;
  const ListPro({super.key, required this.onClose, required this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        AppMetrica.reportEvent('clicked banner_pro');
        Get.to(const PremiumPage());
        // launchUrl(
        //     Uri.parse(
        //         'https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook_pro'),
        //     mode: LaunchMode.externalApplication);
      },
      child: Container(
        color: context.isDarkMode ? Colors.black.withValues(alpha: .15) : null,
        decoration: context.isDarkMode
            ? null
            : const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black26, width: 0.5))),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          spacing: 10,
          children: [
            Icon(Icons.workspace_premium,
                size: 30,
                color: context.isDarkMode
                    ? Colors.white.withValues(alpha: .9)
                    : Colors.black.withValues(alpha: .7)),
            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Songbook Pro",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? Colors.white.withValues(alpha: .9)
                            : Colors.black.withValues(alpha: .7)),
                  ),
                  Text(
                    model.shortDesc!.isEmpty
                        ? context.locale == const Locale('ru')
                            ? "Раскройте весь потенциал музыки – больше инструментов, функций и возможностей в одном приложении."
                            : "Unlock the full potential of music with more instruments, features, and capabilities in one app."
                        : model.shortDesc!,
                    style: TextStyle(
                        fontSize: 13,
                        // height: 1.5,
                        color: context.isDarkMode
                            ? Colors.white.withValues(alpha: .8)
                            : Colors.black.withValues(alpha: .6)),
                  ),
                ],
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 15,
              onPressed: onClose,
              icon: Icon(
                Icons.close,
                size: 20,
                color: context.isDarkMode
                    ? Colors.white.withValues(alpha: .9)
                    : Colors.black.withValues(alpha: .7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
