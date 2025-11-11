import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/pages/guitar_songs/Card_for_news/detalNews.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/model/newsModel.dart';

class ListEvent extends StatelessWidget {
  final NewsModel news;
  final Function() onClose;
  const ListEvent({super.key, required this.news, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: news.isClick == true
          ? () async {
              AppMetrica.reportEvent('clicked ${news.id}!');
              if (news.type != 'website') {
                Get.to(() => DetalNews(newData: news));
              } else if (news.websiteUrl?.isNotEmpty == true) {
                await launchUrl(
                  Uri.parse(news.websiteUrl!),
                  mode: LaunchMode.inAppWebView,
                );
              }
            }
          : null,
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
            if (news.iconUrl != null && news.iconUrl!.isNotEmpty)
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 60,
                  maxHeight: 60,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: news.iconDarkUrl!.isNotEmpty && context.isDarkMode
                        ? news.iconDarkUrl!
                        : news.iconUrl!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      // margin: const EdgeInsets.only(right: 10.0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? Colors.white24
                            : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (news.name != null && news.name!.isNotEmpty)
                    Text(
                      news.name ?? 'Название отсутствует',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.isDarkMode
                              ? Colors.white.withValues(alpha: .9)
                              : Colors.black.withValues(alpha: .7)),
                    ),
                  if (news.shortDesc != null && news.shortDesc!.isNotEmpty)
                    Text(
                      news.shortDesc!,
                      style: TextStyle(
                          fontSize: 13,
                          color: context.isDarkMode
                              ? Colors.white.withValues(alpha: .7)
                              : Colors.black.withValues(alpha: .6)),
                    ),
                ],
              ),
            ),
            // const SizedBox(
            //   width: 10,
            // ),
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
