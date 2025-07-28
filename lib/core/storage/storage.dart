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

Future sortingGroup(int sortingGroupIndex) async {
  var box = await Hive.openBox('my_songbook');
  box.put("sortingGroupIndex", sortingGroupIndex);
  await box.compact();
  await box.close();
}

// var box = await Hive.openBox('my_songbook');
// speed = box.get("speedText");
// sizeText = box.get("sizeText");
// isClosedWarring = box.get("isClosedWarring");
// isDeleteTest = box.get("isDeleteTest");

class BannerManager {
  static const String _boxName = 'my_songbook';
  static const String _bannerIdsKey = 'bannerIds';
  static const String _bannerVersionKey = 'bannerVersion';

  /// Проверяет, нужно ли показывать баннер на основе id
  Future<bool> shouldShowBanner(int idBanner) async {
    // Открываем бокс Hive
    var box = await Hive.openBox(_boxName);

    try {
      // Получаем список показанных баннеров (если его нет, создаем пустой список)
      List<int> shownBannerIds = box.get(_bannerIdsKey, defaultValue: <int>[]);

      // Если id баннера уже есть в списке, не показываем его
      if (shownBannerIds.contains(idBanner)) {
        return false;
      }

      // Добавляем id баннера в список показанных

      // Показываем баннер
      return true;
    } finally {
      // Закрываем бокс после использования
      await box.close();
    }
  }

  /// Проверяет, нужно ли показывать баннер на основе версии приложения
  Future<bool> shouldShowBannerForVersion(String currentVersion) async {
    var box = await Hive.openBox(_boxName);

    try {
      String? savedVersion = box.get(_bannerVersionKey);

      if (savedVersion != currentVersion) {
        return true;
      }

      return false;
    } finally {
      await box.close();
    }
  }

  Future<void> closeBanner(bool clearBannerIds,
      {int? idBanner, String? newVersion}) async {
    var box = await Hive.openBox(_boxName);

    try {
      if (clearBannerIds) {
        List<int> shownBannerIds =
            box.get(_bannerIdsKey, defaultValue: <int>[]);
        shownBannerIds.add(idBanner!);
        await box.put(_bannerIdsKey, shownBannerIds);
      } else {
        if (newVersion != null) {
          await box.put(_bannerVersionKey, newVersion);
        }
      }
    } finally {
      await box.close();
    }
  }
}
