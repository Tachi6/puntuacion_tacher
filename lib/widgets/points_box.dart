
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class PointsBox extends StatelessWidget {
  
  final Wines? wine;
  final int puntuacionFinal;
  
  const PointsBox({this.wine, required this.puntuacionFinal, super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final winesService = Provider.of<WinesService>(context);
    final styles = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 20),       
        title: const Text('Tacher'),
        content: SizedBox(
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Has catado:', style: styles.bodyLarge),
                
              const SizedBox(height: 16),
                
              Text(wine!.nombre, style: styles.titleLarge),
              Text(wine!.tipo, style: styles.bodyMedium),
                
              const SizedBox(height: 16),
                
              Text('Tu puntuación:', style: styles.bodyLarge),
                
              Text('$puntuacionFinal', style: styles.displayLarge)
            ]
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              taste.clearWidgets();
              winesService.selectedWine = null;
      
              Navigator.pushNamed(context, 'home');
            },
            child: const Text('Cerrar')
          )
        ],
      ),
    );
  }
}
