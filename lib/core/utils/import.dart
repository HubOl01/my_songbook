// import 'dart:convert';
// import 'dart:io';
// import 'package:archive/archive_io.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:restart_app/restart_app.dart';

// import '../../generated/locale_keys.g.dart';
// import '../../pages/guitar_songs/works_file.dart';
// import '../data/dbSongs.dart';
// import '../model/songsModel.dart';

// Future<void> importSongs(BuildContext context) async {
//   try {
//     // Выбор ZIP-файла
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     bool isCancel = false;
//     if (result == null || result.files.single.path == null) {
//       print('Файл не выбран');
//       return;
//     } else {
//       await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(tr(LocaleKeys.confirmation_title)),
//           content: Text(
//               "${tr(LocaleKeys.confirmation_import_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_import_contentSong2)}"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 isCancel = true;
//                 Get.back();
//               },
//               child: Text(tr(LocaleKeys.confirmation_no)),
//             ),
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text(tr(LocaleKeys.confirmation_yes)),
//             ),
//           ],
//         ),
//       );
//     }
//     if (isCancel) return;

//     // Путь к выбранному ZIP-файлу
//     final zipFilePath = result.files.single.path!;
//     final zipFile = File(zipFilePath);

//     if (!zipFile.existsSync()) {
//       print('Выбранный файл не существует');
//       return;
//     }

//     // Распаковка ZIP-файла
//     final tempDir = await getTemporaryDirectory();
//     final unzipDir = Directory(join(tempDir.path, 'unzip_backup'));
//     if (!unzipDir.existsSync()) {
//       unzipDir.createSync(recursive: true);
//     }

//     final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
//     for (final file in archive) {
//       final filePath = join(unzipDir.path, file.name);
//       if (file.isFile) {
//         File(filePath)
//           ..createSync(recursive: true)
//           ..writeAsBytesSync(file.content as List<int>);
//       } else {
//         Directory(filePath).createSync(recursive: true);
//       }
//     }

//     // Чтение songs.json из архива
//     final songsFile = unzipDir
//         .listSync(recursive: true)
//         .whereType<File>()
//         .firstWhere(
//           (file) => file.path.endsWith('songs.json'),
//           orElse: () => throw Exception('Файл songs.json не найден в архиве'),
//         );

//     final songsJson = jsonDecode(songsFile.readAsStringSync()) as List;

//     final currentDb = DBSongs.instance;

//     for (var songData in songsJson) {
//       // Преобразование данных песни
//       var songDataNew = Map<String, dynamic>.from(songData);

//       // Обработка аудиофайлов
//       final songPath = songData[Songs.path_music] as String?;
//       if (songPath != null && songPath.isNotEmpty) {
//         final fileName = basename(songPath);
//         final matchingFiles = unzipDir.listSync(recursive: true).where((file) {
//           return file is File && basename(file.path) == fileName;
//         });

//         if (matchingFiles.isEmpty) {
//           print('Файл с именем $fileName не найден в архиве');
//           continue;
//         }

//         final originalFile = matchingFiles.first as File;

//         // Копируем аудиофайл в постоянное хранилище
//         final newMusicFile = await saveFilePermanently(
//           PlatformFile(
//             path: originalFile.path,
//             name: fileName,
//             size: originalFile.lengthSync(),
//           ),
//         );

//         songDataNew[Songs.path_music] = newMusicFile.path;
//       } else {
//         print("Путь к файлу музыки отсутствует");
//       }

//       // Установка groupSong в 0, если группа не указана
//       songDataNew[Songs.group] = 0;

//       // Удаление ID для предотвращения конфликтов
//       songDataNew[Songs.id] = null;

//       // Вставка песни в базу данных
//       await currentDb.insertSong(songDataNew);
//     }

//     print('Импорт завершен успешно!');
//     Restart.restartApp();
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';

