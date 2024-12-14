import '../model/groupModel.dart';
import '../model/songsModel.dart';
import 'dbSongs.dart';

class SongsRepository {
  final DBSongs _dbSongs = DBSongs.instance;

  Future<List<Song>> getAllSongs() async => await _dbSongs.readAllSongs();

  Future<void> addSong(Song song) async => await _dbSongs.create(song);
  Future<Song> readSong(int id) async {
    return await _dbSongs.readSong(id);
  }

  Future<void> deleteSong(int id) async => await _dbSongs.delete(id);

  Future<void> deleteAllSongs() async => await _dbSongs.deleteAll();

  Future<void> updateSong(Song song) async => await _dbSongs.update(song);

  Future<int> updateFontSize(int id, double fontSize) async {
    return await _dbSongs.updateFontSizeText(id, fontSize);
  }

  Future<int> updateSpeedScroll(int id, int speedScroll) async {
    return await _dbSongs.updateSpeedScroll(id, speedScroll);
  }

  Future<void> createGroup(GroupModel group) async =>
      await _dbSongs.createGroup(group);

  Future<List<GroupModel>> readAllGroups() async =>
      await _dbSongs.readAllGroups();

  Future<void> updateGroup(GroupModel group) async =>
      await _dbSongs.updateGroup(group);

  Future<void> deleteGroup(int id) async => await _dbSongs.deleteGroup(id);

  // Future<List<Song>> readSongsByGroup(int groupId) async =>
  //     await _dbSongs.readSongsByGroup(groupId);
}
