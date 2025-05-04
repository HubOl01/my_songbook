import 'package:hive/hive.dart';
import 'package:my_songbook/main.dart';

Future speedPut(int speed) async {
  var box = await Hive.openBox('my_songbook');
  box.put("speedText", speed);
  await box.compact();
  await box.close();
}

Future sizeTextPut(double sizeText) async {
  var box = await Hive.openBox('my_songbook');
  box.put("sizeText", sizeText);
  await box.compact();
  await box.close();
}

Future isClosedWarringPut(bool isClosedWarring) async {
  var box = await Hive.openBox('my_songbook');
  box.put("isClosedWarring", isClosedWarring);
  await box.compact();
  await box.close();
}

Future isDeleteTestPut(bool isDeleteTest) async {
  var box = await Hive.openBox('my_songbook');
  box.put("isDeleteTest", isDeleteTest);
  await box.compact();
  await box.close();
}

Future switCH(int index) async {
  var box = await Hive.openBox('my_songbook');
  box.put("themeMode", index);
  getMode();
  await box.compact();
  await box.close();
}

Future isSettingsExit(bool isSettingsExit) async {
  var box = await Hive.openBox('my_songbook');
  box.put("settingsExit", isSettingsExit);
  await box.compact();
  await box.close();
}

// var box = await Hive.openBox('my_songbook');
// speed = box.get("speedText");
// sizeText = box.get("sizeText");
// isClosedWarring = box.get("isClosedWarring");
// isDeleteTest = box.get("isDeleteTest");

Future<bool> shouldShowBanner() async {
  // Открываем бокс Hive
  var box = await Hive.openBox('my_songbook');

  // Получаем значение isShowBanner (если его нет, считаем true)
  bool isShowBanner = box.get("isShowBanner", defaultValue: true);

  // Если баннер нужно показать, обновляем флаг на false
  if (isShowBanner) {
    box.put("isShowBanner", false);
    await box.compact();
    await box.close();
    return true;
  }

  // Если баннер уже был показан, возвращаем false
  await box.close();
  return false;
}

Future<void> closeBanner(String currentVersion) async {
  var box = await Hive.openBox('my_songbook');
  box.put("isBannerClosed", true);
  box.put("bannerVersion", currentVersion);
  await box.compact();
  await box.close();
}

Future<bool> shouldShowBannerForVersion(String currentVersion) async {
  var box = await Hive.openBox('my_songbook');

  try {
    bool? isBannerClosed = box.get("isBannerClosed");
    if (isBannerClosed == true) {
      return false;
    }

    String? savedVersion = box.get("bannerVersion");

    if (savedVersion != currentVersion) {
      return true;
    }

    return false;
  } finally {
    await box.close();
  }
}

  // var box = await Hive.openBox('my_songbook');
  // speed = box.get("speedText");
  // sizeText = box.get("sizeText");
  // isClosedWarring = box.get("isClosedWarring");
  // isDeleteTest = box.get("isDeleteTest");