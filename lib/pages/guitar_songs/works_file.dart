import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translit/translit.dart';

// Future<File> saveFilePermanently(PlatformFile file) async {
//   final appStorage = await getApplicationDocumentsDirectory();
//   String fileNameWithoutExtension = getFileNameWithoutExtension(file.name);
//   String filePath =
//       '${appStorage.path}/$fileNameWithoutExtension.${file.extension}';

//   int index = 1;
//   while (await File(filePath).exists()) {
//     // Файл с таким именем уже существует. Увеличиваем индекс.
//     filePath =
//         '${appStorage.path}/$fileNameWithoutExtension$index.${file.extension}';
//     index++;
//   }

//   return File(file.path!).copy(filePath);
// }

// String getFileNameWithoutExtension(String fileName) {
//   int dotIndex = fileName.lastIndexOf('.');
//   if (dotIndex != -1) {
//     return fileName.substring(0, dotIndex);
//   }
//   return fileName; // Если расширение отсутствует или файл не имеет расширения.
// }

// Future<void> deleteFile(String filePath) async {
//   try {
//     final file = File(filePath);

//     if (await file.exists()) {
//       await file.delete();
//       print('Файл успешно удален: $filePath');
//     } else {
//       print('Файл не существует');
//     }
//   } catch (e) {
//     print('Ошибка при удалении файла: $e');
//   }
// }

Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  String fileNameWithoutExtension =
      transliterateFileName(getFileNameWithoutExtension(file.name));
  String filePath =
      '${appStorage.path}/$fileNameWithoutExtension.${file.extension}';

  int index = 1;
  while (await File(filePath).exists()) {
    filePath =
        '${appStorage.path}/$fileNameWithoutExtension$index.${file.extension}';
    index++;
  }

  return File(file.path!).copy(filePath);
}

String getFileNameWithoutExtension(String fileName) {
  int dotIndex = fileName.lastIndexOf('.');
  if (dotIndex != -1) {
    return fileName.substring(0, dotIndex);
  }
  return fileName;
}

String transliterateFileName(String fileName) {
  final translit = Translit();
  return translit
      .toTranslit(source: fileName)
      .replaceAll(' ', '_')
      .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
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
