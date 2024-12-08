import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/components/customButton.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Премиум')),
      body: Padding(
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
            const Text('''Уважаемые пользователи!
        
        С выходом новой версии нашего приложения мы добавили больше функций, и теперь оно становится всё более функциональным. В связи с этим мы решили сделать некоторые функции платными, чтобы поддержать разработчиков.
        
        После подписки вы получите доступ к некоторым функциям, таким как неограниченное создание групп. В будущем мы планируем добавить новые функции.'''),
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
            )
          ],
        ),
      ),
    );
  }
}
