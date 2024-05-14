import 'dart:convert';

class Wines {

  int anada;
  String bodega;
  List<String> comentarios;
  String descripcion;
  String? displayName;
  List<String> fechas;
  String graduacion;
  String? id;
  String? imagenVino;
  int? likes;
  String? logoBodega;
  String nombre;
  String notaBoca;
  String notaNariz;
  String notaVista;
  List<String> notasBoca;
  List<String> notasNariz;
  List<String> notasVista;
  double puntuacionBoca;
  int puntuacionFinal;
  double puntuacionNariz;
  double puntuacionVista;
  List<int> puntuaciones;
  List<double> puntuacionesBoca;
  List<double> puntuacionesNariz;
  List<double> puntuacionesVista;
  String region;
  String tipo;
  List<String> usuarios;
  String variedades;
  String vino;

  Wines({
    required this.anada,
    required this.bodega,
    required this.comentarios,
    required this.descripcion,
    this.displayName,
    required this.fechas,
    required this.graduacion,
    this.id,
    this.imagenVino,
    this.likes,
    this.logoBodega,
    required this.nombre,
    required this.notaBoca,
    required this.notaNariz,
    required this.notaVista,
    required this.notasBoca,
    required this.notasNariz,
    required this.notasVista,
    required this.puntuacionBoca,
    required this.puntuacionFinal,
    required this.puntuacionNariz,
    required this.puntuacionVista,
    required this.puntuaciones,
    required this.puntuacionesBoca,
    required this.puntuacionesNariz,
    required this.puntuacionesVista,
    required this.region,
    required this.tipo,
    required this.usuarios,
    required this.variedades,
    required this.vino,
  });

  factory Wines.fromJson(String str) => Wines.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Wines.fromMap(Map<String, dynamic> json) => Wines(
    anada: json["anada"],
    bodega: json["bodega"],
    comentarios: List<String>.from(json["comentarios"].map((x) => x)),
    descripcion: json["descripcion"],
    displayName: json["displayName"],
    fechas: List<String>.from(json["fechas"].map((x) => x)),
    graduacion: json["graduacion"],
    id: json["id"],
    imagenVino: json["imagen_vino"],
    likes: json["likes"],
    logoBodega: json["logo_bodega"],
    nombre: json["nombre"],
    notaBoca: json["nota_boca"],
    notaNariz: json["nota_nariz"],
    notaVista: json["nota_vista"],
    notasBoca: List<String>.from(json["notas_boca"].map((x) => x)),
    notasNariz: List<String>.from(json["notas_nariz"].map((x) => x)),
    notasVista: List<String>.from(json["notas_vista"].map((x) => x)),
    puntuacionBoca: json["puntuacion_boca"]?.toDouble(),
    puntuacionFinal: json["puntuacion_final"],
    puntuacionNariz: json["puntuacion_nariz"]?.toDouble(),
    puntuacionVista: json["puntuacion_vista"]?.toDouble(),
    puntuaciones: List<int>.from(json["puntuaciones"].map((x) => x)),
    puntuacionesBoca: List<double>.from(json["puntuaciones_boca"].map((x) => x?.toDouble())),
    puntuacionesNariz: List<double>.from(json["puntuaciones_nariz"].map((x) => x?.toDouble())),
    puntuacionesVista: List<double>.from(json["puntuaciones_vista"].map((x) => x?.toDouble())),
    region: json["region"],
    tipo: json["tipo"],
    usuarios: List<String>.from(json["usuarios"].map((x) => x)),
    variedades: json["variedades"],
    vino: json["vino"],
);

  Map<String, dynamic> toMap() => {
    "anada": anada,
    "bodega": bodega,
    "comentarios": List<dynamic>.from(comentarios.map((x) => x)),
    "descripcion": descripcion,
    "displayName": displayName,
    "fechas": List<dynamic>.from(fechas.map((x) => x)),
    "graduacion": graduacion,
    "id": id,
    "imagen_vino": imagenVino,
    "likes": likes,
    "logo_bodega": logoBodega,
    "nombre": '$vino $anada',
    "nota_boca": notaBoca,
    "nota_nariz": notaNariz,
    "nota_vista": notaVista,
    "notas_boca": List<dynamic>.from(notasBoca.map((x) => x)),
    "notas_nariz": List<dynamic>.from(notasNariz.map((x) => x)),
    "notas_vista": List<dynamic>.from(notasVista.map((x) => x)),
    "puntuacion_boca": puntuacionBoca,
    "puntuacion_final": puntuacionFinal,
    "puntuacion_nariz": puntuacionNariz,
    "puntuacion_vista": puntuacionVista,
    "puntuaciones": List<dynamic>.from(puntuaciones.map((x) => x)),
    "puntuaciones_boca": List<dynamic>.from(puntuacionesBoca.map((x) => x)),
    "puntuaciones_nariz": List<dynamic>.from(puntuacionesNariz.map((x) => x)),
    "puntuaciones_vista": List<dynamic>.from(puntuacionesVista.map((x) => x)),
    "region": region,
    "tipo": tipo,
    "usuarios": List<dynamic>.from(usuarios.map((x) => x)),
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
    // likes: likes // TODO creo que no es necesario mandar el like en el copy, pues solo es para catar
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


