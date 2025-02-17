import 'dart:convert';

import 'package:puntuacion_tacher/models/models.dart';

class Multiple {
    String name;
    String description;
    String? password;
    bool hidden;
    String? dateLimit;
    String? tasteQuiz;
    List<String> wineSequence;
    Map<String, Map<String, WineTaste>> wines;
    Map<String, AverageRatings> averageRatings;

    Multiple({
        required this.name,
        required this.description,
        this.password,
        required this.hidden,
        this.dateLimit,
        this.tasteQuiz,
        required this.wineSequence,
        required this.wines,
        required this.averageRatings,
    });

    factory Multiple.fromRawJson(String str) => Multiple.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Multiple.fromJson(Map<String, dynamic> json) => Multiple(
        name: json["name"],
        description: json["description"],
        password: json["password"],
        hidden: json["hidden"],
        dateLimit: json["dateLimit"],
        tasteQuiz: json["tasteQuiz"],
        wineSequence: List<String>.from(json["wineSequence"].map((x) => x)),
        wines: Map.from(json["wines"]).map((k, v) => MapEntry<String, Map<String, WineTaste>>(k, Map.from(v).map((k, v) => MapEntry<String, WineTaste>(k, WineTaste.fromJson(v))))),
        averageRatings: Map.from(json["averageRatings"]).map((k, v) => MapEntry<String, AverageRatings>(k, AverageRatings.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "password": password,
        "hidden": hidden,
        "dateLimit": dateLimit,
        "tasteQuiz": tasteQuiz,
        "wineSequence": List<dynamic>.from(wineSequence.map((x) => x)),
        "wines": Map.from(wines).map((k, v) => MapEntry<String, dynamic>(k, Map.from(v).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))),
        "averageRatings": Map.from(averageRatings).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };

  Multiple copy() => Multiple(
    name: name, 
    description: description,
    password: password,
    hidden: hidden,
    dateLimit: dateLimit,
    tasteQuiz: tasteQuiz,
    wineSequence: wineSequence,
    wines: wines, 
    averageRatings: averageRatings
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
