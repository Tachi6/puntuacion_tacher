import 'dart:convert';

class Wines {
  int anada;
  String bodega;
  List<String>? comentarios;
  String descripcion;
  String? displayName;
  List<String>? fechas;
  String graduacion;
  String? id;
  String? imagenVino;
  String? logoBodega;
  String nombre;
  String notaBoca;
  String notaNariz;
  String notaVista;
  List<String>? notasBoca;
  List<String>? notasNariz;
  List<String>? notasVista;
  double puntuacionBoca;
  int puntuacionFinal;
  double puntuacionNariz;
  double puntuacionVista;
  List<int>? puntuaciones;
  List<double>? puntuacionesBoca;
  List<double>? puntuacionesNariz;
  List<double>? puntuacionesVista;
  String region;
  String tipo;
  List<String>? usuarios;
  String variedades;
  String vino;

  Wines({
    required this.anada,
    required this.bodega,
    this.comentarios,
    required this.descripcion,
    this.displayName,
    this.fechas,
    required this.graduacion,
    this.id,
    this.imagenVino,
    this.logoBodega,
    required this.nombre,
    required this.notaBoca,
    required this.notaNariz,
    required this.notaVista,
    this.notasBoca,
    this.notasNariz,
    this.notasVista,
    required this.puntuacionBoca,
    required this.puntuacionFinal,
    required this.puntuacionNariz,
    required this.puntuacionVista,
    this.puntuaciones,
    this.puntuacionesBoca,
    this.puntuacionesNariz,
    this.puntuacionesVista,
    required this.region,
    required this.tipo,
    this.usuarios,
    required this.variedades,
    required this.vino,
  });

  factory Wines.fromJson(String str) => Wines.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Wines.fromMap(Map<String, dynamic> json) => Wines(
    anada: json["anada"],
    bodega: json["bodega"],
    comentarios: json["comentarios"] == null ? [] : List<String>.from(json["comentarios"].map((x) => x)),
    descripcion: json["descripcion"],
    displayName: json["displayName"],
    fechas: json["fechas"] == null ? [] : List<String>.from(json["fechas"].map((x) => x)),
    graduacion: json["graduacion"],
    id: json["id"],
    imagenVino: json["imagenVino"],
    logoBodega: json["logoBodega"],
    nombre: json["nombre"],
    notaBoca: json["notaBoca"],
    notaNariz: json["notaNariz"],
    notaVista: json["notaVista"],
    notasBoca: json["notasBoca"] == null ? [] : List<String>.from(json["notasBoca"].map((x) => x)),
    notasNariz: json["notasNariz"] == null ? [] : List<String>.from(json["notasNariz"].map((x) => x)),
    notasVista: json["notasVista"] == null ? [] : List<String>.from(json["notasVista"].map((x) => x)),
    puntuacionBoca: json["puntuacionBoca"]?.toDouble(),
    puntuacionFinal: json["puntuacionFinal"],
    puntuacionNariz: json["puntuacionNariz"]?.toDouble(),
    puntuacionVista: json["puntuacionVista"]?.toDouble(),
    puntuaciones: json["puntuaciones"] == null ? [] : List<int>.from(json["puntuaciones"].map((x) => x)),
    puntuacionesBoca: json["puntuacionesBoca"] == null ? [] : List<double>.from(json["puntuacionesBoca"].map((x) => x?.toDouble())),
    puntuacionesNariz: json["puntuacionesNariz"] == null ? [] : List<double>.from(json["puntuacionesNariz"].map((x) => x?.toDouble())),
    puntuacionesVista: json["puntuacionesVista"] == null ? [] : List<double>.from(json["puntuacionesVista"].map((x) => x?.toDouble())),
    region: json["region"],
    tipo: json["tipo"],
    usuarios: json["usuarios"] == null ? [] : List<String>.from(json["usuarios"].map((x) => x)),
    variedades: json["variedades"],
    vino: json["vino"],
);

  Map<String, dynamic> toMap() => {
    "anada": anada,
    "bodega": bodega,
    "comentarios": comentarios == null ? [] : List<dynamic>.from(comentarios!.map((x) => x)),
    "descripcion": descripcion,
    "displayName": displayName,
    "fechas": fechas == null ? [] : List<dynamic>.from(fechas!.map((x) => x)),
    "graduacion": graduacion,
    "id": id,
    "imagenVino": imagenVino,
    "logoBodega": logoBodega,
    "nombre": '$vino $anada',
    "notaBoca": notaBoca,
    "notaNariz": notaNariz,
    "notaVista": notaVista,
    "notasBoca": notasBoca == null ? [] : List<dynamic>.from(notasBoca!.map((x) => x)),
    "notasNariz": notasNariz == null ? [] : List<dynamic>.from(notasNariz!.map((x) => x)),
    "notasVista": notasVista == null ? [] : List<dynamic>.from(notasVista!.map((x) => x)),
    "puntuacionBoca": puntuacionBoca,
    "puntuacionFinal": puntuacionFinal,
    "puntuacionNariz": puntuacionNariz,
    "puntuacionVista": puntuacionVista,
    "puntuaciones": puntuaciones == null ? [] : List<dynamic>.from(puntuaciones!.map((x) => x)),
    "puntuacionesBoca": puntuacionesBoca == null ? [] : List<dynamic>.from(puntuacionesBoca!.map((x) => x)),
    "puntuacionesNariz": puntuacionesNariz == null ? [] : List<dynamic>.from(puntuacionesNariz!.map((x) => x)),
    "puntuacionesVista": puntuacionesVista == null ? [] : List<dynamic>.from(puntuacionesVista!.map((x) => x)),
    "region": region,
    "tipo": tipo,
    "usuarios": usuarios == null ? [] : List<dynamic>.from(usuarios!.map((x) => x)),
    "variedades": variedades,
    "vino": vino,
  };

  Wines copy() => Wines(
    anada: anada,
    bodega: bodega,
    comentarios: comentarios,
    descripcion: descripcion,
    fechas: fechas,
    graduacion: graduacion,
    id: id,
    imagenVino: imagenVino,
    logoBodega: logoBodega,
    nombre: nombre,
    notaBoca: notaBoca,
    notaNariz: notaNariz,
    notaVista: notaVista,
    notasBoca: notasBoca,
    notasNariz: notasNariz,
    notasVista: notasVista,
    puntuacionBoca: puntuacionBoca,
    puntuacionFinal: puntuacionFinal,
    puntuacionNariz: puntuacionNariz,
    puntuacionVista: puntuacionVista,
    puntuaciones: puntuaciones,
    puntuacionesBoca: puntuacionesBoca,
    puntuacionesNariz: puntuacionesNariz,
    puntuacionesVista: puntuacionesVista,
    region: region,
    tipo: tipo,
    usuarios: usuarios,
    variedades: variedades,
    vino: vino,
  );
  
}


