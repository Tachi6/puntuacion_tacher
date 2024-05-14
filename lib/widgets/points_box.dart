
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

    return PopScope(
      canPop: false,
      child: AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 20),
        shadowColor:const Color.fromARGB(255, 114, 47, 55),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
        title: const Text('Tacher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Has catado:'),
      
            const SizedBox(height: 16,width: 250,),
      
            Text(wine!.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(wine!.tipo, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      
            const SizedBox(height: 16),
      
            const Text('Tu puntuación:'),
      
            Text('$puntuacionFinal', style: const TextStyle(fontSize: 100))
          ]
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              taste.clearWidgets();
              winesService.selectedWine = null;
      
              Navigator.pushNamed(context, 'home');
            },
            child: const Text('Cerrar', style: TextStyle(color: Colors.black))
          )
        ],
      ),
    );
  }
}
