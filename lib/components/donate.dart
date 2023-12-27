// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Donate extends StatelessWidget {
//   const Donate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Поддержать")),
//       body: ListView(
//         children: [
//           Text(
//               "Если вам нравится наше приложение и вы хотите помочь в его развитии, мы будем благодарны за вашу поддержку донатом. Ваш вклад позволит нам улучшать приложение и добавлять новые функции для вашего удобства. Спасибо за доверие и поддержку!"),
//           ListTile(
//             title: Text("По номеру телефона"),
//             onTap: () => Clipboard.setData(ClipboardData(text: "+79203719147")),
//             trailing: IconButton(
//               icon: Icon(Icons.copy),
//               onPressed: () =>
//                   Clipboard.setData(ClipboardData(text: "+79203719147")),
//             ),
//           ),
//           ListTile(
//             title: Text("Tinkoff"),
//             onTap: () =>
//                 launchUrl(Uri.parse('https://www.tinkoff.ru/cf/2O2HcA74XJl')),
//           ),
//         ],
//       ),
//     );
//   }
// }
