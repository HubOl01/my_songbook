// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

// import 'dart:convert';

// List<NewsModel> newsFromJson(String str) =>
//     List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

// String newsToJson(List<NewsModel> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// // "id": 1,
// //     "version_app": 130,
// //     "isShow": false,
// //     "name": "Оцените приложение",
// //     "sortDesc": "Оцените приложение в RuStore",
// //     "isStarred": true,
// //     "description": ["Оцените приложение в RuStore", "fasdfafdsf"],
// //     "user": "ru-developer",
// //     "lang": "ru",
// //     "imageUrl": "",
// //     "audio": [],
// //     "isDonate": false,
// //     "isUpdate": false,
// //     "textColorClick": "0xFFFFFFFF",
// //     "isClick": false,
// //     "isSupport": false,
// //     "isPremium": false,
// //     "websiteUrl": ""
// class NewsModel {
//   final int? id;
//   final int? version_app;
//   final bool? isShow;
//   final String? name;
//   final String? shortDesc;
//   final List<String>? description;
//   final String? user;
//   final String? lang;
//   final String? type;
//   final String? imageUrl;
//   final List<Audio>? audio;
//   final bool? isStarred;
//   final bool? isDonate;
//   final bool? isUpdate;
//   final String? textColorClick;
//   final bool? isClick;
//   final bool? isSupport;
//   final bool? isPremium;
//   final String? websiteUrl;

//   NewsModel({
//     this.id,
//     this.version_app,
//     this.name,
//     this.shortDesc,
//     this.description,
//     this.user,
//     this.lang,
//     this.isStarred,
//     this.type,
//     this.imageUrl,
//     this.audio,
//     this.isDonate,
//     this.isUpdate,
//     this.textColorClick,
//     this.isClick,
//     this.isShow,
//     this.isSupport,
//     this.websiteUrl,
//     this.isPremium,
//   });

//   factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
//         id: json["id"] ?? 0,
//         version_app: json["version_app"] ?? 0,
//         name: json["name"] ?? '',
//         shortDesc: json["shortDesc"] ?? '',
//         user: json["user"] ?? '',
//         lang: json["lang"] ?? '',
//         description: json["description"] == null
//             ? []
//             : List<String>.from(json["description"]!.map((x) => x)),
//         type: json["type"] ?? '',
//         imageUrl: json["imageUrl"] ?? '',
//         audio: json["audio"] == null
//             ? []
//             : List<Audio>.from(json["audio"]!.map((x) => Audio.fromJson(x))),
//         isStarred: json["isStarred"] ?? false,
//         isDonate: json["isDonate"] ?? false,
//         isUpdate: json["isUpdate"] ?? false,
//         textColorClick: json["textColorClick"] ?? '',
//         isClick: json["isClick"] ?? false,
//         isShow: json["isShow"] ?? false,
//         isSupport: json["isSupport"] ?? false,
//         websiteUrl: json["websiteUrl"] ?? '',
//         isPremium: json["isPremium"] ?? false,
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id ?? 0,
//         "version_app": version_app ?? 0,
//         "name": name ?? '',
//         "shortDesc": shortDesc ?? '',
//         "description": description == null
//             ? []
//             : List<dynamic>.from(description!.map((x) => x)),
//         "user": user ?? '',
//         "lang": lang ?? '',
//         "type": type ?? '',
//         "imageUrl": imageUrl ?? '',
//         "audio": audio == null
//             ? []
//             : List<dynamic>.from(audio!.map((x) => x.toJson())),
//         "isDonate": isDonate ?? false,
//         "isUpdate": isUpdate ?? false,
//         "textColorClick": textColorClick ?? '',
//         "isClick": isClick ?? false,
//         "isShow": isShow ?? false,
//         "isSupport": isSupport ?? false,
//         "websiteUrl": websiteUrl ?? '',
//         "isStarred": isStarred ?? false,
//         "isPremium": isPremium ?? false,
//       };
// }

// To parse this JSON data, do
//
//     final ruIsuct = ruIsuctFromJson(jsonString);
// To parse this JSON data, do
//
//     final newsModel = newsModelFromJson(jsonString);

