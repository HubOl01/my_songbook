import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../storage/storage.dart';

class SortingGroupCubit extends Cubit<int> {
  SortingGroupCubit() : super(0);
  void switcher(int index) async {
    await sortingGroup(index);
    return emit(index);
  }

  void init() async {
    var app = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(app.path);
    var box = await Hive.openBox('my_songbook');
    return emit(box.get('sortingGroupIndex') ?? 0);
  }
}
