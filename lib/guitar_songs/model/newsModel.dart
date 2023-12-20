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
        "isDonate": isDonate,
        "isUpdate": isUpdate,
        "textColorClick": textColorClick,
        "isClick": isClick,
        "isShow": isShow,
        "isSupport": isSupport,
        "websiteUrl": websiteUrl,
    };
}