import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  final int? id;
  final int? versionApp;
  final bool? isShow;
  final String? name;
  final String? shortDesc;
  final bool? isStarred;
  final List<String>? description;
  final String? user;
  final String? lang;
  final String? type;
  final String? iconUrl;
  final String? iconDarkUrl;
  final String? imageUrl;
  final List<Audio>? audio;
  final bool? isDonate;
  final bool? isUpdate;
  final bool? isButton;
  final Button? button;
  final bool? isDate;
  final Date? date;
  final String? textColorClick;
  final bool? isClick;
  final bool? isSupport;
  final bool? isPremium;
  final String? websiteUrl;

  NewsModel({
    this.id,
    this.versionApp,
    this.isShow,
    this.name,
    this.shortDesc,
    this.isStarred,
    this.description,
    this.user,
    this.lang,
    this.type,
    this.iconUrl,
    this.iconDarkUrl,
    this.imageUrl,
    this.audio,
    this.isDonate,
    this.isUpdate,
    this.button,
    this.isButton,
    this.textColorClick,
    this.isDate,
    this.date,
    this.isClick,
    this.isSupport,
    this.isPremium,
    this.websiteUrl,
  });

  NewsModel copyWith({
    int? id,
    int? versionApp,
    bool? isShow,
    String? name,
    String? shortDesc,
    bool? isStarred,
    List<String>? description,
    String? user,
    String? lang,
    String? type,
    String? iconUrl,
    String? iconDarkUrl,
    String? imageUrl,
    List<Audio>? audio,
    bool? isDonate,
    bool? isUpdate,
    Button? button,
    bool? isButton,
    String? textColorClick,
    bool? isDate,
    Date? date,
    bool? isClick,
    bool? isSupport,
    bool? isPremium,
    String? websiteUrl,
  }) =>
      NewsModel(
        id: id ?? this.id,
        versionApp: versionApp ?? this.versionApp,
        isShow: isShow ?? this.isShow,
        name: name ?? this.name,
        shortDesc: shortDesc ?? this.shortDesc,
        isStarred: isStarred ?? this.isStarred,
        description: description ?? this.description,
        user: user ?? this.user,
        lang: lang ?? this.lang,
        type: type ?? this.type,
        iconUrl: iconUrl ?? this.iconUrl,
        iconDarkUrl: iconDarkUrl ?? this.iconDarkUrl,
        imageUrl: imageUrl ?? this.imageUrl,
        audio: audio ?? this.audio,
        isDonate: isDonate ?? this.isDonate,
        isButton: isButton ?? this.isButton,
        button: button ?? this.button,
        isUpdate: isUpdate ?? this.isUpdate,
        isDate: isDate ?? this.isDate,
        date: date ?? this.date,
        textColorClick: textColorClick ?? this.textColorClick,
        isClick: isClick ?? this.isClick,
        isSupport: isSupport ?? this.isSupport,
        isPremium: isPremium ?? this.isPremium,
        websiteUrl: websiteUrl ?? this.websiteUrl,
      );

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"],
        versionApp: json["version_app"],
        isShow: json["isShow"],
        name: json["name"],
        shortDesc: json["shortDesc"],
        isStarred: json["isStarred"],
        description: List<String>.from(json["description"].map((x) => x)),
        user: json["user"],
        lang: json["lang"],
        type: json["type"],
        iconUrl: json["iconUrl"],
        iconDarkUrl: json["iconDarkUrl"],
        imageUrl: json["imageUrl"],
        audio: List<Audio>.from(json["audio"].map((x) => x)),
        isDonate: json["isDonate"],
        isButton: json["isButton"],
        button: json["button"] == null ? null : Button.fromJson(json["button"]),
        isDate: json["isDate"],
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
        isUpdate: json["isUpdate"],
        textColorClick: json["textColorClick"],
        isClick: json["isClick"],
        isSupport: json["isSupport"],
        isPremium: json["isPremium"],
        websiteUrl: json["websiteUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "version_app": versionApp,
        "isShow": isShow,
        "name": name,
        "shortDesc": shortDesc,
        "isStarred": isStarred,
        "description": List<String?>.from(description!.map((x) => x)),
        "user": user,
        "lang": lang,
        "type": type,
        "iconUrl": iconUrl,
        "iconDarkUrl": iconDarkUrl,
        "imageUrl": imageUrl,
        "audio": List<Audio?>.from(audio!.map((x) => x)),
        "isDonate": isDonate,
        "isButton": isButton,
        "button": button?.toJson(),
        "isDate": isDate,
        "date": date?.toJson(),
        "isUpdate": isUpdate,
        "textColorClick": textColorClick,
        "isClick": isClick,
        "isSupport": isSupport,
        "isPremium": isPremium,
        "websiteUrl": websiteUrl,
      };
}

class Audio {
  final String? nameSong;
  final String? nameSinger;
  final String? audioUrl;
  final String? nameUrlWeb;

  Audio({
    this.nameSong,
    this.nameSinger,
    this.audioUrl,
    this.nameUrlWeb,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        nameSong: json["name_song"],
        nameSinger: json["name_singer"],
        audioUrl: json["audioURL"],
        nameUrlWeb: json["name_URLWEB"],
      );

  Map<String, dynamic> toJson() => {
        "name_song": nameSong,
        "name_singer": nameSinger,
        "audioURL": audioUrl,
        "name_URLWEB": nameUrlWeb,
      };
}

class Button {
  final String? buttonName;
  final String? buttonUrl;
  final String? buttonColorForeground;
  final String? buttonColorBackground;

  Button({
    this.buttonName,
    this.buttonUrl,
    this.buttonColorForeground,
    this.buttonColorBackground,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        buttonName: json["button_name"],
        buttonUrl: json["button_url"],
        buttonColorForeground: json["button_color_foreground"],
        buttonColorBackground: json["button_color_background"],
      );

  Map<String, dynamic> toJson() => {
        "button_name": buttonName,
        "button_url": buttonUrl,
        "button_color_foreground": buttonColorForeground,
        "button_color_background": buttonColorBackground,
      };
}

class Date {
  final String? startAt;
  final String? closeAt;

  Date({
    this.startAt,
    this.closeAt,
  });

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        startAt: json["startAt"],
        closeAt: json["closeAt"],
      );

  Map<String, dynamic> toJson() => {
        "startAt": startAt,
        "closeAt": closeAt,
      };
}
