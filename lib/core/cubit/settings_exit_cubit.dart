import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../storage/storage.dart';

part 'settings_exit_state.dart';

class SettingsExitCubit extends Cubit<bool> {
  SettingsExitCubit() : super(false);

  void toggle() async {
    bool settingsExit = !state;
    await isSettingsExit(settingsExit);
    return emit(settingsExit);
  }

  void init() async {
    var app = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(app.path);
    var box = await Hive.openBox('my_songbook');
    return emit(box.get('settingsExit') ?? false);
  }
}
