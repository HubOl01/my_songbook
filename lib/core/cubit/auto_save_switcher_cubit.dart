import 'package:bloc/bloc.dart';

import '../storage/hiveHelper.dart';
import '../storage/storage.dart';

class AutoSaveSwitcherCubit extends Cubit<bool> {
  AutoSaveSwitcherCubit() : super(isAutoSave);

  void toggle() async {
    bool isSave = !state;
    await autoSave(isSave);
    return emit(isSave);
  }

  void init() async {
    final hive = HiveHelper();
    final box = await hive.openBox();
    return emit(box.get('isAutoSave') ?? isAutoSave);
  }
}
