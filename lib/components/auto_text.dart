// import 'package:flutter/material.dart';
// import 'package:my_songbook/generated/locale_keys.g.dart';

// void autotext(String name) {
//     if (name.contains(" - ")) {
//       List<String> words = name.split(' - ');
//       String nameSinger = words[0];
//       String nameSong = words[1];
//       if (nameSong.contains(".mp3")) {
//         nameSong = words[1].replaceAll(".mp3", "");
//         if (nameSong.contains("-")) {
//           nameSong = words[1].replaceAll("-", " ");
//         }
//       }
//       if (nameSong.contains(".m4a")) {
//         nameSong = words[1].replaceAll(".m4a", "");
//         if (nameSong.contains("-")) {
//           nameSong = words[1].replaceAll("-", " ");
//         }
//       }
//       setState(() {
//         if (name_songController.text.trim().isNotEmpty ||
//             name_singerController.text.trim().isNotEmpty) {
//            showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     title: Text(context.tr(LocaleKeys.confirmation_title)),
//                     content: Text(
//                         context.tr(LocaleKeys.add_song_confirmation_content)),
//                     actions: [
//                       TextButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: Text(context.tr(LocaleKeys.confirmation_no))),
//                       TextButton(
//                           onPressed: () {
//                             setState(() {
//                               name_songController.text = nameSong;
//                               name_singerController.text = nameSinger;
//                             });
//                             Get.back();
//                           },
//                           child: Text(context.tr(LocaleKeys.confirmation_yes)))
//                     ],
//                   ));
//         } else {
//           name_songController.text = nameSong;
//           name_singerController.text = nameSinger;
//         }
//       });
//     } else {
//       String nameSong = name;
//       if (nameSong.contains(".mp3")) {
//         nameSong = nameSong.replaceAll(".mp3", "");
//         if (nameSong.contains("-")) {
//           nameSong = nameSong.replaceAll("-", " ");
//         }
//       }
//       if (nameSong.contains(".m4a")) {
//         nameSong = nameSong.replaceAll(".m4a", "");
//         if (nameSong.contains("-")) {
//           nameSong = nameSong.replaceAll("-", " ");
//         }
//       }
//       setState(() {
//         if (name_songController.text.trim().isNotEmpty ||
//             name_singerController.text.trim().isNotEmpty) {
//           showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                     title: Text(context.tr(LocaleKeys.confirmation_title)),
//                     content: Text(
//                         context.tr(LocaleKeys.add_song_confirmation_content)),
//                     actions: [
//                       TextButton(
//                           onPressed: () {
//                             Get.back();
//                           },
//                           child: Text(context.tr(LocaleKeys.confirmation_no))),
//                       TextButton(
//                           onPressed: () {
//                             setState(() {
//                               name_songController.text = nameSong;
//                             });
//                             Get.back();
//                           },
//                           child: Text(context.tr(LocaleKeys.confirmation_yes)))
//                     ],
//                   ));
//         } else {
//           name_songController.text = nameSong;
//         }
//       });
//       // name_singerController.text = nameSinger;
//     }
//   }