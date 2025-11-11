import 'package:bloc/bloc.dart';

import '../storage/hiveHelper.dart';
import '../storage/storage.dart';

class HideBannerIdCubit extends Cubit<int> {
  HideBannerIdCubit() : super(globalIdBanner);

  Future<void> hide(int id) async {
    await hideBannerId(id);
    return emit(id);
  }

  Future<void> init() async {
    final hive = HiveHelper();
    final box = await hive.openBox();
    int idBanner = box.get('hideBannerId') ?? globalIdBanner;
    print('hideBannerId: $idBanner');
    return hide(idBanner);
  }
}
