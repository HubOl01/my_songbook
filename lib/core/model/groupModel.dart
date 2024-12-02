final String tableGroups = 'groups';

class Groups {
  static final List<String> values = [
    id,
    name,
  ];

  static final String id = '_id';
  static final String name = 'name';
}

class GroupModel {
  final int? id;
  final String name;

  GroupModel({this.id, required this.name});
  GroupModel copy({
    int? id,
    String? name,
  }) =>
      GroupModel(id: id ?? this.id, name: name ?? this.name);
  static GroupModel fromJson(Map<String, Object?> json) =>
      GroupModel(id: json[Groups.id] as int, name: json[Groups.name] as String);

  Map<String, Object?> toJson() => {
        Groups.id: id,
        Groups.name: name,
      };
}
