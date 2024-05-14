
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:puntuacion_tacher/models/models.dart';

class CreateEditWineFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  late Wines wine;

  String notasVista = '';
  String notasNariz = '';
  String notasBoca = '';
  String comentarios = '';

  double ratingVista = 5;
  double ratingNariz = 7;
  double ratingBoca = 7;
  double ratingPuntos = 9;
  
  int puntosFinal = 0;

  String user = '';

  CreateEditWineFormProvider() {
    setDefaultCreateWine();
    loadUser();
  }

  void setDefaultCreateWine() {

    wine = Wines(
      id: '-1', 
      anada: -1, 
      bodega: '', 
      comentarios: [], 
      descripcion: '', 
      fechas: [], 
      graduacion: '', 
      nombre: '', 
      notaBoca: '', 
      notaNariz: '', 
      notaVista: '', 
      notasBoca: [], 
      notasNariz: [], 
      notasVista: [], 
      puntuacionBoca: -1, 
      puntuacionFinal: -1, 
      puntuacionNariz: -1, 
      puntuacionVista: -1, 
      puntuaciones: [], 
      puntuacionesBoca: [], 
      puntuacionesNariz: [], 
      puntuacionesVista: [], 
      region: '', 
      tipo: '', 
      usuarios: [], 
      variedades: '', 
      vino: '',
    );

    notifyListeners();
  }

  loadUser() async {
     String? readUser = await storage.read(key: 'email');
     user = readUser!;
  }
  void setWineToEdit(Wines wineToEdit) {
    wine = wineToEdit;
    notifyListeners();
  }


  editRatingVista(double value) {
    ratingVista = value;
    notifyListeners();
  }

  editRatingNariz(double value) {
    ratingNariz = value;
    notifyListeners();
  }

  editRatingBoca(double value) {
    ratingBoca = value;
    notifyListeners();
  }

  editRatingPuntos(double value){
    ratingPuntos = value;
    notifyListeners();
  }

  setDefaultRatings() {
    ratingVista = 5;
    ratingNariz = 7;
    ratingBoca = 7;
    ratingPuntos = 9;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  set editNotasVista(String value){
    notasVista = value;
    notifyListeners();
  }

  set editNotasNariz(String value){
    notasNariz = value;
    notifyListeners();
  }

  set editNotasBoca(String value){
    notasBoca = value;
    notifyListeners();
  }

  set editCommentarios(String value){
    comentarios = value;
    notifyListeners();
  }

  void clearNotas() {
    notasNariz = '';
    notasBoca = '';
    notasVista = '';
    notifyListeners();
  }

  void clearComentarios() {
    comentarios = '';
    notifyListeners();
  }

  void addUpdatesToWine() {

    Formulas formulas = Formulas(ratingVista: ratingVista, ratingNariz: ratingNariz, ratingBoca: ratingBoca, ratingPuntos: ratingPuntos);

    // Puntuacion final para PointsBox
    puntosFinal = formulas.calculosFinal;
    notifyListeners();
    // Añado fechas y usuario
    final DateTime datetime = DateTime.now();
    wine.fechas.add(datetime.toIso8601String());
    wine.usuarios.add(user);
    // Añado notas de cata y comentarios
    wine.notasVista.add(notasVista);
    wine.notasNariz.add(notasNariz);
    wine.notasBoca.add(notasBoca);
    wine.comentarios.add(comentarios);
    // Añado puntuaciones globales
    wine.puntuacionesVista.add(formulas.puntosVista);
    wine.puntuacionesNariz.add(formulas.puntosNariz);
    wine.puntuacionesBoca.add(formulas.puntosBoca);
    wine.puntuaciones.add(puntosFinal);
    notifyListeners();
    // Añado puntuaciones finales
    wine.puntuacionFinal = formulas.puntuacionFinal(wine.puntuaciones);
    wine.puntuacionVista = formulas.puntuacionCategoria(wine.puntuacionesVista);
    wine.puntuacionNariz = formulas.puntuacionCategoria(wine.puntuacionesNariz);
    wine.puntuacionBoca = formulas.puntuacionCategoria(wine.puntuacionesBoca);

    notifyListeners();

  }

}

class Formulas {

