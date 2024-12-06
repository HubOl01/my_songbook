import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_songbook/core/data/dbSongs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

Future<void> importBackupAndMerge() async {
  // Запрос разрешений
  await Permission.storage.request();
  await Permission.manageExternalStorage.request();

  try {
    // Выбор ZIP-файла
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null || result.files.single.path == null) {
      print('Файл не выбран');
      return;
    }

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

    // Найти файл базы данных (.db) в распакованной директории
    final dbFile = unzipDir
        .listSync(recursive: true)
        .whereType<File>()
        .firstWhere(
          (file) => file.path.endsWith('.db'),
          orElse: () => throw Exception('Файл базы данных не найден в архиве'),
        );
    final dbBackupPath = dbFile.path;

    // Открываем базу данных из бэкапа
    final backupDb = await openDatabase(dbBackupPath);
    final currentDb = DBSongs.instance;

    // Чтение песен из бэкапа
    final List<Map<String, dynamic>> backupSongs =
        await backupDb.query('songs'); // Таблица с песнями
    await backupDb.close();

    // Добавление песен в текущую базу данных
    for (final songData in backupSongs) {
      final songPath = songData['path_music'] as String?;
      if (songPath != null && songPath.isNotEmpty) {
        // Проверяем, существует ли файл музыки
        final originalPath = join(unzipDir.path, basename(songPath));
        if (File(originalPath).existsSync()) {
          // Копируем музыкальный файл в нужное место (если нужно)
          final musicDir = Directory('/storage/emulated/0/Music/MyApp');
          if (!musicDir.existsSync()) {
            musicDir.createSync(recursive: true);
          }
          final newMusicPath = join(musicDir.path, basename(songPath));
          await File(originalPath).copy(newMusicPath);

          // Обновляем путь в данных песни
          songData['path_music'] = newMusicPath;
        }
      }

      // Проверяем, есть ли уже такая запись в базе данных
      final existingSongs =
          await currentDb.findSongByPath(songData['path_music']);
      if (existingSongs.isEmpty) {
        // Добавляем только новые записи
        await currentDb.insertSong(songData);
      } else {
        print('Песня уже существует: ${songData['path_music']}');
      }
    }

    print('Импорт завершен успешно!');
  } catch (e) {
    print('Ошибка при импорте и объединении данных: $e');
  }
}
