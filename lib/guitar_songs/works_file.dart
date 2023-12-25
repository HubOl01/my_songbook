import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// Future<File> saveFilePermanently(PlatformFile file) async {
//   final appStorage = await getApplicationDocumentsDirectory();
//   final newFile = File('${appStorage.path}/${file.name}');
//   return File(file.path!).copy(newFile.path);
// }


Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  final newFileName = await _getUniqueFileName(appStorage.path, file.name);
  final newFile = File('$appStorage/$newFileName');
  return File(file.path!).copy(newFile.path);
}

Future<String> _getUniqueFileName(String directoryPath, String originalName) async {
  String fileName = originalName;
  int index = 1;

  while (await File('$directoryPath/$fileName').exists()) {
    fileName = '${originalName.replaceAll('.', '_')}_$index.${originalName.split('.').last}';
    index++;
  }
  return fileName;
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
