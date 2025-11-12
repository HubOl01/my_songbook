// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import '../../components/remote_config.dart';
// import '../model/newsModel.dart';
// import '../storage/storage.dart';

// List<NewsModel> myJson = [];
// Future<void> getNews() async {
//   final remoteConfig = FirebaseRemoteConfig.instance;
//   await remoteConfig.fetch();
//   await remoteConfig.activate();
//   await FirebaseRemoteConfigClass().initializeConfig();
//   // RemoteConfigValue myJsonValue = remoteConfig.getValue('news');
//   // String myJsonString = myJsonValue.asString();
//   String myJsonString =
//       await rootBundle.loadString('assets/dataJson/news.json');
//   myJson = newsFromJson(myJsonString);
// }

// DateFormat format = DateFormat('dd.MM.yyyy');
// Future<List<NewsModel>> JSONValueRU() async {
//   final List<NewsModel> json = [];
//   // for (int i = 0; i < myJson.length; i++) {

//   //   if (myJson[i].isShow! && myJson[i].lang == "ru") {
//   //     if (DateTime.now().isAfter(format.parse(myJson[i].date!.startAt!)) &&
//   //         DateTime.now().isBefore(format.parse(myJson[i].date!.closeAt!))) {
//   //       print("json[$i].isShow!: ${myJson[i].isShow}");
//   //       json.add(myJson[i]);
//   //     }
//   //   }
//   // }
//   // return json;
//   for (var item in myJson) {
//     // Базовые условия
//     if (item.isShow == true && item.lang == "ru") {
//       // Проверка по дате
//       final hasValidDate =
//           item.date?.startAt != null &&
//               item.date?.closeAt != null &&
//               DateTime.now().isAfter(format.parse(item.date!.startAt!)) &&
//               DateTime.now().isBefore(format.parse(item.date!.closeAt!));

//       if (!hasValidDate) continue;

//       // Проверка через BannerManager
//       final shouldShow = await BannerManager().shouldShowBanner(item.id!);
//       if (shouldShow) {
//         json.add(item);
//       }
//     }
//   }

//   return json;

// }

// List<NewsModel> JSONValueEN() {
//   List<NewsModel> json = [];
//   for (int i = 0; i < myJson.length; i++) {
//     if (myJson[i].isShow! && myJson[i].lang == "en") {
//       if (DateTime.now().isAfter(format.parse(myJson[i].date!.startAt!)) &&
//           DateTime.now().isBefore(format.parse(myJson[i].date!.closeAt!))) {
//         print("json[$i].isShow!: ${myJson[i].isShow}");
//         json.add(myJson[i]);
//       }
//     }
//   }
//   return json;
// }
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/newsModel.dart';
import '../storage/hiveHelper.dart';
import '../storage/storage.dart';

class NewsService {
  NewsModel? _myJson;

  Future<NewsModel?> loadNewsFromS3(bool isEn) async {
    try {
      String newsJsonKey =
          isEn ? dotenv.env['NewsJsonKeyEn']! : dotenv.env['NewsJsonKeyRu']!;

      final response = await http.get(Uri.parse(newsJsonKey));

      if (response.statusCode == 200) {
        final jsonStr = response.body;
        await stringNewsJson(jsonStr);
        _myJson = newsModelFromJson(jsonStr);
        print("✅ News loaded from S3: ${_myJson!.toJson()}");
        final hive = HiveHelper();
        final box = await hive.openBox();
        globalIdBanner = box.get('hideBannerId') ?? globalIdBanner;
        if (_myJson!.id! == globalIdBanner) {
          AppMetrica.reportEvent('News loaded from S3 (show): ${_myJson!.id!}');
        }
        return _myJson;
      } else {
        print("❌ Failed to load from S3: ${response.statusCode}");
        AppMetrica.reportErrorWithGroup('NEWS_ERROR',
            message: 'Failed to load from S3: ${response.statusCode}');
        return await getCachedNews();
      }
    } catch (e) {
      print("❌ loadNewsFromS3 ERROR: $e");
      AppMetrica.reportErrorWithGroup('NEWS_ERROR',
          message: 'loadNewsFromS3 ERROR: $e');
      return await getCachedNews();
    }
  }

  // Для getNews - только из кэша (не нагружает сервер)
  Future<NewsModel?> getNews() async {
    try {
      if (_myJson != null) {
        print("📰 Using cached NewsModel instance");
        return _myJson;
      }

      _myJson = await getCachedNews();

      if (_myJson != null) {
        print("📰 News from Hive cache: ${_myJson!.toJson()}");
      } else {
        print("⚠️ No cached news available");
      }
      // для теста --------
      // String myJsonString =
      //     await rootBundle.loadString('assets/dataJson/event_MS_ru.json');
      // _myJson = newsModelFromJson(myJsonString);
      // ------------------
      return _myJson;
    } catch (e) {
      print("❌ getNews ERROR: $e");
      return null;
    }
  }

  // Получить новости только из кэша
  Future<NewsModel?> getCachedNews() async {
    try {
      await HiveHelper.init();
      final hive = HiveHelper();
      final box = await hive.openBox();
      final cachedJsonStr =
          box.get('stringNewsJsonPublic') ?? stringNewsJsonPublic;

      if (cachedJsonStr.isNotEmpty) {
        return newsModelFromJson(cachedJsonStr);
      }
      return null;
    } catch (e) {
      print("❌ getCachedNews ERROR: $e");
      return null;
    }
  }

  // Проверка наличия кэшированных данных
  Future<bool> hasCachedNews() async {
    try {
      await HiveHelper.init();
      final hive = HiveHelper();
      final box = await hive.openBox();
      final cachedJsonStr =
          box.get('stringNewsJsonPublic') ?? stringNewsJsonPublic;
      return cachedJsonStr.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
