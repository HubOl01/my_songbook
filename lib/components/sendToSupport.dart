import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

// Future sendToSupport() async {
//   AppMetrica.reportEvent('TechSupportPage');
//   final Email email = Email(
//     body: "",
//     subject: "My Songbook (Tech Support)",
//     recipients: ["ru-developer@mail.ru"],
//     isHTML: true,
//   );

//   String platformResponse;

//   try {
//     await FlutterEmailSender.send(email);
//     platformResponse = 'success';
//   } catch (error) {
//     print(error);
//     platformResponse = error.toString();
//   }
//   print(platformResponse);
// }

Future sendToSupport(BuildContext context) async {
  final Email email = Email(
    body: "",
    subject: "My Songbook (Tech Support)",
    recipients: ["ru-developer@mail.ru"],
    isHTML: true,
  );

  String platformResponse;

  try {
    if (context.mounted &&
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } else {
      platformResponse = "Приложение не активно. Отправка почты невозможна.";
    }
  } on Exception catch (e) {
    platformResponse =
        "Нет приложений для отправки почты. Убедитесь, что на устройстве установлено приложение для работы с электронной почтой.";
    print("Error: $e");
  }

  print(platformResponse);
}
