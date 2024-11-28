import '../model/songsModel.dart';
import 'dbSongs.dart';

class SongsRepository {
  final DBSongs _dbSongs = DBSongs.instance;

  Future<List<Song>> getAllSongs() async {
    return await _dbSongs.readAllSongs();
  }

  Future<void> addSong(Song song) async {
    await _dbSongs.create(song);
  }

  Future<void> deleteSong(int id) async {
    await _dbSongs.delete(id);
  }

  Future<void> deleteAllSongs() async {
    await _dbSongs.deleteAll();
  }

  Future<void> updateSong(Song song) async {
    await _dbSongs.update(song);
  }
}
