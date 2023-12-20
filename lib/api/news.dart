import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../components/remote_config.dart';
import '../guitar_songs/model/newsModel.dart';

List<News> myJson = [];
Future getNews() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetch();
  await remoteConfig.activate();
  await FirebaseRemoteConfigClass().initializeConfig();
  RemoteConfigValue myJsonValue = remoteConfig.getValue('news');
  String myJsonString = myJsonValue.asString();
  myJson = newsFromJson(myJsonString);
  return myJson;
}

List<News> JSONValue() {
  List<News> json = [];
  for (int i = 0; i < myJson.length; i++) {
    if (myJson[i].isShow) {
      print("json[${i}].isShow!: ${myJson[i].isShow}");
      json.add(myJson[i]);
    }
  }
  return json;
}
