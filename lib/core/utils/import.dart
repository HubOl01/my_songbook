import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_songbook/core/data/dbSongs.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/songsModel.dart';

Future<void> importBackup() async {
  try {
    // Выбор ZIP-архива пользователем
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );

    if (result == null) {
      print("Импорт отменен пользователем");
      return;
    }

    final zipFilePath = result.files.single.path!;
    final zipFile = File(zipFilePath);

    // Распаковка архива
    final tempDir = await getTemporaryDirectory();
    final extractDir = Directory(join(tempDir.path, 'extracted_backup'));
    if (!extractDir.existsSync()) {
      extractDir.createSync();
    }

    final bytes = zipFile.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      final filePath = join(extractDir.path, file.name);
      if (file.isFile) {
        final outputFile = File(filePath);
        outputFile.createSync(recursive: true);
        outputFile.writeAsBytesSync(file.content as List<int>);
      }
    }

    // Обработка файлов базы данных и музыки
    final dbFile = File(join(extractDir.path, 'songs_backup.db'));
    final musicFiles = extractDir
        .listSync(recursive: true)
        .whereType<File>()
        .where(
            (file) => file.path.endsWith('.mp3') || file.path.endsWith('.wav'))
        .toList();

    if (!dbFile.existsSync()) {
      throw Exception("Файл базы данных отсутствует в архиве");
    }

    // Открытие файла базы данных резервной копии
    final backupDb = await openDatabase(dbFile.path);

    // Чтение песен из резервной копии
    final songs = await backupDb.query('songs');
    for (final song in songs) {
      final newSong = Song(
        name_song: song['name_song'] as String? ?? '',
        name_singer: song['name_singer'] as String? ?? '',
        song: song['song'] as String? ?? '',
        path_music: song['path_music'] as String? ?? '',
        order: 0,
        group: 0,
        date_created: DateTime.parse(
            song['date_created'] as String? ?? '2024-01-01 00:00:00'),
      );

      // Добавляем песню в текущую базу данных
      await DBSongs.instance.create(newSong);

      // Копируем музыкальные файлы в приложение
      final musicFilePath = song['path_music'] as String;
      final musicFile = musicFiles.firstWhere(
        (file) => basename(file.path) == basename(musicFilePath),
        orElse: () => File(''),
      );

      if (musicFile.existsSync()) {
        final appMusicDir = Directory('/storage/emulated/0/Download/music');
        if (!appMusicDir.existsSync()) {
          appMusicDir.createSync(recursive: true);
        }
        final newMusicPath = join(appMusicDir.path, basename(musicFile.path));
        await musicFile.copy(newMusicPath);

        print("Файл скопирован в: $newMusicPath");
      }
    }

    print("Импорт завершен успешно");
  } catch (e) {
    print("Ошибка при импорте резервной копии: $e");
  }
}
