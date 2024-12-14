part of 'song_bloc.dart';

// sealed class SongEvent extends Equatable {
//   const SongEvent();

//   @override
//   List<Object> get props => [];
// }
abstract class SongEvent {}

class ReadSong extends SongEvent {
  final int id;
  ReadSong(this.id);
}

class DeleteSong extends SongEvent {
  final int id;
  DeleteSong(this.id);
}

class UpdateSong extends SongEvent {
  final Song updatedSong;
  UpdateSong(this.updatedSong);
}

class UpdateFontSize extends SongEvent {
  final int songId;
  final double fontSize;
  UpdateFontSize(this.songId, this.fontSize);
}

class UpdateSpeedScroll extends SongEvent {
  final int songId;
  final int speedScroll;
  UpdateSpeedScroll(this.songId, this.speedScroll);
}