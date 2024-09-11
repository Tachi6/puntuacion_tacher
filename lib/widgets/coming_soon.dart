import 'package:flutter/material.dart';

class ComingSoon extends StatelessWidget {

  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.only(right: 20, left: 20),
      width: double.infinity,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Opción seleccionada no disponible', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          SizedBox(height: 18),

          Text('Trabajando en ello, pronto estará disponible', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}