import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/songsRepository.dart';
import '../model/songsModel.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final SongsRepository _repository;

  SongsBloc(this._repository) : super(SongsLoading()) {
    on<LoadSongs>((event, emit) async {
      emit(SongsLoading());
      try {
        final songs = await _repository.getAllSongs();
        emit(SongsLoaded(songs));
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });

    on<AddSong>((event, emit) async {
      try {
        await _repository.addSong(event.song);
        add(LoadSongs());
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });

    on<UpdateSong>((event, emit) async {
      try {
        await _repository.updateSong(event.song);
        add(LoadSongs());
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });

    on<DeleteSong>((event, emit) async {
      try {
        await _repository.deleteSong(event.id);
        add(LoadSongs());
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });

    on<DeleteAllSongs>((event, emit) async {
      try {
        await _repository.deleteAllSongs();
        add(LoadSongs());
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });
    
    on<UpdateSongsOrder>((event, emit) async {
  try {
    // Пример сохранения нового порядка (можно сохранить порядок в базе данных).
    for (int i = 0; i < event.updatedSongs.length; i++) {
      final updatedSong = event.updatedSongs[i].copy(order: i);
      await _repository.updateSong(updatedSong);
    }

    // После обновления, загружаем обновленный список.
    add(LoadSongs());
  } catch (e) {
    emit(SongsError(e.toString()));
  }
});

  }
}
