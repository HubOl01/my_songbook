import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:my_songbook/generated/locale_keys.g.dart';
import 'package:my_songbook/core/styles/colors.dart';
import 'package:restart_app/restart_app.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({super.key});

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late String currentLanguage;

  @override
  Widget build(BuildContext context) {
    currentLanguage = context.locale.toString();
    print("context.locale ${context.locale}");

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(LocaleKeys.settings_translate)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Material(
              color: Theme.of(context).primaryColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                LabeledRadio(
                    label: "Русский",
                    groupValue: currentLanguage,
                    value: language(0, context),
                    onChanged: (value) async {
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(context
                                  .tr(LocaleKeys.alertDialogWarningTitle)),
                              content: Text(context
                                  .tr(LocaleKeys.alertDialogWarningContent)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      AppMetrica.reportEvent(
                                          'TranslatePage: Русский');
                                      setState(() {
                                        currentLanguage = value;
                                        context.setLocale(Locale(value));
                                      });
                                      Restart.restartApp();
                                      // exit(0);
                                    },
                                    child: Text(context
                                        .tr(LocaleKeys.alertDialogWarningExit)))
                              ],
                            );
                          });
                    }),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 2.5,
                    height: 0,
                  ),
                ),
                LabeledRadio(
                  label: "English",
                  groupValue: currentLanguage,
                  value: language(1, context),
                  onChanged: (value) async {
                    await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                context.tr(LocaleKeys.alertDialogWarningTitle)),
                            content: Text(context
                                .tr(LocaleKeys.alertDialogWarningContent)),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    AppMetrica.reportEvent(
                                        'TranslatePage: English');
                                    setState(() {
                                      currentLanguage = value;
                                      context.setLocale(Locale(value));
                                    });
                                    Restart.restartApp();
                                    // exit(0);
                                  },
                                  child: Text(context
                                      .tr(LocaleKeys.alertDialogWarningExit)))
                            ],
                          );
                        });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Divider(
                    thickness: 2.5,
                    height: 0,
                  ),
                ),
                LabeledRadio(
                    label: "中文 (experimental)",
                    groupValue: currentLanguage,
                    value: language(2, context),
                    onChanged: (value) async {
                      await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(context
                                  .tr(LocaleKeys.alertDialogWarningTitle)),
                              content: Text(context
                                  .tr(LocaleKeys.alertDialogWarningContent)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      AppMetrica.reportEvent(
                                          'TranslatePage: 中文 (experimental)');
                                      setState(() {
                                        currentLanguage = value;
                                        context.setLocale(Locale(value));
                                      });
                                      Restart.restartApp();
                                      // exit(0);
                                    },
                                    child: Text(context
                                        .tr(LocaleKeys.alertDialogWarningExit)))
                              ],
                            );
                          });
                    }),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  String language(int isLanguage, BuildContext context) {
    var language = const Locale('en').languageCode;
    switch (isLanguage) {
      case 0:
        language = const Locale('ru').languageCode;
        break;
      case 1:
        language = const Locale('en').languageCode;
        break;
      default:
        language = const Locale('zh').languageCode;
        break;
    }
    return language;
  }
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio(
      {required this.label,
      required this.groupValue,
      required this.value,
      required this.onChanged,
      super.key});
  final String label;
  final dynamic groupValue;
  final dynamic value;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      title: Text(label),
      trailing: Radio(
          fillColor: WidgetStateColor.resolveWith((states) => colorFiolet),
          focusColor: WidgetStateColor.resolveWith((states) => colorFiolet),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged),
    );
  }
}
