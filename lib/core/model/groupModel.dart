const String tableGroups = 'groups';

class Groups {
  static final List<String> values = [
    id,
    name,
    colorBackground,
    colorForeground,
    orderId,
  ];

  static const String id = '_id';
  static const String name = 'name';
  static const String colorBackground = 'color_background';
  static const String colorForeground = 'color_foreground';
  static const String orderId = 'order_id';
}

// #845CFE
class GroupModel {
  final int? id;
  final String name;
  final String? colorBackground;
  final String? colorForeground;
  final int? orderId;

  GroupModel(
      {this.id,
      required this.name,
      this.colorBackground,
      this.colorForeground,
      this.orderId});
  GroupModel copy({
    int? id,
    String? name,
    String? colorBackground,
    String? colorForeground,
    int? orderId,
  }) =>
      GroupModel(
        id: id ?? this.id,
        name: name ?? this.name,
        colorBackground: colorBackground ?? this.colorBackground,
        colorForeground: colorForeground ?? this.colorForeground,
        orderId: orderId ?? this.orderId,
      );
  static GroupModel fromJson(Map<String, Object?> json) => GroupModel(
        id: json[Groups.id] as int,
        name: json[Groups.name] as String,
        colorBackground: json[Groups.colorBackground] as String?,
        colorForeground: json[Groups.colorForeground] as String?,
        orderId: json[Groups.orderId] as int?,
      );

  Map<String, Object?> toJson() => {
        Groups.id: id,
        Groups.name: name,
        Groups.colorBackground: colorBackground,
        Groups.colorForeground: colorForeground,
        Groups.orderId: orderId,
      };
}
