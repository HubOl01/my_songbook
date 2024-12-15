import 'package:bloc/bloc.dart';

import '../data/songsRepository.dart';
import '../model/songsModel.dart';

part 'song_event.dart';
part 'song_state.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final SongsRepository songsRepository;

  SongBloc({required this.songsRepository}) : super(SongInitial()) {
    on<ReadSong>(_onReadSong);
    on<DeleteSong>(_onDeleteSong);
    on<UpdateSong>(_onUpdateSong);
    on<UpdateFontSize>(_onUpdateFontSize);
    on<UpdateSpeedScroll>(_onUpdateSpeedScroll);
  }
  Future<void> _onReadSong(ReadSong event, Emitter<SongState> emit) async {
    emit(SongLoading());
    try {
      final song = await songsRepository.readSong(event.id);
      emit(SongLoaded(song));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onDeleteSong(DeleteSong event, Emitter<SongState> emit) async {
    try {
      await songsRepository.deleteSong(event.id);
      emit(SongDeleted());
      add(ReadSong(event.id));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onUpdateSong(UpdateSong event, Emitter<SongState> emit) async {
    try {
      await songsRepository.updateSong(event.updatedSong);
      emit(SongUpdated());
      add(ReadSong(event.updatedSong.id!));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onUpdateFontSize(
      UpdateFontSize event, Emitter<SongState> emit) async {
    try {
      await songsRepository.updateFontSize(event.songId, event.fontSize);
      emit(SongUpdated());
      add(ReadSong(event.songId));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onUpdateSpeedScroll(
      UpdateSpeedScroll event, Emitter<SongState> emit) async {
    try {
      await songsRepository.updateSpeedScroll(event.songId, event.speedScroll);
      emit(SongUpdated());
      add(ReadSong(event.songId));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}
