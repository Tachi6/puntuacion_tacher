
import 'package:flutter/material.dart';

class HiddenTaste extends StatelessWidget {

  const HiddenTaste({super.key});

  @override
  Widget build(BuildContext context) {
   
    return const SizedBox(
      height: 85,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cata ciega seleccionada', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          SizedBox(height: 18),

          Text('Añade o crea el vino despues de tu valoración', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}