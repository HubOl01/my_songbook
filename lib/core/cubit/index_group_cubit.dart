import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'index_group_state.dart';

class IndexGroupCubit extends Cubit<int> {
  IndexGroupCubit() : super(-1);

  void switcher(int id) => emit(id);
}
