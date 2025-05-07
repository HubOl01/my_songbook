import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/model/newsModel.dart';
import '../../../core/storage/storage.dart';
import '../../../core/utils/getAppVersion.dart';

class ListStar extends StatelessWidget {
  final Function() onClose;
  final NewsModel banner;
  const ListStar({super.key, required this.onClose, required this.banner});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.isDarkMode
          ? Colors.black.withValues(alpha: 0.2)
          : Colors.black.withValues(alpha: 0.2),
      leading: const Icon(Icons.star_rate),
      titleAlignment: ListTileTitleAlignment.center,
      minVerticalPadding: 10,
      minLeadingWidth: 20,
      minTileHeight: 50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: const Text(
        "Оцените приложение",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Оцените приложение и помогите нам стать лучше!",
        style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: Colors.white.withValues(alpha: .7)),
      ),
      onTap: () async {
        AppMetrica.reportEvent('star_rate');
        String currentVersion = await getAppVersion();
        final bannerManager = BannerManager();
        await bannerManager.shouldShowBanner(banner.id!);
        await bannerManager.shouldShowBannerForVersion(currentVersion);
        launchUrl(
            Uri.parse(
                'https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook_pro'),
            mode: LaunchMode.externalApplication);
      },
      trailing: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        splashRadius: 15,
        onPressed: () {},
        icon: Icon(
          Icons.close,
          size: 20,
          color: Colors.white.withValues(alpha: .7),
        ),
      ),
    );

    // ListTile(
    //   tileColor: context.isDarkMode
    //       ? Colors.black.withValues(alpha: .2)
    //       : Colors.black.withValues(alpha: .2),
    //   leading: const Icon(Icons.star_rate),
    //   minTileHeight: 50,
    //   minLeadingWidth: 10,
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    //   title: const Text(
    //     'Оцените приложение',
    //     style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    //   ),
    //   subtitle: Text(
    //     "Оцените приложение и помогите нам стать лучше!",
    //     style: TextStyle(
    //         fontSize: 13,
    //         height: 1.5,
    //         color: Colors.white.withValues(alpha: .7)),
    //   ),
    //   // const Text(""),
    //   onTap: () async {
    //     AppMetrica.reportEvent('star_rate');
    //     launchUrl(
    //         Uri.parse(
    //             'https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook_pro'),
    //         mode: LaunchMode.externalApplication);
    //   },
    //   trailing: IconButton(
    //       padding: EdgeInsets.zero,
    //       constraints: const BoxConstraints(),
    //       splashRadius: 15,
    //       onPressed: onClose,
    //       icon: const Icon(
    //         Icons.close,
    //         size: 20,
    //       )),
    // );
  }
}
