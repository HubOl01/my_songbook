import 'package:bloc/bloc.dart';

class CurrentGroupIdCubit extends Cubit<int> {
  CurrentGroupIdCubit() : super(-1);

  void switcher(int id) => emit(id);
}
