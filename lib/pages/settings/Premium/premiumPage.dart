import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/buttons/customButton.dart';
import '../../../core/utils/backup.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Премиум')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/icon/my_songbook_pro.png",
                        height: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "My Songbook Pro",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium!
                              .color),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    '''🎵 My Songbook Pro — ваш персональный песенник нового поколения!    
          
          Создавайте, организуйте и делитесь своими музыкальными шедеврами с легкостью. Неважно, кто вы — гитарист, певец, композитор или просто любитель музыки. Это приложение создано, чтобы вдохновлять и помогать вам на каждом шагу творческого пути.
          
✨ Почему выбирают My Songbook Pro?

          ✅ Неограниченные возможности:  Создавайте столько групп песен, сколько нужно, и настраивайте их под себя — изменяйте цвета, порядок, ищите нужное и экспортируйте.

          ✅ Ранний доступ к новым функциям:  Владельцы полной версии всегда первыми получают обновления и улучшения.

          ✅ Удобство и простота:  Интуитивный интерфейс для быстрого создания и управления вашими песнями.
          
🔥 Приобретите полную версию уже сегодня и раскройте весь потенциал приложения: создавайте без ограничений, наслаждайтесь эксклюзивными функциями и будьте впереди с ранним доступом к обновлениям.   
          
🎶 My Songbook Pro — ваш надежный помощник в мире музыки. Превратите идеи в шедевры уже сегодня!'''),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                      color: colorFiolet.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: colorFiolet.withValues(alpha: .5), width: 1.5)),
                  child: Column(
                    children: [
                      const Text(
                        "Перед переходом на My Songbook Pro",
                        style: TextStyle(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          "Если вы хотите перенести свои данные в версию PRO, рекомендуем сделать резервную копию."),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              style: const ButtonStyle(
                                  minimumSize:
                                      WidgetStatePropertyAll(Size.zero),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5))),
                              onPressed: () {
                                AppMetrica.reportEvent('data_backup');
                                createBackup(context);
                              },
                              child: const Text(
                                "Сделать копию?",
                              )))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: context.width,
                  height: 45,
                  child: CustomButton(
                    onPressed: () {
                      launchUrl(Uri.parse(
                          "https://www.rustore.ru/catalog/app/ru.ru_developer.my_songbook_pro"));
                    },
                    child: const Text("Скачать полную версию"),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
