import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_songbook/core/model/groupModel.dart';

part 'group_id_state.dart';

class GroupCubit extends Cubit<GroupModel> {
  GroupCubit() : super(GroupModel(name: ''));

  void swither(GroupModel group) => emit(group);
}
