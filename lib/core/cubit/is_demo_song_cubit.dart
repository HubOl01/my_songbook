import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:my_songbook/core/storage/storage.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class IsDemoSongCubit extends Cubit<bool> {
  IsDemoSongCubit() : super(true);

    void deleteDemo() async {
    bool isDemo = false;
    await isDeleteTestPut(!isDemo);
    return emit(isDemo);
  }

  void init() async {
    var app = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(app.path);
    var box = await Hive.openBox('my_songbook');
    return emit(!(box.get('isDeleteTest') ?? false));
  }
}
