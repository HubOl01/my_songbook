import 'package:hive/hive.dart';
import 'package:my_songbook/main.dart';

class Storage {
  static Box? _box;

  static Future<Box> getBox() async {
    if (_box?.isOpen ?? false) return _box!;
    _box = await Hive.openBox(storageName);
    return _box!;
  }
}

const String storageName = "my_songbook";
Future speedPut(int speed) async {
  var box = await Hive.openBox(storageName);
  box.put("speedText", speed);
  await box.compact();
  await box.close();
}

Future sizeTextPut(double sizeText) async {
  var box = await Hive.openBox(storageName);
  box.put("sizeText", sizeText);
  await box.compact();
  await box.close();
}

Future isClosedWarringPut(bool isClosedWarring) async {
  var box = await Hive.openBox(storageName);
  box.put("isClosedWarring", isClosedWarring);
  await box.compact();
  await box.close();
}

Future isDeleteTestPut(bool isDeleteTest) async {
  var box = await Hive.openBox(storageName);
  box.put("isDeleteTest", isDeleteTest);
  await box.compact();
  await box.close();
}

Future switCH(int index) async {
  var box = await Hive.openBox(storageName);
  box.put("themeMode", index);
  getMode();
  await box.compact();
  await box.close();
}

Future isSettingsExit(bool isSettingsExit) async {
  var box = await Hive.openBox(storageName);
  box.put("settingsExit", isSettingsExit);
  await box.compact();
  await box.close();
}

Future sortingGroup(int sortingGroupIndex) async {
  var box = await Hive.openBox(storageName);
  box.put("sortingGroupIndex", sortingGroupIndex);
  await box.compact();
  await box.close();
}

bool isAutoSave = false;
Future autoSave(bool isAuto) async {
  var box = await Hive.openBox(storageName);
  box.put("isAutoSave", isAuto);
  await box.compact();
  await box.close();
}

int globalIdBanner = 0;
Future hideBannerId(int id) async {
  var box = await Hive.openBox(storageName);
  box.put("hideBannerId", id);
  await box.compact();
  await box.close();
}

String stringNewsJsonPublic = "";
Future stringNewsJson(String str) async {
  var box = await Hive.openBox(storageName);
  box.put("stringNewsJsonPublic", str);
  await box.compact();
  await box.close();
}
