import 'package:firebase_remote_config/firebase_remote_config.dart';

class FirebaseRemoteConfigClass {
  final remoteConfig = FirebaseRemoteConfig.instance;
  Future initializeConfig() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(hours: 1),
        minimumFetchInterval: const Duration(hours: 1)));
    await remoteConfig.fetchAndActivate();
    var temp = remoteConfig.getString('news');
    return temp;
  }
}
