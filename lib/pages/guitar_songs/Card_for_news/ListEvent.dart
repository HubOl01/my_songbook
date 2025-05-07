import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/model/newsModel.dart';
import 'detalNews.dart';

class ListEvent extends StatelessWidget {
  final NewsModel news;
  final Function() onClick;
  final Function() onClose;
  const ListEvent(
      {super.key,
      required this.news,
      required this.onClose,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: context.isDarkMode
          ? Colors.black.withValues(alpha: 0.2)
          : Colors.black.withValues(alpha: 0.2),
      leading: news.iconStarred == null ||
              news.iconPro == null ||
              news.isUpdate == null
          ? null
          : news.isUpdate!
              ? const Icon(Icons.new_releases)
              : news.iconStarred!
                  ? const Icon(Icons.star_rate)
                  : news.iconPro!
                      ? const Icon(Icons.workspace_premium)
                      : null,
      titleAlignment: ListTileTitleAlignment.center,
      minVerticalPadding: 10,
      minLeadingWidth: 20,
      minTileHeight: 50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      title: news.name == null || news.name!.isEmpty
          ? null
          : Text(
              news.name ?? 'Название отсутствует',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
      subtitle: news.shortDesc == null || news.shortDesc!.isEmpty
          ? null
          : Text(
              news.shortDesc!,
              style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.white.withValues(alpha: .7)),
            ),
      onTap: news.isClick == true
          ? () async {
              if (news.type != 'website') {
                Get.to(() => DetalNews(newData: news));
              } else if (news.websiteUrl?.isNotEmpty == true) {
                await launchUrl(
                  Uri.parse(news.websiteUrl!),
                  mode: LaunchMode.inAppWebView,
                );
              }
              onClick();
            }
          : null,
      trailing: news.iconArrow == true
          ? Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: Colors.white.withValues(alpha: .7),
            )
          : news.iconClose == true
              ? IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 15,
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white.withValues(alpha: .7),
                  ),
                )
              : const SizedBox(),
    );
  }
}
