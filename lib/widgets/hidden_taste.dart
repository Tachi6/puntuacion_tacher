
import 'package:flutter/material.dart';

class HiddenTaste extends StatelessWidget {

  const HiddenTaste({super.key});

  @override
  Widget build(BuildContext context) {
   
    return Container(
      height: 85,
      padding: const EdgeInsets.only(right: 20, left: 20),
      width: double.infinity,
      child: const Column(
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