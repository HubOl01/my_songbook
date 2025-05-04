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
// import 'package:sqflite/sqflite.dart';

// import '../../generated/locale_keys.g.dart';
// import '../../pages/guitar_songs/works_file.dart';
// import '../data/dbSongs.dart';
// import '../model/groupModel.dart';
// import '../model/songsModel.dart';

// Future<void> restoreBackup(BuildContext context) async {
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
//           context: context,
//           builder: (context) => AlertDialog(
//                   title: Text(tr(LocaleKeys.confirmation_title)),
//                   content: Text(
//                       "${tr(LocaleKeys.confirmation_restore_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_restore_content2)}"),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           isCancel = true;
//                           Get.back();
//                         },
//                         child: Text(tr(LocaleKeys.confirmation_no))),
//                     TextButton(
//                         onPressed: () async {
//                           await deleteAllMp3Files();
//                           Get.back();
//                         },
//                         child: Text(tr(LocaleKeys.confirmation_yes)))
//                   ]));
//     }
//     if (isCancel) {
//       return;
//     }

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

//     // Найти файл базы данных (.db) в распакованной директории
//     final dbFile = unzipDir
//         .listSync(recursive: true)
//         .whereType<File>()
//         .firstWhere(
//           (file) => file.path.endsWith('.db'),
//           orElse: () => throw Exception('Файл базы данных не найден в архиве'),
//         );
//     final dbBackupPath = dbFile.path;

//     // Открываем базу данных из бэкапа
//     final backupDb = await openDatabase(dbBackupPath);
//     final currentDb = DBSongs.instance;
//     await currentDb.deleteAll();
//     await currentDb.deleteAllGroup();

//     // Чтение групп из файла groups.json
//     final groupsFile =
//         unzipDir.listSync(recursive: true).whereType<File>().firstWhere(
//               (file) => file.path.endsWith('groups.json'),
//               orElse: () => File(''), // Возвращаем пустой объект File
//             );

//     final Map<int, int> groupIdMap =
//         {}; // Сопоставление старых ID групп с новыми

//     if (groupsFile.path.isNotEmpty) {
//       print('Файл групп найден: ${groupsFile.path}');
//       final groupsJson = jsonDecode(groupsFile.readAsStringSync()) as List;
//       for (var groupData in groupsJson) {
//         final group = GroupModel.fromJson(groupData);

//         // Проверяем существование группы
//         final existingGroup = await currentDb.findGroupByName(group.name);
//         if (existingGroup != null) {
//           groupIdMap[group.id!] = existingGroup.id!;
//         } else {
//           // Если группы нет, добавляем её и сохраняем новое ID
//           final newGroup = await currentDb.createGroup(group);
//           groupIdMap[group.id!] = newGroup.id!;
//         }
//       }
//     } else {
//       print('Файл groups.json не найден, группы не будут импортированы.');
//     }

//     // Чтение песен из бэкапа
//     final List<Map<String, dynamic>> backupSongs =
//         await backupDb.query(tableSongs); // Таблица с песнями
//     await backupDb.close();

//     // Счетчик для orderSong
//     final Map<int, int> orderCounters = {};

//     for (var songData in backupSongs) {
//       // Создаем копию данных песни для модификации
//       var songDataNew = Map<String, dynamic>.from(songData);

//       final songPath = songData[Songs.path_music] as String?;
//       if (songPath != null && songPath.isNotEmpty) {
//         final fileName = basename(songPath); // Извлекаем только имя файла
//         final matchingFiles = unzipDir.listSync(recursive: true).where((file) {
//           return file is File && basename(file.path) == fileName;
//         });

//         if (matchingFiles.isEmpty) {
//           print('Файл с именем $fileName не найден в архиве');
//           continue;
//         }

//         final originalFile = matchingFiles.first as File;

//         print('Файл найден: ${originalFile.path}');

//         // Копируем музыкальный файл в директорию приложения
//         final newMusicFile = await saveFilePermanently(
//           PlatformFile(
//             path: originalFile.path,
//             name: fileName,
//             size: originalFile.lengthSync(),
//           ),
//         );

//         // Обновляем путь в копии данных песни
//         songDataNew[Songs.path_music] = newMusicFile.path;
//       } else {
//         print("Путь к файлу музыки отсутствует");
//       }

//       // Проверяем наличие группы у песни
//       final oldGroupId = songData[Songs.group] as int?;
//       if (oldGroupId != null &&
//           oldGroupId != 0 &&
//           groupIdMap.containsKey(oldGroupId)) {
//         final newGroupId = groupIdMap[oldGroupId]!;
//         songDataNew[Songs.group] = newGroupId;

//         // Устанавливаем orderSong
//         orderCounters[newGroupId] = (orderCounters[newGroupId] ?? 0) + 1;
//         songDataNew[Songs.order] = orderCounters[newGroupId]!;
//       } else {
//         // Если группы нет, задаем значения по умолчанию
//         songDataNew[Songs.group] = 0;
//         songDataNew[Songs.order] = 0;
//       }

