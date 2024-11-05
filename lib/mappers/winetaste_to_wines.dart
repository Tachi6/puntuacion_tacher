import 'package:puntuacion_tacher/models/models.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class WinesMapper {
  static Wines wineTasteToWines(WineTaste wineTaste, Wines wine) {

    final Formulas formulas = Formulas();

    return Wines(
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
      puntuacionBoca: formulas.puntuacionCategoria([...wine.puntuacionesBoca!, wineTaste.puntosBoca]), 
      puntuacionFinal: formulas.puntuacionFinal([...wine.puntuaciones!, wineTaste.puntosFinal]), 
      puntuacionNariz: formulas.puntuacionCategoria([...wine.puntuacionesNariz!, wineTaste.puntosNariz]),  
      puntuacionVista: formulas.puntuacionCategoria([...wine.puntuacionesVista!, wineTaste.puntosVista]), 
      puntuaciones: [...wine.puntuaciones!, wineTaste.puntosFinal], 
      puntuacionesBoca: [...wine.puntuacionesBoca!, wineTaste.puntosBoca], 
      puntuacionesNariz: [...wine.puntuacionesNariz!, wineTaste.puntosNariz], 
      puntuacionesVista: [...wine.puntuacionesVista!, wineTaste.puntosVista], 
      region: wine.region, 
      tipo: wine.tipo, 
      usuarios: [...wine.usuarios!, wineTaste.user], 
      variedades: wine.variedades, 
      vino: wine.vino
    );
  }
}