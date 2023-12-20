// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

List<News> newsFromJson(String str) => List<News>.from(json.decode(str).map((x) => News.fromJson(x)));

String newsToJson(List<News> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class News {
    String name;
    String user;
    String lang;
    List<String> description;
    String type;
    String imageUrl;
    bool isDonate;
    bool isUpdate;
    String textColorClick;
    bool isClick;
    bool isShow;
    bool isSupport;
    String websiteUrl;

    News({
        required this.name,
        required this.user,
        required this.lang,
        required this.description,
        required this.type,
        required this.imageUrl,
        required this.isDonate,
        required this.isUpdate,
        required this.textColorClick,
        required this.isClick,
        required this.isShow,
        required this.isSupport,
        required this.websiteUrl,
    });

    factory News.fromJson(Map<String, dynamic> json) => News(
        name: json["name"],
        user: json["user"],
        lang: json["lang"],
        description: List<String>.from(json["description"].map((x) => x)),
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
        "description": List<dynamic>.from(description.map((x) => x)),
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
