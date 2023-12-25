import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// Future<File> saveFilePermanently(PlatformFile file) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final mySongsDirectory = Directory('${directory.path}');

//   // Создание папки "Master", если она еще не существует
//   if (!await mySongsDirectory.exists()) {
//     await mySongsDirectory.create(recursive: true);
//   }
//   // final mySongsDirectory = Directory('${directory.path}');

//   final filePath = File('${mySongsDirectory.path}/${file.name}');
//   return filePath;
// }

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFile = File('${appStorage.path}/${file.name}');
  return File(file.path!).copy(newFile.path);
}

Future<void> deleteFile(String filePath) async {
  try {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
      print('Файл успешно удален: $filePath');
    } else {
      print('Файл не существует');
    }
  } catch (e) {
    print('Ошибка при удалении файла: $e');
  }
}
