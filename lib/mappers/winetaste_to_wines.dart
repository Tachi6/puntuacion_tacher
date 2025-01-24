import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/models/models.dart';

class WinesMapper {
  static Wines wineTasteToWines(WineTaste wineTaste, Wines wine, String user) => Wines(
    anada: wine.anada, 
    bodega: wine.bodega, 
    comentarios: [...wine.comentarios!, wineTaste.comentarios ?? ''],
    descripcion: wine.descripcion, 
    fechas: [...wine.fechas!, wineTaste.fecha], 
    graduacion: wine.graduacion,
    id: wineTaste.id,
    nombre: wine.nombre, 
    notaBoca: wine.notaBoca, 
    notaNariz: wine.notaNariz, 
    notaVista: wine.notaVista, 
    notasBoca: [...wine.notasBoca!, wineTaste.notasBoca ?? ''], 
    notasNariz: [...wine.notasNariz!, wineTaste.notasNariz ?? ''], 
    notasVista: [...wine.notasVista!, wineTaste.notasVista ?? ''], 
    puntuacionBoca: Formulas.puntuacionCategoria([...wine.puntuacionesBoca!, wineTaste.puntosBoca]), 
    puntuacionFinal: Formulas.puntuacionFinal([...wine.puntuaciones!, wineTaste.puntosFinal]), 
    puntuacionNariz: Formulas.puntuacionCategoria([...wine.puntuacionesNariz!, wineTaste.puntosNariz]),  
    puntuacionVista: Formulas.puntuacionCategoria([...wine.puntuacionesVista!, wineTaste.puntosVista]), 
    puntuaciones: [...wine.puntuaciones!, wineTaste.puntosFinal], 
    puntuacionesBoca: [...wine.puntuacionesBoca!, wineTaste.puntosBoca], 
    puntuacionesNariz: [...wine.puntuacionesNariz!, wineTaste.puntosNariz], 
    puntuacionesVista: [...wine.puntuacionesVista!, wineTaste.puntosVista], 
    region: wine.region, 
    tipo: wine.tipo, 
    usuarios: [...wine.usuarios!, user], 
    variedades: wine.variedades, 
    vino: wine.vino
  );
}