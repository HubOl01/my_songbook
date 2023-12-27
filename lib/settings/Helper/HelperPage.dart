import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_songbook/components/sendToSupport.dart';

import '../../generated/locale_keys.g.dart';
import 'Model/help.dart';
import 'data/helpList.dart';

class HelperPage extends StatelessWidget {
  const HelperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final questions = context.locale == Locale('ru')
        ? questionsRU
        : context.locale == Locale('zh')
            ? questionsZH
            : questionsEN;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(tr(LocaleKeys.settings_help)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList.radio(
              children:
                  questions.map<ExpansionPanelRadio>((HelpModel helpModel) {
                return ExpansionPanelRadio(
                    canTapOnHeader: true,
                    backgroundColor: Theme.of(context).primaryColor,
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
                    text: tr(LocaleKeys.settings_help_other_quest),
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleMedium!
                            .color),
                  ),
                  new TextSpan(
                    text: tr(LocaleKeys.settings_help_other_quest_email),
                    style: new TextStyle(
                        color: Colors.blue[700], fontWeight: FontWeight.bold),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                       sendToSupport();
                      },
                  ),
                  // new TextSpan(
                  //   text: tr(LocaleKeys.settings_help_other_quest_or),
                  //   style: new TextStyle(
                  //       color: Theme.of(context)
                  //           .primaryTextTheme
                  //           .titleMedium!
                  //           .color),
                  // ),
                  // new TextSpan(
                  //   text: "Telegram",
                  //   style: new TextStyle(
                  //       color: Colors.blue[700], fontWeight: FontWeight.bold),
                  //   recognizer: new TapGestureRecognizer()
                  //     ..onTap = () {
                  //       launchUrl(
                  //         Uri.parse("https://t.me/mysongbook01_discussions/8"),
                  //         mode: LaunchMode.externalApplication,
                  //       );
                  //     },
                  // ),
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