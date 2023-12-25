// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<News> newsFromJson(String str) => List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

String newsToJson(List<News> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class News {
    final String? name;
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
    final String? websiteUrl;

    News({
        this.name,
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
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        name: json["name"],
        user: json["user"],
        lang: json["lang"],
        description: json["description"] == null ? [] : List<String>.from(json["description"]!.map((x) => x)),
        type: json["type"],
        imageUrl: json["imageUrl"],
        audio: json["audio"] == null ? [] : List<Audio>.from(json["audio"]!.map((x) => Audio.fromJson(x))),
        isDonate: json["isDonate"],
        isUpdate: json["isUpdate"],
        textColorClick: json["textColorClick"],
        isClick: json["isClick"],
        isShow: json["isShow"],
        isSupport: json["isSupport"],
        websiteUrl: json["websiteUrl"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "user": user,
        "lang": lang,
        "description": description == null ? [] : List<dynamic>.from(description!.map((x) => x)),
        "type": type,
        "imageUrl": imageUrl,
        "audio": audio == null ? [] : List<dynamic>.from(audio!.map((x) => x.toJson())),
        "isDonate": isDonate,
        "isUpdate": isUpdate,
        "textColorClick": textColorClick,
        "isClick": isClick,
        "isShow": isShow,
        "isSupport": isSupport,
        "websiteUrl": websiteUrl,
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
