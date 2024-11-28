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

  SongsLoaded(this.songs);

  @override
  List<Object?> get props => [songs];
}

class SongsError extends SongsState {
  final String message;

  SongsError(this.message);

  @override
  List<Object?> get props => [message];
}