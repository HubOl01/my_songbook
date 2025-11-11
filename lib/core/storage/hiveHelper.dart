import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper {
  static final HiveHelper _instance = HiveHelper._internal();
  static const String storageName = 'my_songbook';

  Box? _box;

  HiveHelper._internal();

  factory HiveHelper() {
    return _instance;
  }

  /// Инициализация Hive (только один раз в main)
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  /// Безопасное открытие box
  Future<Box> openBox() async {
    if (_box?.isOpen ?? false) {
      return _box!;
    }

    try {
      _box = await Hive.openBox(storageName,
          compactionStrategy: (total, deleted) =>
              false); // отключаем авто-compact
    } catch (e) {
      // Если база повреждена — удаляем файл и открываем заново
      print("⚠️ Hive box corrupted: $e");
      // final dir = await getApplicationDocumentsDirectory();
      // final file = File("${dir.path}/$storageName.hive");
      // if (await file.exists()) {
      //   await file.delete();
      //   print("🗑️ Повреждённый Hive-файл удалён");
      // }
      _box = await Hive.openBox(storageName,
          compactionStrategy: (total, deleted) => false);
    }

    return _box!;
  }

  /// Получение значения
  Future<T?> get<T>(String key) async {
    final box = await openBox();
    return box.get(key) as T?;
  }

  /// Сохранение значения
  Future<void> put<T>(String key, T value) async {
    final box = await openBox();
    await box.put(key, value);
  }

  /// Удаление ключа
  Future<void> delete(String key) async {
    final box = await openBox();
    await box.delete(key);
  }

  /// Очистка базы (по необходимости)
  Future<void> clear() async {
    final box = await openBox();
    await box.clear();
  }

  /// ⚠️ Никогда не закрываем box, просто оставляем открытым
  /// Если всё-таки надо, можно сделать метод:
  Future<void> closeBox() async {
    // закроем только если нужно явно, но в обычной работе — не используем
    if (_box?.isOpen ?? false) {
      await _box!.close();
    }
    _box = null;
  }
}
