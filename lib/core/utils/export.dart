import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../model/songsModel.dart';

Future<void> createExport(
    BuildContext context, List<Song> selectedSongs) async {
  // Запрашиваем разрешения
  await Permission.manageExternalStorage.request();
  await Permission.audio.request();

  if (await Permission.audio.request().isGranted ||
      await Permission.manageExternalStorage.request().isGranted ||
      await Permission.storage.request().isGranted) {
    try {
      // Создаем временный каталог для резервной копии
      final tempDir = await getTemporaryDirectory();
      final backupDir = Directory(join(tempDir.path, 'export'));
      if (!backupDir.existsSync()) {
        backupDir.createSync();
      }

      // **Создание JSON-файла с выбранными песнями**
      final songsJson = selectedSongs.map((song) => song.toJson()).toList();
      final songsFilePath = join(backupDir.path, 'selected_songs.json');
      final songsFile = File(songsFilePath);
      songsFile.writeAsStringSync(jsonEncode(songsJson));

      // **Копирование аудиофайлов**
      for (final song in selectedSongs) {
        if (song.path_music != null && song.path_music!.isNotEmpty) {
          final musicFile = File(song.path_music!);
          if (musicFile.existsSync()) {
            final musicBackupPath =
                join(backupDir.path, basename(song.path_music!));
            await musicFile.copy(musicBackupPath);
          } else {
            print("Файл аудио не найден: ${song.path_music}");
          }
        } else {
          print("У песни отсутствует путь к аудио: ${song.song}");
        }
      }

      // Указываем путь для сохранения ZIP-архива
      final downloadsDir = Directory('/storage/emulated/0/Download');
      if (!downloadsDir.existsSync()) {
        throw Exception("Папка загрузок недоступна");
      }

      // Проверяем существование ZIP-файла и добавляем нумерацию
      String zipFilePath = join(downloadsDir.path, 'songs_export.zip');
      int counter = 1;
      while (File(zipFilePath).existsSync()) {
        zipFilePath = join(downloadsDir.path, 'songs_export_$counter.zip');
        counter++;
      }

      // Создаем ZIP-архив
      final encoder = ZipFileEncoder();
      encoder.create(zipFilePath);
      encoder.addDirectory(backupDir);
      encoder.close();

      // Отправляем файл через Share
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: const Text("Резервное копирование завершено"),
                  content: const Text("Вы хотите поделиться архивом?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Нет")),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Share.shareXFiles([XFile(zipFilePath)]);
                        },
                        child: const Text("Да"))
                  ]));

      print('Export создан и сохранен по пути: $zipFilePath');
    } catch (e) {
      print('Ошибка при создании резервной копии: $e');
    }
  } else {
    print('Разрешение на доступ к хранилищу отклонено');
  }
}

// Future<void> createExport(
//     BuildContext context, List<int> selectedSongIds) async {
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
//       final backupDir = Directory(join(tempDir.path, 'export'));
//       if (!backupDir.existsSync()) {
//         backupDir.createSync();
//       }

//       // Копируем файл базы данных
//       final dbBackupPath = join(backupDir.path, 'songs_export.db');
//       await dbFile.copy(dbBackupPath);

//       // Получаем выбранные песни с их путями
//       final songs = await db.readAllSongs();
//       for (final song in songs) {
//         if (selectedSongIds.contains(song.id) &&
//             song.path_music != null &&
//             song.path_music!.isNotEmpty) {
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
//       String zipFilePath = join(downloadsDir.path, 'songs_export.zip');
//       int counter = 1;
//       while (File(zipFilePath).existsSync()) {
//         zipFilePath = join(downloadsDir.path, 'songs_export_$counter.zip');
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
//                   content: Text(tr(LocaleKeys.confirmation_content_export)),
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

//       print('Export создан и сохранен по пути: $zipFilePath');
//     } catch (e) {
//       print('Ошибка при создании выборочного экспорта: $e');
//     }
//   } else {
//     print('Разрешение на доступ к хранилищу отклонено');
//   }
// }

// Future<void> createExport(
//     BuildContext context, List<int> selectedSongIds) async {
//   // Запрашиваем необходимые разрешения
//   await Permission.manageExternalStorage.request();
//   await Permission.audio.request();

//   if (await Permission.manageExternalStorage.request().isGranted ||
//       await Permission.storage.request().isGranted) {
//     try {
//       final db = DBSongs.instance;

//       // Получаем путь к базе данных
//       final dbPath = await getDatabasesPath();
//       final dbFile = File(join(dbPath, 'songs.db'));

//       // Создаем временный каталог для экспорта
//       final tempDir = await getTemporaryDirectory();
//       final exportDir = Directory(join(tempDir.path, 'export'));
//       if (!exportDir.existsSync()) {
//         exportDir.createSync();
//       }

//       // Копируем файл базы данных в экспортируемую директорию
//       final dbExportPath = join(exportDir.path, 'songs_export.db');
//       await dbFile.copy(dbExportPath);

//       // **Фильтрация и добавление выбранных песен**
//       final allSongs =
//           await db.readAllSongs(); // Получаем все песни из базы данных
//       for (final song in allSongs) {
//         if (selectedSongIds.contains(song.id) &&
//             song.path_music != null &&
//             song.path_music!.isNotEmpty) {
//           final musicFile = File(song.path_music!);
//           if (musicFile.existsSync()) {
//             final musicExportPath =
//                 join(exportDir.path, basename(song.path_music!));
//             await musicFile.copy(musicExportPath);
//           } else {
//             print('Файл не найден: ${song.path_music}');
//           }
//         }
//       }

//       // **Экспорт данных о группах**
//       final groups = await db
//           .readAllGroups(); // Предполагаем, что этот метод уже реализован
//       final groupsJson = groups.map((group) => group.toJson()).toList();
//       final groupsFilePath = join(exportDir.path, 'groups.json');
//       final groupsFile = File(groupsFilePath);
//       groupsFile.writeAsStringSync(jsonEncode(groupsJson));

//       // Указываем путь для сохранения ZIP-архива
//       final downloadsDir = Directory('/storage/emulated/0/Download');
//       if (!downloadsDir.existsSync()) {
//         throw Exception("Папка загрузок недоступна");
//       }

//       // Проверяем существование ZIP-файла и добавляем нумерацию для новых файлов
//       String zipFilePath = join(downloadsDir.path, 'songs_export.zip');
//       int counter = 1;
//       while (File(zipFilePath).existsSync()) {
//         zipFilePath = join(downloadsDir.path, 'songs_export_$counter.zip');
//         counter++;
//       }

//       // Создаем ZIP-архив
//       final encoder = ZipFileEncoder();
//       encoder.create(zipFilePath);
//       encoder.addDirectory(exportDir);
//       encoder.close();

//       // Показываем пользователю диалоговое окно подтверждения экспорта
//       await showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//                   title: Text(tr(LocaleKeys.confirmation_title)),
//                   content: Text(tr(LocaleKeys.confirmation_content_export)),
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

//       print('Экспорт создан и сохранен по пути: $zipFilePath');
//     } catch (e) {
//       print('Ошибка при создании экспорта: $e');
//     }
//   } else {
//     print('Разрешение на доступ к хранилищу отклонено');
//   }
// }
