import 'dart:convert';

class WineTaste {
  String fecha;
  String id;
  String nombre;
  String user; // TODO deberia venir email + displayName????
  double ratingVista;
  double ratingNariz;
  double ratingBoca;
  double ratingPuntos;
  double puntosVista;
  double puntosNariz;
  double puntosBoca;
  int puntosFinal;
  String? notasVista;
  String? notasNariz;
  String? notasBoca;
  String? comentarios;

  WineTaste({
    required this.fecha,
    required this.id,
    required this.nombre,
    required this.user,
    required this.ratingVista,
    required this.ratingNariz,
    required this.ratingBoca,
    required this.ratingPuntos,
    required this.puntosVista,
    required this.puntosNariz,
    required this.puntosBoca,
    required this.puntosFinal,
    this.notasVista,
    this.notasNariz,
    this.notasBoca,
    this.comentarios,
  });

  factory WineTaste.fromRawJson(String str) => WineTaste.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WineTaste.fromJson(Map<String, dynamic> json) => WineTaste(
    fecha: json["fecha"],
    id: json["id"],
    nombre: json["nombre"],
    user: json["user"],
    ratingVista: json["ratingVista"]?.toDouble(),
    ratingNariz: json["ratingNariz"]?.toDouble(),
    ratingBoca: json["ratingBoca"]?.toDouble(),
    ratingPuntos: json["ratingPuntos"]?.toDouble(),
    puntosVista: json["puntosVista"]?.toDouble(),
    puntosNariz: json["puntosNariz"]?.toDouble(),
    puntosBoca: json["puntosBoca"]?.toDouble(),
    puntosFinal: json["puntosFinal"],
    notasVista: json["notasVista"],
    notasNariz: json["notasNariz"],
    notasBoca: json["notasBoca"],
    comentarios: json["comentarios"],
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
    "puntosVista": puntosVista,
    "puntosNariz": puntosNariz,
    "puntosBoca": puntosBoca,
    "puntosFinal": puntosFinal,
    "notasVista": notasVista,
    "notasNariz": notasNariz,
    "notasBoca": notasBoca,
    "comentarios": comentarios,
  };
}
