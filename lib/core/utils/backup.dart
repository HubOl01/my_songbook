import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../../generated/locale_keys.g.dart';
import '../data/dbSongs.dart';

// Future<void> createBackup(BuildContext context) async {
//   // Запрашиваем разрешения
//   await Permission.manageExternalStorage.request();
//   await Permission.audio.request();
//   if (await Permission.manageExternalStorage.request().isGranted ||
//       await Permission.storage.request().isGranted) {
//     try {
//       final db = DBSongs.instance;

//       // Получаем путь к базе данных
//       final dbPath = await getDatabasesPath();
//       final dbFile = File(join(dbPath, 'songs.db'));

//       // Создаем временный каталог для резервной копии
//       final tempDir = await getTemporaryDirectory();
//       final backupDir = Directory(join(tempDir.path, 'backup'));
//       if (!backupDir.existsSync()) {
//         backupDir.createSync();
//       }

//       // Копируем файл базы данных
//       final dbBackupPath = join(backupDir.path, 'songs_backup.db');
//       await dbFile.copy(dbBackupPath);

//       // Получаем все песни с их путями
//       final songs = await db.readAllSongs();
//       for (final song in songs) {
//         if (song.path_music != null && song.path_music!.isNotEmpty) {
//           final musicFile = File(song.path_music!);
//           if (musicFile.existsSync()) {
//             final musicBackupPath =
//                 join(backupDir.path, basename(song.path_music!));
//             await musicFile.copy(musicBackupPath);
//           }
//         }
//       }

//       // **Добавление данных о группах в резервную копию**
//       final groups = await db.readAllGroups(); // Реализуйте метод readAllGroups
//       final groupsJson = groups.map((group) => group.toJson()).toList();
//       final groupsFilePath = join(backupDir.path, 'groups.json');
//       final groupsFile = File(groupsFilePath);
//       groupsFile.writeAsStringSync(jsonEncode(groupsJson));

//       // Указываем путь для сохранения ZIP-архива
//       final downloadsDir = Directory('/storage/emulated/0/Download');
//       if (!downloadsDir.existsSync()) {
//         throw Exception("Папка загрузок недоступна");
//       }

//       // Проверяем существование ZIP-файла и добавляем нумерацию
//       String zipFilePath = join(downloadsDir.path, 'songs_backup.zip');
//       int counter = 1;
//       while (File(zipFilePath).existsSync()) {
//         zipFilePath = join(downloadsDir.path, 'songs_backup_$counter.zip');
//         counter++;
//       }

//       // Создаем ZIP-архив
//       final encoder = ZipFileEncoder();
//       encoder.create(zipFilePath);
//       encoder.addDirectory(backupDir);
//       encoder.close();

//       // Отправляем файл через Share
//       await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                   title: Text(tr(LocaleKeys.confirmation_title)),
//                   content: Text(tr(LocaleKeys.confirmation_content_backup)),
//                   actions: [
//                     TextButton(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         child: Text(tr(LocaleKeys.confirmation_no))),
//                     TextButton(
//                         onPressed: () async {
//                           Get.back();
//                           await Share.shareXFiles([XFile(zipFilePath)]);
//                         },
//                         child: Text(tr(LocaleKeys.confirmation_yes)))
//                   ]));

//       print('Backup создан и сохранен по пути: $zipFilePath');
//     } catch (e) {
//       print('Ошибка при создании резервной копии: $e');
//     }
//   } else {
//     print('Разрешение на доступ к хранилищу отклонено');
//   }
// }

Future<void> createBackup(BuildContext context) async {
  // Запрашиваем разрешения
  await Permission.manageExternalStorage.request();
  await Permission.audio.request();
  if (await Permission.manageExternalStorage.request().isGranted ||
      await Permission.storage.request().isGranted) {
    try {
      final db = DBSongs.instance;

      // Получаем путь к базе данных
      final dbPath = await getDatabasesPath();
      final dbFile = File(join(dbPath, 'songs.db'));

      // Создаем временный каталог для резервной копии
      final tempDir = await getTemporaryDirectory();
      final backupDir = Directory(join(tempDir.path, 'backup'));
      if (!backupDir.existsSync()) {
        backupDir.createSync();
      }

      // Копируем файл базы данных
      final dbBackupPath = join(backupDir.path, 'songs_backup.db');
      await dbFile.copy(dbBackupPath);

      // Копируем музыкальные файлы
      final songs = await db.readAllSongs();
      for (final song in songs) {
        if (song.path_music != null && song.path_music!.isNotEmpty) {
          final musicFile = File(song.path_music!);
          if (musicFile.existsSync()) {
            final musicBackupPath =
                join(backupDir.path, basename(song.path_music!));
            await musicFile.copy(musicBackupPath);
          }
        }
      }

      // Сохраняем данные групп
      final groups = await db.readAllGroups();
      final groupsJson = groups.map((group) => group.toJson()).toList();
      File(join(backupDir.path, 'groups.json'))
          .writeAsStringSync(jsonEncode(groupsJson));

      // Сохраняем данные связей песен и групп
      final songGroups = await db.getSongsGroup(); // many-to-many связи
      final songGroupsJson = songGroups.map((sg) => sg.toJson()).toList();
      File(join(backupDir.path, 'song_to_group.json'))
          .writeAsStringSync(jsonEncode(songGroupsJson));

      // Создание ZIP-архива
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        throw Exception("Папка загрузок недоступна");
      }

      String zipFilePath = join(downloadsDir.path, 'songs_backup.zip');
      int counter = 1;
      while (File(zipFilePath).existsSync()) {
        zipFilePath = join(downloadsDir.path, 'songs_backup_$counter.zip');
        counter++;
      }

      final encoder = ZipFileEncoder();
      encoder.create(zipFilePath);
      encoder.addDirectory(backupDir);
      encoder.close();

      // Показываем диалог с предложением отправить архив
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(tr(LocaleKeys.confirmation_title)),
          content: Text(tr(LocaleKeys.confirmation_content_backup)),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(tr(LocaleKeys.confirmation_no)),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await Share.shareXFiles([XFile(zipFilePath)]);
              },
              child: Text(tr(LocaleKeys.confirmation_yes)),
            ),
          ],
        ),
      );

      print('Backup создан и сохранен по пути: $zipFilePath');
    } catch (e) {
      print('Ошибка при создании резервной копии: $e');
    }
  } else {
    print('Разрешение на доступ к хранилищу отклонено');
  }
}
