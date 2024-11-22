import 'package:puntuacion_tacher/models/models.dart';

class WinesToWinetaste {
  static winesToWinesTaste(Wines wine) => WineTaste(
    fecha: wine.fechas!.last, 
    id: wine.id!, 
    nombre: wine.nombre, 
    user: wine.usuarios!.last, 
    ratingVista: 0, // 0 porque no lo necesito
    ratingNariz: 0, 
    ratingBoca: 0, 
    ratingPuntos: 0, 
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