//       // Убираем первичный ключ, чтобы избежать конфликта
//       songDataNew[Songs.id] = null;

//       // Вставляем новую запись в базу данных
//       await currentDb.insertSong(songDataNew);
//     }

//     print('Импорт завершен успешно!');
//     Restart.restartApp();
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//   }
// }

// Future<void> deleteAllMp3Files() async {
//   try {
//     // Получаем путь к директории
//     final appDocsDir = await getApplicationDocumentsDirectory();
//     final directory = Directory(appDocsDir.path);

//     // Получаем список всех файлов в директории и её подпапках
//     final files = directory.listSync(recursive: true);

//     // Отфильтровываем файлы с расширением .mp3
//     final mp3Files = files.whereType<File>().where((file) {
//       return file.path.endsWith('.mp3');
//     });

//     // Удаляем каждый .mp3 файл
//     for (var mp3File in mp3Files) {
//       print('Удаление файла: ${mp3File.path}');
//       await mp3File.delete();
//     }

//     print('Все .mp3 файлы удалены');
//   } catch (e) {
//     print('Ошибка при удалении .mp3 файлов: $e');
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
import 'package:sqflite/sqflite.dart';

import '../../generated/locale_keys.g.dart';
import '../../pages/guitar_songs/works_file.dart';
import '../data/dbSongs.dart';
import '../model/groupModel.dart';
import '../model/songsModel.dart';

// Future<void> restoreBackup(BuildContext context) async {
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
//           "${tr(LocaleKeys.confirmation_restore_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_restore_content2)}",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               isCancel = true;
//               Get.back();
//             },
//             child: Text(tr(LocaleKeys.confirmation_no)),
//           ),
//           TextButton(
//             onPressed: () async {
//               await deleteAllMp3Files();
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
//     final unzipDir = Directory(join(tempDir.path, 'unzip_backup'));
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

//     final dbFile = unzipDir
//         .listSync(recursive: true)
//         .whereType<File>()
//         .firstWhere((file) => file.path.endsWith('.db'),
//             orElse: () => throw Exception('Файл базы данных не найден'));
//     final dbBackupPath = dbFile.path;
//     final backupDb = await openDatabase(dbBackupPath);
//     final currentDb = DBSongs.instance;

//     await currentDb.deleteAll();
//     await currentDb.deleteAllGroup();
//     await currentDb.clearAllSongGroups();

//     final groupsFile = unzipDir
//         .listSync(recursive: true)
//         .whereType<File>()
//         .firstWhere((file) => file.path.endsWith('groups.json'),
//             orElse: () => File(''));

//     final Map<int, int> groupIdMap = {};

//     if (groupsFile.path.isNotEmpty) {
//       final groupsJson = jsonDecode(groupsFile.readAsStringSync()) as List;
//       for (var groupData in groupsJson) {
//         final group = GroupModel.fromJson(groupData);
//         final existingGroup = await currentDb.findGroupByName(group.name);
//         if (existingGroup != null) {
//           groupIdMap[group.id!] = existingGroup.id!;
//         } else {
//           final newGroup = await currentDb.createGroup(group);
//           groupIdMap[group.id!] = newGroup.id!;
//         }
//       }
//     }

//     final List<Map<String, dynamic>> backupSongs =
//         await backupDb.query(tableSongs);
//     final List<Map<String, dynamic>> backupSongGroups =
//         await backupDb.query(tableSongToGroups);
//     await backupDb.close();

//     final Map<int, int> songIdMap = {};

//     for (var songData in backupSongs) {
//       var songDataNew = Map<String, dynamic>.from(songData);

//       final songPath = songData[Songs.path_music] as String?;
//       if (songPath != null && songPath.isNotEmpty) {
//         final fileName = basename(songPath);
//         final matchingFiles = unzipDir
//             .listSync(recursive: true)
//             .where((file) => file is File && basename(file.path) == fileName);
//         if (matchingFiles.isEmpty) continue;

//         final originalFile = matchingFiles.first as File;
//         final newMusicFile = await saveFilePermanently(
//           PlatformFile(
//             path: originalFile.path,
//             name: fileName,
//             size: originalFile.lengthSync(),
//           ),
//         );
//         songDataNew[Songs.path_music] = newMusicFile.path;
//       }

//       songDataNew[Songs.id] = null;
//       final newSongId = await currentDb.insertSong(songDataNew);
//       songIdMap[songData[Songs.id] as int] = newSongId;
//     }

//     for (var sgData in backupSongGroups) {
//       final oldSongId = sgData[SongToGroups.songId] as int;
//       final oldGroupId = sgData[SongToGroups.groupId] as int;
//       final orderId = sgData[SongToGroups.orderId] as int? ?? 0;

