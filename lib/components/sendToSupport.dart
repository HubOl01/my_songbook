import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

Future sendToSupport() async {
  AppMetrica.reportEvent('TechSupportPage');
  final Email email = Email(
    body: "",
    subject: "My Songbook (Tech Support)",
    recipients: ["ru-developer@mail.ru"],
    isHTML: true,
  );

  String platformResponse;

  try {
    await FlutterEmailSender.send(email);
    platformResponse = 'success';
  } catch (error) {
    print(error);
    platformResponse = error.toString();
  }
  print(platformResponse);
}
