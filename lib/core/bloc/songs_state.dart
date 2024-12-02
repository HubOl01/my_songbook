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