  final double ratingVista;
  final double ratingNariz;
  final double ratingBoca;
  final double ratingPuntos;

  Formulas({
    required this.ratingVista,
    required this.ratingNariz,
    required this.ratingBoca,
    required this.ratingPuntos,
  });

  double get calculosVista {
    if (ratingVista == 1) {
      return -1.48;
    }
    else if (ratingVista == 2) {
      return -0.58;
    }
    else if (ratingVista == 3) {
      return 0.32;
    }
    else if (ratingVista == 4) {
      return 1.22;
    }
    else if (ratingVista == 5) {
      return 2.12;
    }
    else if (ratingVista == 6) {
      return 3.02;
    }
    else {
      return 4.00;
    }
  }

  double get calculosNariz {
    if (ratingNariz == 1) {
      return -6.84;
    }
    else if (ratingNariz == 2) {
      return -4.14;
    }
    else if (ratingNariz == 3) {
      return -1.44;
    }
    else if (ratingNariz == 4) {
      return 1.26;
    }
    else if (ratingNariz == 5) {
      return 3.96;
    }
    else if (ratingNariz == 6) {
      return 6.66;
    }
    else if (ratingNariz == 7) {
      return 9.33;
    }
    else if (ratingNariz == 8) {
      return 10.67;
    }
    else {
      return 12.00;
    }
  }

  double get calculosBoca {
    if (ratingBoca == 1) {
      return -13.68;
    }
    else if (ratingBoca == 2) {
      return -8.28;
    }
    else if (ratingBoca == 3) {
      return -2.88;
    }
    else if (ratingBoca == 4) {
      return 2.52;
    }
    else if (ratingBoca == 5) {
      return 7.92;
    }
    else if (ratingBoca == 6) {
      return 13.32;
    }
    else if (ratingBoca == 7) {
      return 18.67;
    }
    else if (ratingBoca == 8) {
      return 21.33;
    }
    else {
      return 24.00;
    }
  }

  double get calculosPuntos {
    return ratingPuntos - 1;
  }

  int get calculosFinal { 

    final double suma = calculosVista + calculosNariz + calculosBoca + calculosPuntos + 50;
    final double correccion = (calculosPuntos - (((calculosVista + calculosNariz + calculosBoca) * 10) / 40)).abs();

    if ( suma < 80 ){
      return (suma + correccion).ceil();
    }
    else {
      return suma.toInt();
    }
  }

  double get puntosVista {
    final double vista = (ratingVista * 5) / 7;
    return double.parse((vista).toStringAsFixed(2));
  }

  double get puntosNariz {
    final double nariz = (ratingNariz * 5) / 9;
    return double.parse((nariz).toStringAsFixed(2));
  }

  double get puntosBoca {
    final double boca = (ratingBoca * 5) / 9;
    return double.parse((boca).toStringAsFixed(2));
  }

  int puntuacionFinal(List<int> puntuaciones) {

    double puntosFinal;
    // Nueva lista parta el calculo
    final List<int> puntosBruto = List.from(puntuaciones);
    // Media de puntos real
    final double averagePuntosBruto = puntosBruto.average;
    // Media de puntos real + 25%
    final puntosMas25P = (averagePuntosBruto + (25 * averagePuntosBruto)/100).ceil();
    // Media de puntos real - 25%
    final puntosMenos25P = (averagePuntosBruto - (25 * averagePuntosBruto)/100).toInt();
    // Eliminar puntos por encima  y por debajo del 25%
    puntosBruto.removeWhere((elimino) => elimino > puntosMas25P);
    puntosBruto.removeWhere((elimino) => elimino < puntosMenos25P);
    // Media de puntos final y comprobacion de la no eliminacion de todos los valores
    if (puntosBruto.isEmpty) {
      puntosFinal = puntuaciones.average;
    } 
    else {
      puntosFinal = puntosBruto.average;
    }
    // Redondeo a entero
    if (averagePuntosBruto >= puntosFinal) {
      return puntosFinal.ceil();    
      }
    else {
      return puntosFinal.toInt();    
    }
  }

  double puntuacionCategoria(List<double> puntuaciones) {
    final puntuacionesMedia = puntuaciones.average;
    return double.parse((puntuacionesMedia).toStringAsFixed(2));
  }

}

