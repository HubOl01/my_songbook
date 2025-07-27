import 'package:bloc/bloc.dart';

class CurrentIndexGroupCubit extends Cubit<int> {
  CurrentIndexGroupCubit() : super(0);

  void switcherIndex(int index)=> emit(index);
}
