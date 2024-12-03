import 'package:bloc/bloc.dart';
import 'package:my_songbook/core/model/groupModel.dart';

import '../data/songsRepository.dart';
import '../model/songsModel.dart';

part 'songs1_state.dart';

class Songs1Cubit extends Cubit<Songs1State> {
  final SongsRepository _repository;

  Songs1Cubit(this._repository) : super(Songs1Initial());

  Future<void> loadSongs() async {
    emit(Songs1Loading());
    try {
      final songs = await _repository.getAllSongs();
      emit(Songs1Loaded(songs));
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  Future<void> loadSongsWithGroups() async {
    emit(Songs1Loading());
    try {
      final songs = await _repository.getAllSongs();
      final groups = await _repository.readAllGroups();
      emit(Songs1LoadedWithGroups(songs, groups));
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  // Future<void> loadSongsByGroup(int groupId) async {
  //   emit(Songs1Loading());
  //   try {
  //     final songs = await _repository.readSongsByGroup(groupId);
  //     emit(Songs1Loaded(songs));
  //   } catch (e) {
  //     emit(Songs1Error(e.toString()));
  //   }
  // }

  Future<void> addSong(Song song) async {
    try {
      await _repository.addSong(song);
      await loadSongs();
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  Future<void> updateSong(Song song) async {
    try {
      await _repository.updateSong(song);
      await loadSongs();
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  Future<void> deleteSong(int id) async {
    try {
      await _repository.deleteSong(id);
      await loadSongs();
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  Future<void> deleteAllSongs() async {
    try {
      await _repository.deleteAllSongs();
      emit(Songs1Loaded([]));
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }

  Future<void> updateSongsOrder(List<Song> updatedSongs) async {
    try {
      for (int i = 0; i < updatedSongs.length; i++) {
        final updatedSong = updatedSongs[i].copy(order: i);
        await _repository.updateSong(updatedSong);
      }
      await loadSongs();
    } catch (e) {
      emit(Songs1Error(e.toString()));
    }
  }
}

