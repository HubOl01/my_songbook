part of 'song_bloc.dart';

// sealed class SongState extends Equatable {
//   const SongState();
  
//   @override
//   List<Object> get props => [];
// }

// final class SongInitial extends SongState {}

abstract class SongState {}

class SongInitial extends SongState {}

class SongLoading extends SongState {}

class SongLoaded extends SongState {
  final Song song;
  SongLoaded(this.song);
}

class SongError extends SongState {
  final String message;
  SongError(this.message);
}

class SongUpdated extends SongState {}

class SongDeleted extends SongState {}