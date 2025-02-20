const String tableSongToGroups = 'group_songs';

class SongToGroups {
  static final List<String> values = [
    songId,
    groupId,
    orderId,
  ];

  static const String songId = 'song_id';
  static const String groupId = 'group_id';
  static const String orderId = 'song_order';
}

// #845CFE
class SongToGroupModel {
  final int songId;
  final int groupId;
  final int? orderId;

  SongToGroupModel(
      {required this.songId, required this.groupId, this.orderId});
  SongToGroupModel copy({
    int? songId,
    int? groupId,
    int? orderId,
  }) =>
      SongToGroupModel(
        songId: songId ?? this.songId,
        groupId: groupId ?? this.groupId,
        orderId: orderId ?? this.orderId,
      );
  static SongToGroupModel fromJson(Map<String, Object?> json) =>
      SongToGroupModel(
        songId: json[SongToGroups.songId] as int,
        groupId: json[SongToGroups.groupId] as int,
        orderId: json[SongToGroups.orderId] as int?,
      );

  Map<String, Object?> toJson() => {
        SongToGroups.songId: songId,
        SongToGroups.groupId: groupId,
        SongToGroups.orderId: orderId,
      };
}
