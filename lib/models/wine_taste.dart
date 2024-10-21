import 'dart:convert';

class WineTaste {
  String? fecha;
  String? id;
  String? nombre;
  String user;
  int ratingVista;
  int ratingNariz;
  int ratingBoca;
  int ratingPuntos;
  String? notasVista;
  String? notasNariz;
  String? notasBoca;
  String? comentarios;
  int puntosFinal;

  WineTaste({
    this.fecha,
    this.id,
    this.nombre,
    required this.user,
    required this.ratingVista,
    required this.ratingNariz,
    required this.ratingBoca,
    required this.ratingPuntos,
    this.notasVista,
    this.notasNariz,
    this.notasBoca,
    this.comentarios,
    required this.puntosFinal,
  });

  factory WineTaste.fromRawJson(String str) => WineTaste.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WineTaste.fromJson(Map<String, dynamic> json) => WineTaste(
    fecha: json["fecha"],
    id: json["id"],
    nombre: json["nombre"],
    user: json["user"],
    ratingVista: json["ratingVista"],
    ratingNariz: json["ratingNariz"],
    ratingBoca: json["ratingBoca"],
    ratingPuntos: json["ratingPuntos"],
    notasVista: json["notasVista"],
    notasNariz: json["notasNariz"],
    notasBoca: json["notasBoca"],
    comentarios: json["comentarios"],
    puntosFinal: json["puntosFinal"],
  );

  Map<String, dynamic> toJson() => {
    "fecha": fecha,
    "id": id,
    "nombre": nombre,
    "user": user,
    "ratingVista": ratingVista,
    "ratingNariz": ratingNariz,
    "ratingBoca": ratingBoca,
    "ratingPuntos": ratingPuntos,
    "notasVista": notasVista,
    "notasNariz": notasNariz,
    "notasBoca": notasBoca,
    "comentarios": comentarios,
    "puntosFinal": puntosFinal,
  };
}
