import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
         child: CircularProgressIndicator(
          color: redColor(),
         ),
      ),
    );
  }
}