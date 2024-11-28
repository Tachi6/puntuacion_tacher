import 'package:puntuacion_tacher/models/models.dart';

class WineTasteMapper {
  static winesToWinesTaste({
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
    ratingPuntos: ratingPuntos,
    puntosVista: wine.puntuacionesVista!.last, 
    puntosNariz: wine.puntuacionesNariz!.last, 
    puntosBoca: wine.puntuacionesBoca!.last, 
    puntosFinal: wine.puntuaciones!.last,
    notasVista: wine.notasVista!.last,
    notasNariz: wine.notasNariz!.last,
    notasBoca: wine.notasBoca!.last,
    comentarios: wine.comentarios!.last,
  );
}