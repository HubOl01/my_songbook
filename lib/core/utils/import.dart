import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_songbook/core/data/dbSongs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:sqflite/sqflite.dart';

import '../../generated/locale_keys.g.dart';
import '../../pages/guitar_songs/works_file.dart';
import '../model/groupModel.dart';
import '../model/songsModel.dart';

// Future<void> importBackup(BuildContext context) async {
//   try {
//     // Выбор ZIP-файла
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     if (result == null || result.files.single.path == null) {
//       print('Файл не выбран');
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

//     // Чтение групп из файла groups.json
//     final groupsFile =
//         unzipDir.listSync(recursive: true).whereType<File>().firstWhere(
//               (file) => file.path.endsWith('groups.json'),
//               orElse: () => File(''), // Возвращаем пустой объект File
//             );

//     final Map<int, int> groupIdMap =
//         {}; // Сопоставление старых ID групп с новыми

//     if (groupsFile.path.isEmpty) {
//       print('Файл groups.json не найден в архиве');
//     } else {
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

//       // Обновляем группу, если она есть
//       final oldGroupId = songData[Songs.group] as int?;
//       if (oldGroupId != null && groupIdMap.containsKey(oldGroupId)) {
//         final newGroupId = groupIdMap[oldGroupId];
//         songDataNew[Songs.group] = newGroupId;

//         // Устанавливаем orderSong
//         orderCounters[newGroupId!] = (orderCounters[newGroupId] ?? 0) + 1;
//         songDataNew[Songs.order] = orderCounters[newGroupId];
//       } else {
//         songDataNew[Songs.group] = null; // Если группа не найдена
//       }

//       // Убираем первичный ключ, чтобы избежать конфликта
//       songDataNew[Songs.id] = null;

//       // Вставляем новую запись в базу данных
//       await currentDb.insertSong(songDataNew);
//     }

//     print('Импорт завершен успешно!');
//     ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Импорт завершен успешно!")));
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text("Ошибка при импорте данных: $e")));
//   }
// }
//--------
// Future<void> importBackup(BuildContext context) async {
//   try {
//     // Выбор ZIP-файла
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['zip'],
//     );

//     if (result == null || result.files.single.path == null) {
//       print('Файл не выбран');
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
//       if (oldGroupId != null && oldGroupId != 0) {
//         songDataNew[Songs.group] = oldGroupId;
//         orderCounters[oldGroupId] = (orderCounters[oldGroupId] ?? 0) + 1;
//         songDataNew[Songs.order] = orderCounters[oldGroupId]!;
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
//     // ScaffoldMessenger.of(context).showSnackBar(
//     //     const SnackBar(content: Text("Импорт завершен успешно!")));
//     Restart.restartApp();
//   } catch (e) {
//     print('Ошибка при импорте данных: $e');
//     // ScaffoldMessenger.of(context)
//     //     .showSnackBar(SnackBar(content: Text("Ошибка при импорте данных: $e")));
//   }
// }
//-------------------------------------------

Future<void> importSongs(BuildContext context) async {
  try {
    // Выбор ZIP-файла
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    bool isCancel = false;
    if (result == null || result.files.single.path == null) {
      print('Файл не выбран');
      return;
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(tr(LocaleKeys.confirmation_title)),
          content: Text(
              "${tr(LocaleKeys.confirmation_import_content1)} ${result.files.first.name}${tr(LocaleKeys.confirmation_import_content2)}"),
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
    }
    if (isCancel) return;

    // Путь к выбранному ZIP-файлу
    final zipFilePath = result.files.single.path!;
    final zipFile = File(zipFilePath);

    if (!zipFile.existsSync()) {
      print('Выбранный файл не существует');
      return;
    }

    // Распаковка ZIP-файла
    final tempDir = await getTemporaryDirectory();
    final unzipDir = Directory(join(tempDir.path, 'unzip_backup'));
    if (!unzipDir.existsSync()) {
      unzipDir.createSync(recursive: true);
    }

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

    // Чтение songs.json из архива
    final songsFile = unzipDir
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere(
          (file) => file.path.endsWith('songs.json'),
          orElse: () => throw Exception('Файл songs.json не найден в архиве'),
        );

    final songsJson = jsonDecode(songsFile.readAsStringSync()) as List;

    final currentDb = DBSongs.instance;

    for (var songData in songsJson) {
      // Преобразование данных песни
      var songDataNew = Map<String, dynamic>.from(songData);

      // Обработка аудиофайлов
      final songPath = songData[Songs.path_music] as String?;
      if (songPath != null && songPath.isNotEmpty) {
        final fileName = basename(songPath);
        final matchingFiles = unzipDir.listSync(recursive: true).where((file) {
          return file is File && basename(file.path) == fileName;
        });

        if (matchingFiles.isEmpty) {
          print('Файл с именем $fileName не найден в архиве');
          continue;
        }

        final originalFile = matchingFiles.first as File;

        // Копируем аудиофайл в постоянное хранилище
        final newMusicFile = await saveFilePermanently(
          PlatformFile(
            path: originalFile.path,
            name: fileName,
            size: originalFile.lengthSync(),
          ),
        );

        songDataNew[Songs.path_music] = newMusicFile.path;
      } else {
        print("Путь к файлу музыки отсутствует");
      }

      // Установка groupSong в 0, если группа не указана
      songDataNew[Songs.group] = 0;

      // Удаление ID для предотвращения конфликтов
      songDataNew[Songs.id] = null;

      // Вставка песни в базу данных
      await currentDb.insertSong(songDataNew);
    }

    print('Импорт завершен успешно!');
    Restart.restartApp();
  } catch (e) {
    print('Ошибка при импорте данных: $e');
  }
}