import '../../generated/locale_keys.g.dart';
import '../../pages/guitar_songs/works_file.dart';
import '../data/dbSongs.dart';
import '../model/songsModel.dart';

// Future<void> importSongs(BuildContext context) async {
//   try {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     bool isCancel = false;
//     if (result == null || result.files.single.path == null) return;

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(tr(LocaleKeys.confirmation_title)),
//         content: Text(
//             "${tr(LocaleKeys.confirmation_import_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_import_contentSong2)}"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               isCancel = true;
//               Get.back();
//             },
//             child: Text(tr(LocaleKeys.confirmation_no)),
//           ),
//           TextButton(
//             onPressed: () {
//               Get.back();
//             },
//             child: Text(tr(LocaleKeys.confirmation_yes)),
//           ),
//         ],
//       ),
//     );
//     if (isCancel) return;

//     final zipFilePath = result.files.single.path!;
//     final zipFile = File(zipFilePath);
//     if (!zipFile.existsSync()) return;

//     final tempDir = await getTemporaryDirectory();
//     final unzipDir = Directory(join(tempDir.path, 'unzip_import'));
//     if (!unzipDir.existsSync()) unzipDir.createSync(recursive: true);

//     final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
//     for (final file in archive) {
//       final filePath = join(unzipDir.path, file.name);
//       if (file.isFile) {
//         File(filePath)
//           ..createSync(recursive: true)
//           ..writeAsBytesSync(file.content as List<int>);
//       } else {
//         Directory(filePath).createSync(recursive: true);
//       }
//     }

//     final songsFile = unzipDir
//         .listSync(recursive: true)
//         .whereType<File>()
//         .firstWhere(
//           (file) => file.path.endsWith('songs.json'),
//           orElse: () => throw Exception('Файл songs.json не найден в архиве'),
//         );

//     final songGroupsFile =
//         unzipDir.listSync(recursive: true).whereType<File>().firstWhere(
//               (file) => file.path.endsWith('song_to_group.json'),
//               orElse: () => File(''),
//             );

//     final songsJson = jsonDecode(songsFile.readAsStringSync()) as List;
//     final songGroupsJson = songGroupsFile.existsSync()
//         ? jsonDecode(songGroupsFile.readAsStringSync()) as List
//         : [];

//     final currentDb = DBSongs.instance;
//     final Map<int, int> songIdMap = {};

//     for (var songData in songsJson) {
//       var songDataNew = Map<String, dynamic>.from(songData);

//       final songPath = songData[Songs.path_music] as String?;
//       if (songPath != null && songPath.isNotEmpty) {
//         final fileName = basename(songPath);
//         final matchingFiles = unzipDir
//             .listSync(recursive: true)
//             .where((file) => file is File && basename(file.path) == fileName);
//         if (matchingFiles.isNotEmpty) {
//           final originalFile = matchingFiles.first as File;
//           final newMusicFile = await saveFilePermanently(
//             PlatformFile(
//               path: originalFile.path,
//               name: fileName,
//               size: originalFile.lengthSync(),
//             ),
//           );
//           songDataNew[Songs.path_music] = newMusicFile.path;
//         }
//       }

//       songDataNew[Songs.id] = null;
//       final newId = await currentDb.insertSong(songDataNew);
//       final oldId = songData[Songs.id] as int?;
//       if (oldId != null) songIdMap[oldId] = newId;
//     }

//     for (var sg in songGroupsJson) {
//       final oldSongId = sg['song_id'] as int?;
//       final groupId = sg['group_id'] as int?;
//       final order = sg['order_id'] as int? ?? 0;

//       if (oldSongId != null &&
//           groupId != null &&
//           songIdMap.containsKey(oldSongId)) {
//         final newSongId = songIdMap[oldSongId]!;
//         await currentDb.addSongToGroup(newSongId, groupId, order);
//       }
//     }

//     print('Импорт завершен успешно!');
//     Restart.restartApp();
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//   }
// }

