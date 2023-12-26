import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

// Future<File> saveFilePermanently(PlatformFile file) async {
//   final appStorage = await getApplicationDocumentsDirectory();
//   final newFile = File('${appStorage.path}/${file.name}');
//   return File(file.path!).copy(newFile.path);
// }


// Future<File> saveFilePermanently(PlatformFile file) async {
//   final appStorage = await getApplicationDocumentsDirectory();
//   final newFile = File('${appStorage.path}/${file.name}');
//   return File(file.path!).copy(newFile.path);
// }
Future<File> saveFilePermanently(PlatformFile file) async {
  final appStorage = await getApplicationDocumentsDirectory();
  String fileNameWithoutExtension = getFileNameWithoutExtension(file.name);
  String filePath = '${appStorage.path}/$fileNameWithoutExtension.${file.extension}';

  int index = 1;
  while (await File(filePath).exists()) {
    // Файл с таким именем уже существует. Увеличиваем индекс.
    filePath = '${appStorage.path}/$fileNameWithoutExtension$index.${file.extension}';
    index++;
  }

  return File(file.path!).copy(filePath);
}

String getFileNameWithoutExtension(String fileName) {
  int dotIndex = fileName.lastIndexOf('.');
  if (dotIndex != -1) {
    return fileName.substring(0, dotIndex);
  }
  return fileName; // Если расширение отсутствует или файл не имеет расширения.
}
// Future<String> _getUniqueFileName(String directoryPath, String originalName) async {
//   String fileName = originalName;
//   int index = 1;

//   while (await File('$directoryPath/$fileName').exists()) {
//     // fileName = '${originalName.replaceAll('.', '_')}_$index.${originalName.split('.').last}';
//     // fileName = '${directoryPath}/${originalName}($index)';
//     index++;
//   }
//   return fileName;
// }


// Future<File> saveFilePermanently(PlatformFile file) async {
//   await Permission.storage.request();
//   final appStorage = await getApplicationDocumentsDirectory();

//   // Проверяем, существует ли каталог app_flutter
//   // if (!await Directory(directoryPath).exists()) {
//   //   await Directory(directoryPath).create(recursive: true);
//   // }

//   final newFileName = await _getUniqueFileName(appStorage.path, file.name);
//   final newFile = File('$appStorage/$newFileName');

//   return File(file.path!).copy(newFile.path);
// }

// Future<String> _getUniqueFileName(String directoryPath, String originalName) async {
//   String fileName = originalName;
//   int index = 1;

//   // Проверяем, существует ли файл с таким именем
//   while (await File('$directoryPath/$fileName').exists()) {
//     // Если существует, добавляем индекс к имени файла
//     fileName = '${originalName.replaceAll('.', '_')}_$index.${originalName.split('.').last}';
//     index++;
//   }

//   return fileName;
// }

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