//       if (!songIdMap.containsKey(oldSongId)) continue;
//       if (!groupIdMap.containsKey(oldGroupId)) continue;

//       final newSongId = songIdMap[oldSongId]!;
//       final newGroupId = groupIdMap[oldGroupId]!;

//       await currentDb.addSongToGroup(newSongId, newGroupId, orderId);
//     }

//     print('Импорт завершен успешно!');
//     Restart.restartApp();
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//   }
// }

Future<void> deleteAllMp3Files() async {
  try {
    final appDocsDir = await getApplicationDocumentsDirectory();
    final directory = Directory(appDocsDir.path);
    final files = directory.listSync(recursive: true);
    final mp3Files =
        files.whereType<File>().where((file) => file.path.endsWith('.mp3'));
    for (var mp3File in mp3Files) {
      await mp3File.delete();
    }
    print('Все .mp3 файлы удалены');
  } catch (e) {
    print('Ошибка при удалении .mp3 файлов: $e');
  }
}

Future<void> restoreBackup(BuildContext context) async {
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
          "${tr(LocaleKeys.confirmation_restore_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_restore_content2)}",
        ),
        actions: [
          TextButton(
            onPressed: () {
              isCancel = true;
              Get.back();
            },
            child: Text(tr(LocaleKeys.confirmation_no)),
          ),
          TextButton(
            onPressed: () async {
              await deleteAllMp3Files();
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
    final unzipDir = Directory(join(tempDir.path, 'unzip_backup'));
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

    final dbFile = unzipDir
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere((file) => file.path.endsWith('.db'),
            orElse: () => throw Exception('Файл базы данных не найден'));
    final dbBackupPath = dbFile.path;
    final backupDb = await openDatabase(dbBackupPath);
    final currentDb = DBSongs.instance;

    await currentDb.deleteAll();
    await currentDb.deleteAllGroup();
    await currentDb.clearAllSongGroups();

    final groupsFile = unzipDir
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere((file) => file.path.endsWith('groups.json'),
            orElse: () => File(''));

    final songGroupsFile =
        unzipDir.listSync(recursive: true).whereType<File>().firstWhere(
              (file) =>
                  file.path.endsWith('song_to_groups.json') ||
                  file.path.endsWith('song_to_group.json'),
              orElse: () => File(''),
            );

    final Map<int, int> groupIdMap = {};
    if (groupsFile.path.isNotEmpty) {
      final groupsJson = jsonDecode(groupsFile.readAsStringSync()) as List;
      for (var groupData in groupsJson) {
        final group = GroupModel.fromJson(groupData);
        final existingGroup = await currentDb.findGroupByName(group.name);
        if (existingGroup != null) {
          groupIdMap[group.id!] = existingGroup.id!;
        } else {
          final newGroup = await currentDb.createGroup(group);
          groupIdMap[group.id!] = newGroup.id!;
        }
      }
    }

    final List<Map<String, dynamic>> backupSongs =
        await backupDb.query(tableSongs);
    await backupDb.close();

    final List<dynamic> jsonSongToGroups = songGroupsFile.existsSync()
        ? jsonDecode(songGroupsFile.readAsStringSync()) as List
        : [];

    final Map<int, int> songIdMap = {};
    final List<Map<String, dynamic>> pendingManyToManyLinks = [];

    for (var songData in backupSongs) {
      var songDataNew = Map<String, dynamic>.from(songData);

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
      final newSongId = await currentDb.insertSong(songDataNew);
      if (oldId != null) songIdMap[oldId] = newSongId;

      // Если структура старая: group внутри song
      final oldGroupId = songData[Songs.group] as int?;
      final order = songData[Songs.order] as int? ?? 0;
      if (oldGroupId != null &&
          oldGroupId != 0 &&
          groupIdMap.containsKey(oldGroupId)) {
        pendingManyToManyLinks.add({
          'song_id': oldId,
          'group_id': oldGroupId,
          'order_id': order,
        });
      }
    }

    // Объединяем старые связи и новые JSON связи
    final List<Map<String, dynamic>> allSongGroupLinks = [
      ...pendingManyToManyLinks,
      ...jsonSongToGroups.cast<Map<String, dynamic>>(),
    ];

    for (var sgData in allSongGroupLinks) {
      final oldSongId = sgData['song_id'] as int?;
      final oldGroupId = sgData['group_id'] as int?;
      final order = sgData['order_id'] as int? ?? 0;

      if (oldSongId != null &&
          oldGroupId != null &&
          songIdMap.containsKey(oldSongId) &&
          groupIdMap.containsKey(oldGroupId)) {
        final newSongId = songIdMap[oldSongId]!;
        final newGroupId = groupIdMap[oldGroupId]!;
        await currentDb.addSongToGroup(newSongId, newGroupId, order);
      }
    }

    print('Импорт завершен успешно!');
    Restart.restartApp();
  } catch (e) {
    print('Ошибка при импорте данных: $e');
  }
}
