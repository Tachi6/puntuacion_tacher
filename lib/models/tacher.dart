import 'dart:convert';

import 'package:puntuacion_tacher/models/models.dart';

class Tacher {

  Map<String, Wines> tacher;

  Tacher({
    required this.tacher,
  });

  factory Tacher.fromJson(String str) => Tacher.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tacher.fromMap(Map<String, dynamic> json) => Tacher(
    tacher: Map.from(json["tacher"]).map((k, v) => MapEntry<String, Wines>(k, Wines.fromMap(v))),
  );
  
  Map<String, dynamic> toMap() => {
    "tacher": Map.from(tacher).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
  };
}