Future<void> importSongs(BuildContext context) async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    bool isCancel = false;
    if (result == null || result.files.single.path == null) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr(LocaleKeys.confirmation_title)),
        content: Text(
            "${tr(LocaleKeys.confirmation_import_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_import_contentSong2)}"),
        actions: [
          TextButton(
            onPressed: () {
              isCancel = true;
              Get.back();
            },
            child: Text(tr(LocaleKeys.confirmation_no)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(tr(LocaleKeys.confirmation_yes)),
          ),
        ],
      ),
    );
    if (isCancel) return;

    final zipFilePath = result.files.single.path!;
    final zipFile = File(zipFilePath);
    if (!zipFile.existsSync()) return;

    final tempDir = await getTemporaryDirectory();
    final unzipDir = Directory(join(tempDir.path, 'unzip_import'));
    if (!unzipDir.existsSync()) unzipDir.createSync(recursive: true);

    final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
    for (final file in archive) {
      final filePath = join(unzipDir.path, file.name);
      if (file.isFile) {
        File(filePath)
          ..createSync(recursive: true)
          ..writeAsBytesSync(file.content as List<int>);
      } else {
        Directory(filePath).createSync(recursive: true);
      }
    }

    final songsFile = unzipDir
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere(
          (file) => file.path.endsWith('songs.json'),
          orElse: () => throw Exception('Файл songs.json не найден в архиве'),
        );

    final songGroupsFile =
        unzipDir.listSync(recursive: true).whereType<File>().firstWhere(
              (file) =>
                  file.path.endsWith('song_to_group.json') ||
                  file.path.endsWith('song_to_groups.json'),
              orElse: () => File(''),
            );

    final songsJson = jsonDecode(songsFile.readAsStringSync()) as List;
    final songGroupsJson = songGroupsFile.existsSync()
        ? jsonDecode(songGroupsFile.readAsStringSync()) as List
        : [];

    final currentDb = DBSongs.instance;
    final Map<int, int> songIdMap = {};

    for (var songData in songsJson) {
      final songDataNew = Map<String, dynamic>.from(songData);

      final songPath = songData[Songs.path_music] as String?;
      if (songPath != null && songPath.isNotEmpty) {
        final fileName = basename(songPath);
        final matchingFiles = unzipDir
            .listSync(recursive: true)
            .where((file) => file is File && basename(file.path) == fileName);
        if (matchingFiles.isNotEmpty) {
          final originalFile = matchingFiles.first as File;
          final newMusicFile = await saveFilePermanently(
            PlatformFile(
              path: originalFile.path,
              name: fileName,
              size: originalFile.lengthSync(),
            ),
          );
          songDataNew[Songs.path_music] = newMusicFile.path;
        }
      }

      final oldId = songData[Songs.id] as int?;
      songDataNew[Songs.id] = null;

      final newId = await currentDb.insertSong(songDataNew);
      if (oldId != null) songIdMap[oldId] = newId;

      // ✅ Если songGroupsJson отсутствует, пробуем взять старые поля
      final oldGroupId = songData[Songs.group] as int?;
      final oldOrder = songData[Songs.order] as int?;
      if (songGroupsJson.isEmpty && oldGroupId != null && oldGroupId != 0) {
        await currentDb.addSongToGroup(newId, oldGroupId, oldOrder ?? 0);
      }
    }

    for (var sg in songGroupsJson) {
      final oldSongId = sg['song_id'] as int?;
      final groupId = sg['group_id'] as int?;
      final order = sg['order_id'] as int? ?? 0;

      if (oldSongId != null &&
          groupId != null &&
          songIdMap.containsKey(oldSongId)) {
        final newSongId = songIdMap[oldSongId]!;
        await currentDb.addSongToGroup(newSongId, groupId, order);
      }
    }

    print('Импорт завершён успешно!');
    Restart.restartApp();
  } catch (e) {
    print('Ошибка при импорте данных: $e');
  }
}
