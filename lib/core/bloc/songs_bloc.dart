import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/songsRepository.dart';
import '../model/songsModel.dart';
import '../model/groupModel.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final SongsRepository _repository;

  SongsBloc(this._repository) : super(SongsLoading()) {
    on<LoadSongs>((event, emit) async {
      emit(SongsLoading());
      try {
        final songs = await _repository.getAllSongs();
        final groups = await _repository.readAllGroups();
        emit(SongsLoaded(songs, groups));
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
        for (int i = 0; i < event.updatedSongs.length; i++) {
          final updatedSong = event.updatedSongs[i].copy(order: i);
          await _repository.updateSong(updatedSong);
        }

        add(LoadSongs());
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });

    on<LoadGroups>((event, emit) async {
      emit(GroupsLoading());
      try {
        final groups = await _repository.readAllGroups();
        emit(GroupsLoaded(groups));
        add(LoadSongs());
      } catch (e) {
        emit(GroupsError(e.toString()));
      }
    });

    on<AddGroup>((event, emit) async {
      try {
        await _repository.createGroup(event.group);
        add(LoadGroups());
        add(LoadSongs());
      } catch (e) {
        emit(GroupsError(e.toString()));
      }
    });

    on<UpdateGroup>((event, emit) async {
      try {
        await _repository.updateGroup(event.group);
        add(LoadGroups());
        add(LoadSongs());
      } catch (e) {
        emit(GroupsError(e.toString()));
      }
    });

    on<DeleteGroup>((event, emit) async {
      try {
        await _repository.deleteGroup(event.groupId);
        add(LoadGroups());
        add(LoadSongs());
      } catch (e) {
        emit(GroupsError(e.toString()));
      }
    });

    // on<LoadSongsByGroup>((event, emit) async {
    //   emit(SongsLoading());
    //   try {
    //     final songs = await _repository.readSongsByGroup(event.groupId);
    //     emit(SongsLoadedForGroup(event.groupId, songs));
    //     add(LoadSongs());
    //   } catch (e) {
    //     emit(GroupsError(e.toString()));
    //   }
    // });
  }
}
