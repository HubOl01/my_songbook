import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../../components/remote_config.dart';
import '../model/newsModel.dart';

List<News> myJson = [];
Future getNews() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetch();
  await remoteConfig.activate();
  await FirebaseRemoteConfigClass().initializeConfig();
  RemoteConfigValue myJsonValue = remoteConfig.getValue('news');
  String myJsonString = myJsonValue.asString();
  // String myJsonString = await rootBundle.loadString('assets/dataJson/news.json');
  myJson = newsFromJson(myJsonString);
  return myJson;
}

List<News> JSONValueRU() {
  List<News> json = [];
  for (int i = 0; i < myJson.length; i++) {
    if (myJson[i].isShow! && myJson[i].lang == "ru") {
      print("json[$i].isShow!: ${myJson[i].isShow}");
      json.add(myJson[i]);
    }
  }
  return json;
}
List<News> JSONValueEN() {
  List<News> json = [];
  for (int i = 0; i < myJson.length; i++) {
    if (myJson[i].isShow! && myJson[i].lang == "en") {
      print("json[$i].isShow!: ${myJson[i].isShow}");
      json.add(myJson[i]);
    }
  }
  return json;
}