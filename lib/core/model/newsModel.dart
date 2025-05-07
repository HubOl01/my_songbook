// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<NewsModel> newsFromJson(String str) =>
    List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));

String newsToJson(List<NewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewsModel {
  final int? id;
  final String? name;
  final String? shortDesc;
  final String? shortImage;
  final String? user;
  final String? lang;
  final List<String>? description;
  final String? type;
  final String? imageUrl;
  final List<Audio>? audio;
  final bool? isDonate;
  final bool? isUpdate;
  final String? textColorClick;
  final bool? isClick;
  final bool? isShow;
  final bool? isSupport;
  final bool? iconClose;
  final bool? iconArrow;
  final bool? iconPro;
  final bool? iconStarred;
  final String? websiteUrl;
  final bool? isButton;
  final Date? date;
  final Button? button;
  final String? createdAt;

  NewsModel({
    this.id,
    this.name,
    this.shortDesc,
    this.shortImage,
    this.user,
    this.lang,
    this.description,
    this.type,
    this.imageUrl,
    this.audio,
    this.isDonate,
    this.isUpdate,
    this.textColorClick,
    this.isClick,
    this.isShow,
    this.isSupport,
    this.websiteUrl,
    this.iconClose,
    this.iconArrow,
    this.iconPro,
    this.iconStarred,
    this.button,
    this.date,
    this.createdAt,
    this.isButton,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"] ?? '',
        name: json["name"] ?? '',
        shortDesc: json["shortDesc"] ?? '',
        shortImage: json["shortImage"] ?? '',
        user: json["user"] ?? '',
        lang: json["lang"] ?? '',
        description: json["description"] == null
            ? []
            : List<String>.from(json["description"]!.map((x) => x)),
        type: json["type"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
        audio: json["audio"] == null
            ? []
            : List<Audio>.from(json["audio"]!.map((x) => Audio.fromJson(x))),
        isDonate: json["isDonate"] ?? false,
        isUpdate: json["isUpdate"] ?? false,
        textColorClick: json["textColorClick"] ?? '',
        isClick: json["isClick"] ?? false,
        isShow: json["isShow"] ?? false,
        isSupport: json["isSupport"] ?? false,
        websiteUrl: json["websiteUrl"] ?? '',
        iconClose: json["iconClose"] ?? false,
        iconArrow: json["iconArrow"] ?? false,
        iconStarred: json["iconStarred"] ?? false,
        iconPro: json["iconPro"] ?? false,
        isButton: json["isButton"],
        date: json["date"] == null ? null : Date.fromJson(json["date"]),
        button: json["button"] == null ? null : Button.fromJson(json["button"]),
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? '',
        "name": name ?? '',
        "shortDesc": shortDesc ?? '',
        "shortImage": shortImage ?? '',
        "user": user ?? '',
        "lang": lang ?? '',
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x)),
        "type": type ?? '',
        "imageUrl": imageUrl ?? '',
        "audio": audio == null
            ? []
            : List<dynamic>.from(audio!.map((x) => x.toJson())),
        "isDonate": isDonate ?? false,
        "isUpdate": isUpdate ?? false,
        "textColorClick": textColorClick ?? '',
        "isClick": isClick ?? false,
        "isShow": isShow ?? false,
        "isSupport": isSupport ?? false,
        "websiteUrl": websiteUrl ?? '',
        "iconClose": iconClose ?? false,
        "iconArrow": iconArrow ?? false,
        "iconStarred": iconStarred ?? false,
        "iconPro": iconPro ?? false,
        "isButton": isButton,
        "date": date?.toJson(),
        "button": button?.toJson(),
        "createdAt": createdAt,
      };
}

class Audio {
  final String? nameSong;
  final String? nameSinger;
  final String? audioUrl;
  final String? nameUrlweb;

  Audio({
    this.nameSong,
    this.nameSinger,
    this.audioUrl,
    this.nameUrlweb,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        nameSong: json["name_song"],
        nameSinger: json["name_singer"],
        audioUrl: json["audioURL"],
        nameUrlweb: json["name_URLWEB"],
      );

  Map<String, dynamic> toJson() => {
        "name_song": nameSong,
        "name_singer": nameSinger,
        "audioURL": audioUrl,
        "name_URLWEB": nameUrlweb,
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
