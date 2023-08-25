import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Model/help.dart';
import 'data/helpList.dart';

class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Помощь"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList.radio(
              children:
                  questions.map<ExpansionPanelRadio>((HelpModel helpModel) {
                return ExpansionPanelRadio(
                    // backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(helpModel.question),
                      );
                    },
                    body: ListTile(
                      title: Text(helpModel.answer),
                    ),
                    value: helpModel.question);
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                    text: TextSpan(children: [
                  new TextSpan(
                    text:
                        'Не нашли вопрос? Вы можете написать любые вопросы через наше сообщество VK по ',
                    style: new TextStyle(color: Colors.black),
                  ),
                  new TextSpan(
                    text: 'ссылке...',
                    style: new TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(
                          Uri.parse("https://vk.com/topic-222084855_49405619"),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// HelpModel(
//       question: "Другие вопросы",
//       answer:
//           "Вы можете написать любые вопросы через наше сообщество вконтакте"),