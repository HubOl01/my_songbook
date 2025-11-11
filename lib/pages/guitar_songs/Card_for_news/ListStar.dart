import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ListStar extends StatelessWidget {
  final Function() onClose;
  const ListStar({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        AppMetrica.reportEvent('clicked star_rate');
        launchUrl(
            Uri.parse(
                'https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook'),
            mode: LaunchMode.externalApplication);
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
            Icon(Icons.star,
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
                    "Оцените приложение",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? Colors.white.withValues(alpha: .9)
                            : Colors.black.withValues(alpha: .7)),
                  ),
                  Text(
                    "Оцените приложение и помогите нам стать лучше!",
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
