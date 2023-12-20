import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future initializeConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 30),
        minimumFetchInterval: Duration(minutes: 30)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString('news');
    return temp;
  }
}
