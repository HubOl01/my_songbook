// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../generated/locale_keys.g.dart';

// class TechSupportPage extends StatelessWidget {
//   const TechSupportPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(tr(LocaleKeys.appbar_settings_call_tech)),
//       ),
//       body: ListView(
//           padding: EdgeInsets.all(0),
//           physics: BouncingScrollPhysics(),
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Center(
//                   child: Text(
//                 tr(LocaleKeys.settings_call_tech_text),
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               )),
//             ),
//             // Divider(),
//             ListTile(
//               title: Text(tr(LocaleKeys.settings_call_tech_personally)),
//               // onTap: () {
//               //   launchUrl(
//               //     Uri.parse("https://vk.com/im?media=&sel=-222084855"),
//               //     mode: LaunchMode.externalApplication,
//               //   );
//               // },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       launchUrl(
//                         Uri.parse("https://vk.com/im?media=&sel=-222084855"),
//                         mode: LaunchMode.externalApplication,
//                       );
//                     },
//                     icon: Logo(
//                       Logos.vk,
//                       // size: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       launchUrl(
//                         Uri.parse("https://t.me/foward01"),
//                         mode: LaunchMode.externalApplication,
//                       );
//                     },
//                     icon: Logo(
//                       Logos.telegram,
//                       // size: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   IconButton(
//                       onPressed: () async {
//                           final Email email = Email(
//                             body: "",
//                             subject: "My Songbook (Tech Support)",
//                             recipients: ["ru-developer@mail.ru"],
//                             isHTML: true,
//                           );

//                           String platformResponse;

//                           try {
//                             await FlutterEmailSender.send(email);
//                             platformResponse = 'success';
//                           } catch (error) {
//                             print(error);
//                             platformResponse = error.toString();
//                           }

//                           // if (!mounted) return;
//                           print(platformResponse);
//                           // ScaffoldMessenger.of(context).showSnackBar(
//                           //   SnackBar(
//                           //     content: Text(platformResponse),
//                           //   ),
//                           // );
//                       },
//                       icon: Icon(Icons.email_outlined)),
//                 ],
//               ),
//             ),
//             // Divider(),
//             ListTile(
//               title: Text(tr(LocaleKeys.settings_call_tech_discussions)),
//               // onTap: () {
//               //   launchUrl(
//               //     Uri.parse("https://vk.com/topic-222084855_49405611"),
//               //     mode: LaunchMode.externalApplication,
//               //   );
//               // },
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       launchUrl(
//                         Uri.parse("https://vk.com/topic-222084855_49405611"),
//                         mode: LaunchMode.externalApplication,
//                       );
//                     },
//                     icon: Logo(
//                       Logos.vk,
//                       // size: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       launchUrl(
//                         Uri.parse("https://t.me/mysongbook01_discussions/5"),
//                         mode: LaunchMode.externalApplication,
//                       );
//                     },
//                     icon: Logo(
//                       Logos.telegram,
//                       // size: 30,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // Divider(),
//           ]),
//     );
//   }
// }
