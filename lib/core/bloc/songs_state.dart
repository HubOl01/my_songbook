part of 'songs_bloc.dart';

// @immutable
// sealed class SongsState {}

// final class SongsInitial extends SongsState {}

abstract class SongsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SongsLoading extends SongsState {}

class SongsLoaded extends SongsState {
  final List<Song> songs;
  final List<GroupModel> groups;

  SongsLoaded(this.songs, this.groups);

  @override
  List<Object?> get props => [songs];
}
// class SongLoaded extends SongsState {
//   final Song song;

//    SongLoaded(this.song);

//   @override
//   List<Object> get props => [song];
// }


class SongsParameterUpdated extends SongsState {
  final String parameter;
  final int id;

  SongsParameterUpdated(this.parameter, this.id);

  @override
  List<Object> get props => [parameter, id];
}

class SongsError extends SongsState {
  final String message;

  SongsError(this.message);

  @override
  List<Object?> get props => [message];
}

class GroupsLoading extends SongsState {}

class GroupsLoaded extends SongsState {
  final List<GroupModel> groups;
  GroupsLoaded(this.groups);
}

class SongsLoadedForGroup extends SongsState {
  final int groupId;
  final List<Song> songs;
  SongsLoadedForGroup(this.groupId, this.songs);
}

class GroupsError extends SongsState {
  final String message;
  GroupsError(this.message);
}
