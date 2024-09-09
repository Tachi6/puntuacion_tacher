import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

class ValorationsScreen extends StatelessWidget {
  
  const ValorationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const ValorationCard(),
    );
  }
}
