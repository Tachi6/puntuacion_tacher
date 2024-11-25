import 'package:puntuacion_tacher/models/models.dart';

class WineTasteMapper {
  static winesToWinesTaste(Wines wine) => WineTaste(
    fecha: wine.fechas!.last, 
    id: wine.id!, 
    nombre: wine.nombre, 
    user: wine.usuarios!.last, 
    ratingVista: ((wine.puntuacionesVista!.last * 7) / 5).roundToDouble(),
    ratingNariz: ((wine.puntuacionesNariz!.last * 9) / 5).roundToDouble(), 
    ratingBoca: ((wine.puntuacionesBoca!.last * 9) / 5).roundToDouble(), 
    ratingPuntos: wine.puntuaciones!.last >= 80 
      ? ((wine.puntuacionesVista!.last + wine.puntuacionesNariz!.last + wine.puntuacionesBoca!.last + 50) - wine.puntuaciones!.last).ceilToDouble()
      : 0, // TODO obtener este valor 
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