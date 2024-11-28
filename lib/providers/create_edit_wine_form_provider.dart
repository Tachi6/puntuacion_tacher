import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:puntuacion_tacher/helpers/helpers.dart';

import 'package:puntuacion_tacher/models/models.dart';

class CreateEditWineFormProvider extends ChangeNotifier {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final storage = const FlutterSecureStorage();

  late Wines wine;

  String notasVista = '';
  String notasNariz = '';
  String notasBoca = '';
  String comentarios = '';

  double ratingVista = 0;
  double ratingNariz = 0;
  double ratingBoca = 0;
  double ratingPuntos = 0;
  
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
    ratingVista = 0;
    ratingNariz = 0;
    ratingBoca = 0;
    ratingPuntos = 0;
    notifyListeners();
  }

  bool isValidRating() {
    if (ratingVista == 0 || ratingNariz == 0 || ratingBoca == 0 || ratingPuntos == 0) {
      return false;
    }
    return true;
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

    final Formulas formulas = Formulas(ratingVista: ratingVista, ratingNariz: ratingNariz, ratingBoca: ratingBoca, ratingPuntos: ratingPuntos);

    // Puntuacion final para PointsBox
    puntosFinal = formulas.calculosFinal;
    notifyListeners();
    // Añado fechas y usuario
    wine.fechas!.add(CustomDatetime().toText(DateTime.now()));
    wine.usuarios!.add(user);
    // Añado notas de cata y comentarios
    wine.notasVista!.add(notasVista);
    wine.notasNariz!.add(notasNariz);
    wine.notasBoca!.add(notasBoca);
    wine.comentarios!.add(comentarios);
    // Añado puntuaciones globales
    wine.puntuacionesVista!.add(formulas.puntosVista);
    wine.puntuacionesNariz!.add(formulas.puntosNariz);
    wine.puntuacionesBoca!.add(formulas.puntosBoca);
    wine.puntuaciones!.add(puntosFinal);
    notifyListeners();
    // Añado puntuaciones finales
    wine.puntuacionFinal = Formulas.puntuacionFinal(wine.puntuaciones!);
    wine.puntuacionVista = Formulas.puntuacionCategoria(wine.puntuacionesVista!);
    wine.puntuacionNariz = Formulas.puntuacionCategoria(wine.puntuacionesNariz!);
    wine.puntuacionBoca = Formulas.puntuacionCategoria(wine.puntuacionesBoca!);

    notifyListeners();

  }
}