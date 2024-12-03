part of 'songs_bloc.dart';

// @immutable
// sealed class SongsEvent {}
abstract class SongsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadSongs extends SongsEvent {}

class AddSong extends SongsEvent {
  final Song song;

  AddSong(this.song);

  @override
  List<Object?> get props => [song];
}

class UpdateSong extends SongsEvent {
  final Song song;

  UpdateSong(this.song);

  @override
  List<Object?> get props => [song];
}

class DeleteSong extends SongsEvent {
  final int id;

  DeleteSong(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteAllSongs extends SongsEvent {}

class UpdateSongsOrder extends SongsEvent {
  final List<Song> updatedSongs;

  UpdateSongsOrder(this.updatedSongs);

  @override
  List<Object?> get props => [updatedSongs];
}


class LoadGroups extends SongsEvent {}

class AddGroup extends SongsEvent {
  final GroupModel group;
  AddGroup(this.group);
}

class UpdateGroup extends SongsEvent {
  final GroupModel group;
  UpdateGroup(this.group);
}

class DeleteGroup extends SongsEvent {
  final int groupId;
  DeleteGroup(this.groupId);
}

// class LoadSongsByGroup extends SongsEvent {
//   final int groupId;
//   LoadSongsByGroup(this.groupId);
// }