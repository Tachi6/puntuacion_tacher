import 'package:collection/collection.dart';

class Formulas {
  
  double ratingVista;
  double ratingNariz;
  double ratingBoca;
  double ratingPuntos;

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
    final double correccion = (calculosPuntos - (((ratingVista + ratingNariz + ratingBoca) * 10) / 25)).abs();

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

  static int puntuacionFinal(List<int> puntuaciones) {

    double puntosFinal;
    // Nueva lista parta el calculo
    final List<int> puntosBruto = [...puntuaciones];
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

  static double puntuacionCategoria(List<double> puntuaciones) {
    final puntuacionesMedia = puntuaciones.average;
    return double.parse((puntuacionesMedia).toStringAsFixed(2));
  }
}