part of 'songs1_cubit.dart';

abstract class Songs1State {}

class Songs1Initial extends Songs1State {}

class Songs1Loading extends Songs1State {}

class Songs1Loaded extends Songs1State {
  final List<Song> songs;

  Songs1Loaded(this.songs);
}

class Songs1LoadedWithGroups extends Songs1State {
  final List<Song> songs;
  final List<GroupModel> groups;

  Songs1LoadedWithGroups(this.songs, this.groups);
}

class Songs1Error extends Songs1State {
  final String message;

  Songs1Error(this.message);
}
