part of 'songs_cubit.dart';

abstract class Songs1State {}

class Songs1Initial extends Songs1State {}

class Songs1Loading extends Songs1State {}

class Songs1Loaded extends Songs1State {
  final List<Song> songs;

  Songs1Loaded(this.songs);
}

class Songs1Error extends Songs1State {
  final String message;

  Songs1Error(this.message);
}
