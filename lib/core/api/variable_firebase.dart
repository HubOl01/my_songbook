import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../components/remote_config.dart';

bool betaData = false;
Future<bool> getBetaData() async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // Загружаем данные из RemoteConfig
  await remoteConfig.fetch();
  await remoteConfig.activate();

  // Инициализация дополнительных параметров, если требуется
  await FirebaseRemoteConfigClass().initializeConfig();

  // Получаем значение 'beta_data' как bool
  final bool betaData = remoteConfig.getBool('beta_data');

  return betaData;
}
