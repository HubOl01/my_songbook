// import 'package:flutter/material.dart';

const String tableSongs = 'songs';

class Songs {
  static final List<String> values = [
    id,
    name_song,
    name_singer,
    song,
    path_music,
    order,
    group,
    date_created,
  ];

  static const String id = '_id';
  static const String name_song = 'name_song';
  static const String name_singer = 'name_singer';
  static const String song = 'song';
  static const String path_music = 'path_music';
  static const String order = 'orderSong';
  static const String group = 'groupSong';
  static const String date_created = 'date_created';
}

class Song {
  final int? id;
  final String name_song;
  final String name_singer;
  final String song;
  final String? path_music;
  final int? order;
  final int? group;
  final DateTime date_created;

  const Song({
    this.id,
    required this.name_song,
    required this.name_singer,
    required this.song,
    this.path_music = '',
    this.order = 0,
    this.group = 0,
    required this.date_created,
  });
  Song copy({
    int? id,
    String? name_song,
    String? name_singer,
    String? song,
    String? path_music,
    int? order,
    int? group,
    DateTime? date_created,
  }) =>
      Song(
        id: id ?? this.id,
        name_song: name_song ?? this.name_song,
        name_singer: name_singer ?? this.name_singer,
        song: song ?? this.song,
        path_music: path_music ?? this.path_music,
        order: order ?? this.order,
        group: group ?? this.group,
        date_created: date_created ?? this.date_created,
      );
  static Song fromJson(Map<String, Object?> json) => Song(
      id: json[Songs.id] as int,
      name_song: json[Songs.name_song] as String,
      name_singer: json[Songs.name_singer] as String,
      song: json[Songs.song] as String,
      path_music: json[Songs.path_music] as String,
      order: json[Songs.order] as int,
      group: json[Songs.group] as int,
      date_created: DateTime.parse(json[Songs.date_created] as String));

  Map<String, Object?> toJson() => {
        Songs.id: id,
        Songs.name_song: name_song,
        Songs.name_singer: name_singer,
        Songs.song: song,
        Songs.path_music: path_music,
        Songs.order: order,
        Songs.group: group,
        Songs.date_created: date_created.toIso8601String(),
      };
}
