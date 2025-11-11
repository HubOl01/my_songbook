// ignore_for_file: must_be_immutable

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/buttons/customButton.dart';
import '../../../components/customListTile.dart';
import '../../../components/sendToSupport.dart';
import '../../../core/model/newsModel.dart';

class DetalNews extends StatelessWidget {
  final NewsModel newData;
  DetalNews({super.key, required this.newData});
  double fontSize = 16;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newData.name!),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        children: [
          if (newData.imageUrl != '')
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: newData.imageUrl!,
                    )),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var description in newData.description!)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Markdown(
                      onTapLink: (text, href, title) => href != ''
                          ? href!.contains("@mail.ru") ||
                                  href.contains("@gmail.com")
                              ? sendToSupport(context)
                              : launchUrl(Uri.parse(href),
                                  mode: LaunchMode.inAppWebView)
                          : null,
                      padding: const EdgeInsets.all(2),

                      bulletBuilder: (MarkdownBulletParameters parameters) {
                        // parameters содержит информацию о стиле и индексе
                        if (parameters.style == BulletStyle.orderedList) {
                          return Text(
                            '${parameters.index + 1}.',
                            style: TextStyle(
                                color: context.isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        } else {
                          // BulletStyle.unorderedList
                          return Container(
                            margin: const EdgeInsets.only(top: 1),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              shape: BoxShape.circle,
                            ),
                          );
                        }
                      },
                      // bulletBuilder: (parameters) => Text(parameters),
                      styleSheet: MarkdownStyleSheet(
                          p: TextStyle(fontSize: fontSize),
                          blockquotePadding: const EdgeInsets.only(
                              left: 12, top: 8, bottom: 8),
                          h3: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .fontSize!),
                          listBullet: const TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 20),
                          listIndent: 22,
                          listBulletPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          // orderedListAlign: WrapAlignment.spaceBetween,
                          blockquoteDecoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: Colors.grey,
                                width: 5.0, // Толщина стенки
                              ),
                            ),
                          )),
                      data: description,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    )),
              if (newData.audio!.isNotEmpty || newData.audio == [])
                for (var audio in newData.audio!)
                  InkWell(
                    onTap: () {
                      AppMetrica.reportEvent(
                          'Clicked music: ${audio.nameSong.toString()} ${audio.audioUrl.toString()}');
                      launchUrl(Uri.parse(audio.audioUrl!));
                    },
                    child: Column(
                      children: [
                        CustomListTile(
                          title: SizedBox(
                            width: context.width - 50,
                            child: Text(
                              audio.nameSong ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          subtitle: SizedBox(
                            width: context.width - 50,
                            child: Text(
                              audio.nameSinger ?? '',
                              style: TextStyle(
                                color: context.isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          trailing: const Icon(Icons.play_circle),
                          paddingBottom:
                              audio.nameUrlWeb!.trim() == '' ? true : false,
                        ),
                        audio.nameUrlWeb!.trim() == ''
                            ? const SizedBox()
                            : Column(
                                children: [
                                  Divider(
                                    color: context.isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: context.isDarkMode
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                          size: 13,
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          audio.nameUrlWeb ?? '',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: context.isDarkMode
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: context.isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
            ],
          ),
          newData.isButton!
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: SizedBox(
                    width: context.width,
                    height: 50,
                    child: CustomButton(
                        onPressed: () {
                          AppMetrica.reportEvent(
                              'Информация о приложении (Кнопка)');
                          launchUrl(Uri.parse(newData.button!.buttonUrl!));
                        },
                        child: Text(
                          newData.button!.buttonName!,
                          style: const TextStyle(fontSize: 16),
                        )),
                  ),
                )
              : newData.isUpdate!
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: SizedBox(
                        width: context.width,
                        height: 50,
                        child: CustomButton(
                            onPressed: () {
                              AppMetrica.reportEvent(
                                  'Информация о приложении (обновление)');
                              launchUrl(
                                  Uri.parse(
                                      'https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook_pro'),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: const Text(
                              "Обновиться до последней версии",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                    )
                  : const SizedBox(),
          newData.isSupport!
              ? Material(
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  elevation: 2,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontSize: fontSize,
                                color: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .color),
                            children: [
                          TextSpan(
                            text: context.locale == const Locale('ru')
                                ? "Если вы обнаружили проблему или у вас есть пожелания по улучшению нашего сервиса, свяжитесь с разработчиком "
                                : "If you find a problem or have any suggestions for improving our service, please contact the developer ",
                          ),
                          TextSpan(
                            text: context.locale == const Locale("ru")
                                ? "по электронной почте."
                                : "by email.",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                sendToSupport(context);
                              },
                          ),
                        ])),
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
