// ignore_for_file: must_be_immutable

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/customButton.dart';
import '../../../components/customListTile.dart';
import '../../../components/sendToSupport.dart';
import '../../../components/updateApp.dart';
import '../../../core/model/newsModel.dart';

class DetalNews extends StatelessWidget {
  final News newData;
  DetalNews({super.key, required this.newData});
  double fontSize = 16;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newData.name!),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: newData.imageUrl != ''
                      ? CachedNetworkImage(
                          imageUrl: newData.imageUrl!,
                        )
                      : Image.asset(context.isDarkMode
                          ? 'assets/images/dark_isuct.png'
                          : 'assets/images/isuct.png')),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var description in newData.description!)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Markdown(
                      onTapLink: (text, href, title) => href != ''
                          ? href!.contains("@mail.ru") ||
                                  href.contains("@gmail.com")
                              ? sendToSupport(context)
                              : launchUrl(Uri.parse(href),
                                  mode: LaunchMode.inAppWebView)
                          : null,
                      padding: const EdgeInsets.all(2),
                      styleSheet: MarkdownStyleSheet(
                          p: TextStyle(fontSize: fontSize),
                          blockquotePadding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                          h3: TextStyle(fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize!),
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
                              audio.nameUrlweb!.trim() == '' ? true : false,
                        ),
                        audio.nameUrlweb!.trim() == ''
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
                                          audio.nameUrlweb ?? '',
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
          newData.isUpdate!
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: context.width,
                    height: 50,
                    child: CustomButton(
                        onPressed: () {
                          AppMetrica.reportEvent(
                              'Информация о приложении (обновление)');
                          updateApp(_navigatorKey, context);
                        },
                        child: const Text("Обновиться до последней версии")),
                  ),
                )
              : const SizedBox(),
          newData.isSupport!
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                      color: Theme.of(context)
                          .bottomNavigationBarTheme
                          .backgroundColor,
                      elevation: 5,
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
                      )),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
