// ignore_for_file: must_be_immutable

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/customButton.dart';
import '../../components/sendToSupport.dart';
import '../../components/updateApp.dart';
import '../model/newsModel.dart';

class DetalNews extends StatelessWidget {
  final News newData;
  DetalNews({required this.newData});
  double fontSize = 16;
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newData.name!),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
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
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var description in newData.description!)
                  Markdown(
                    padding: EdgeInsets.all(0),
                    styleSheet:
                        MarkdownStyleSheet(p: TextStyle(fontSize: fontSize)),
                    data: description,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                if (newData.audio!.isNotEmpty || newData.audio == [])
                  for (var audio in newData.audio!)
                    ListTile(
                      title: Text(audio.nameSong ?? ''),
                      subtitle: Text(audio.nameSinger ?? ''),
                      trailing: Icon(Icons.play_circle),
                      onTap: () => launchUrl(
                        Uri.parse(audio.audioUrl!),
                      ),
                    ),
              ],
            ),
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
                        child: Text("Обновиться до последней версии")),
                  ),
                )
              : SizedBox(),
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
                                text: context.locale == Locale('ru')
                                    ? "Если вы обнаружили проблему или у вас есть пожелания по улучшению нашего сервиса, свяжитесь с разработчиком "
                                    : "If you find a problem or have any suggestions for improving our service, please contact the developer ",
                              ),
                              TextSpan(
                                text: context.locale == Locale("ru")
                                    ? "по электронной почте."
                                    : "by email.",
                                style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    sendToSupport();
                                  },
                              ),
                            ])),
                      )),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
