import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../components/remote_config.dart';
import '../model/newsModel.dart';
import '../storage/storage.dart';

List<NewsModel> myJson = [];
Future<void> getNews() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetch();
  await remoteConfig.activate();
  await FirebaseRemoteConfigClass().initializeConfig();
  // RemoteConfigValue myJsonValue = remoteConfig.getValue('news');
  // String myJsonString = myJsonValue.asString();
  String myJsonString =
      await rootBundle.loadString('assets/dataJson/news.json');
  myJson = newsFromJson(myJsonString);
}

DateFormat format = DateFormat('dd.MM.yyyy');
Future<List<NewsModel>> JSONValueRU() async {
  final List<NewsModel> json = [];
  // for (int i = 0; i < myJson.length; i++) {
    
  //   if (myJson[i].isShow! && myJson[i].lang == "ru") {
  //     if (DateTime.now().isAfter(format.parse(myJson[i].date!.startAt!)) &&
  //         DateTime.now().isBefore(format.parse(myJson[i].date!.closeAt!))) {
  //       print("json[$i].isShow!: ${myJson[i].isShow}");
  //       json.add(myJson[i]);
  //     }
  //   }
  // }
  // return json;
  for (var item in myJson) {
    // Базовые условия
    if (item.isShow == true && item.lang == "ru") {
      // Проверка по дате
      final hasValidDate = 
          item.date?.startAt != null &&
              item.date?.closeAt != null &&
              DateTime.now().isAfter(format.parse(item.date!.startAt!)) &&
              DateTime.now().isBefore(format.parse(item.date!.closeAt!));

      if (!hasValidDate) continue;

      // Проверка через BannerManager
      final shouldShow = await BannerManager().shouldShowBanner(item.id!);
      if (shouldShow) {
        json.add(item);
      }
    }
  }

  return json;

}

List<NewsModel> JSONValueEN() {
  List<NewsModel> json = [];
  for (int i = 0; i < myJson.length; i++) {
    if (myJson[i].isShow! && myJson[i].lang == "en") {
      if (DateTime.now().isAfter(format.parse(myJson[i].date!.startAt!)) &&
          DateTime.now().isBefore(format.parse(myJson[i].date!.closeAt!))) {
        print("json[$i].isShow!: ${myJson[i].isShow}");
        json.add(myJson[i]);
      }
    }
  }
  return json;
}
