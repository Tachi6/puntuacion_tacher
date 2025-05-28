import 'dart:convert';

import 'package:puntuacion_tacher/models/models.dart';

class MultipleNew {
    String? id;
    String name;
    String description;
    String? password;
    bool hidden;
    String? dateLimit;
    String? tasteQuiz;
    List<String> wineSequence;
    Map<String, Map<String, WineTaste>>? wines;
    Map<String, AverageRatings> averageRatings;

    MultipleNew({
        this.id,
        required this.name,
        required this.description,
        this.password,
        required this.hidden,
        this.dateLimit,
        this.tasteQuiz,
        required this.wineSequence,
        this.wines,
        required this.averageRatings,
    });

    factory MultipleNew.fromRawJson(String str) => MultipleNew.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory MultipleNew.fromJson(Map<String, dynamic> json) => MultipleNew(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        password: json["password"],
        hidden: json["hidden"],
        dateLimit: json["dateLimit"],
        tasteQuiz: json["tasteQuiz"],
        wineSequence: List<String>.from(json["wineSequence"].map((x) => x)),
        wines: json["wines"] == null ? null : Map.from(json["wines"]).map((k, v) => MapEntry<String, Map<String, WineTaste>>(k, Map.from(v).map((k, v) => MapEntry<String, WineTaste>(k, WineTaste.fromJson(v))))),
        averageRatings: Map.from(json["averageRatings"]).map((k, v) => MapEntry<String, AverageRatings>(k, AverageRatings.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "password": password,
        "hidden": hidden,
        "dateLimit": dateLimit,
        "tasteQuiz": tasteQuiz,
        "wineSequence": List<dynamic>.from(wineSequence.map((x) => x)),
        "wines": wines == null ? null : Map.from(wines!).map((k, v) => MapEntry<String, dynamic>(k, Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
        "averageRatings": Map.from(averageRatings).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };

  MultipleNew copy() => MultipleNew(
    id: id,
    name: name, 
    description: description,
    password: password,
    hidden: hidden,
    dateLimit: dateLimit,
    tasteQuiz: tasteQuiz,
    wineSequence: wineSequence,
    wines: wines, 
    averageRatings: averageRatings,
  );
}

class AverageRatings {
    double boca;
    double nariz;
    int puntos;
    double vista;

    AverageRatings({
        required this.boca,
        required this.nariz,
        required this.puntos,
        required this.vista,
    });

    factory AverageRatings.fromRawJson(String str) => AverageRatings.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AverageRatings.fromJson(Map<String, dynamic> json) => AverageRatings(
        boca: json["boca"]?.toDouble(),
        nariz: json["nariz"]?.toDouble(),
        puntos: json["puntos"],
        vista: json["vista"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "boca": boca,
        "nariz": nariz,
        "puntos": puntos,
        "vista": vista,
    };
}
