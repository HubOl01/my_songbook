import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/songsRepository.dart';
import '../model/songTogroupModel.dart';
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
        final songGroups = await _repository.getSongsGroup();
        emit(SongsLoaded(songs, groups, songGroups));
      } catch (e) {
        emit(SongsError(e.toString()));
      }
    });
    // on<LoadSong>((event, emit) async {
    //   emit(SongsLoading());
    //   try {
    //     final song = await _repository.readSong(event.id);
    //     emit(SongLoaded(song));
    //   } catch (e) {
    //     emit(SongsError(e.toString()));
    //   }
    // });

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
    // on<UpdateFontSize>((event, emit) async {
    //   try {
    //     await _repository.updateFontSize(event.id, event.fontSize);
    //     add(LoadSong(event.id));
    //   } catch (e) {
    //     emit(SongsError(e.toString()));
    //   }
    // });

    // on<UpdateSpeedScroll>((event, emit) async {
    //   try {
    //     await _repository.updateSpeedScroll(event.id, event.speed);
    //     add(LoadSong(event.id));
    //   } catch (e) {
    //     emit(SongsError(e.toString()));
    //   }
    // });

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

    // Song to Group(
    // on<LoadSongToGroup>((event, emit) async {
    //   emit(SongToGroupsLoading());
    //   try {
    //     final songGroups = await _repository.getSongsGroup();
    //     emit(SongToGroupsLoaded(songGroups));
    //     add(LoadSongToGroup());
    //   } catch (e) {
    //     emit(SongToGroupsError(e.toString()));
    //   }
    // });
    on<LoadSongToGroup>((event, emit) async {
      emit(SongToGroupsLoading());
      try {
        final songGroups = await _repository.getSongsByGroup1(event.groupId);
        emit(SongToSongsLoadedForGroup(event.groupId, songGroups));
        add(LoadSongToGroup(groupId: event.groupId));
      } catch (e) {
        emit(SongToGroupsError(e.toString()));
      }
    });

    on<AddSongToGroup>((event, emit) async {
      try {
        await _repository.addSongToGroup(
            event.songId, event.groupId, event.order);
        add(LoadSongToGroup(groupId: event.groupId));
        add(LoadSongs());
      } catch (e) {
        emit(SongToGroupsError(e.toString()));
      }
    });

    on<UpdateSongToGroup>((event, emit) async {
      try {
        await _repository.updateSongOrder(
            event.songId, event.groupId, event.order);
        add(LoadSongToGroup(groupId: event.groupId));
        add(LoadSongs());
      } catch (e) {
        emit(SongToGroupsError(e.toString()));
      }
    });

    on<DeleteSongFromGroup>((event, emit) async {
      try {
        await _repository.removeSongFromGroup(event.songId, event.groupId);
        add(LoadSongToGroup(groupId: event.groupId));
        add(LoadSongs());
      } catch (e) {
        emit(SongToGroupsError(e.toString()));
      }
    });
  }
}
