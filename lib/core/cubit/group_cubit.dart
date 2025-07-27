import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_songbook/core/model/groupModel.dart';

class GroupCubit extends Cubit<GroupModel> {
  GroupCubit() : super(GroupModel(name: ''));

  void switcher(GroupModel group) => emit(group);
}
