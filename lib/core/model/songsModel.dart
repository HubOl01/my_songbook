// import 'package:flutter/material.dart';

final String tableSongs = 'songs';

class Songs {
  static final List<String> values = [
    id,
    name_song,
    name_singer,
    song,
    path_music,
    date_created,
  ];

  static final String id = '_id';
  static final String name_song = 'name_song';
  static final String name_singer = 'name_singer';
  static final String song = 'song';
  static final String path_music = 'path_music';
  static final String date_created = 'date_created';
}

class Song {
  final int? id;
  final String name_song;
  final String name_singer;
  final String song;
  final String? path_music;
  final DateTime date_created;

  const Song({
    this.id,
    required this.name_song,
    required this.name_singer,
    required this.song,
    this.path_music = '',
    required this.date_created,
  });
  Song copy({
    int? id,
    String? name_song,
    String? name_singer,
    String? song,
    String? path_music,
    DateTime? date_created,
  }) =>
      Song(
        id: id ?? this.id,
        name_song: name_song ?? this.name_song,
        name_singer: name_singer ?? this.name_singer,
        song: song ?? this.song,
        path_music: path_music ?? this.path_music,
        date_created: date_created ?? this.date_created,
      );
  static Song fromJson(Map<String, Object?> json) => Song(
      id: json[Songs.id] as int,
      name_song: json[Songs.name_song] as String,
      name_singer: json[Songs.name_singer] as String,
      song: json[Songs.song] as String,
      path_music: json[Songs.path_music] as String,
      date_created: DateTime.parse(json[Songs.date_created] as String));

  Map<String, Object?> toJson() => {
        Songs.id: id,
        Songs.name_song: name_song,
        Songs.name_singer: name_singer,
        Songs.song: song,
        Songs.path_music: path_music,
        Songs.date_created: date_created.toIso8601String(),
      };
}
