import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/models/models.dart';

class WineTasteMapper {
  static WineTaste tastedWineToWinesTaste({
    required Wines wine,
    required double ratingVista,
    required double ratingNariz,
    required double ratingBoca,
    required double ratingPuntos,
  }) => WineTaste(
    fecha: wine.fechas!.last, 
    id: wine.id!, 
    nombre: wine.nombre, 
    user: wine.usuarios!.last, 
    ratingVista: ratingVista,
    ratingNariz: ratingNariz, 
    ratingBoca: ratingBoca,
    ratingPuntos: ratingPuntos - 1,
    puntosVista: wine.puntuacionesVista!.last, 
    puntosNariz: wine.puntuacionesNariz!.last, 
    puntosBoca: wine.puntuacionesBoca!.last, 
    puntosFinal: wine.puntuaciones!.last,
    notasVista: wine.notasVista!.last,
    notasNariz: wine.notasNariz!.last,
    notasBoca: wine.notasBoca!.last,
    comentarios: wine.comentarios!.last,
  );

  static WineTaste wineSpecsToWinesTaste({
    required Wines wine,
  }) => WineTaste(
    fecha: 'ficha_tecnica', 
    id: wine.id!, 
    nombre: wine.nombre, 
    user: 'Ficha técnica', 
    ratingVista: -1,
    ratingNariz: -1,
    ratingBoca:-1,
    ratingPuntos: -1,
    puntosVista: wine.puntuacionVista, 
    puntosNariz: wine.puntuacionNariz, 
    puntosBoca: wine.puntuacionBoca, 
    puntosFinal: wine.puntuacionFinal,
    notasVista: wine.notaVista,
    notasNariz: wine.notaNariz,
    notasBoca: wine.notaBoca,
    comentarios: wine.descripcion
  );
}