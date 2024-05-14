
// Image of https://unsplash.com/es/@apolophotographer
// Link https://unsplash.com/es/fotos/bWAHfy-lQVA

import 'package:flutter/material.dart';

class TasteBackground extends StatelessWidget {

  const TasteBackground({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
          opacity: 0.8,
          image: AssetImage('assets/taste-background.jpg'),
        ), 
      ),
    );
  }
}
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     height: double.infinity,
  //     foregroundDecoration: const BoxDecoration(
  //       image: DecorationImage(
  //         fit: BoxFit.contain,
  //         alignment: Alignment.bottomCenter,
  //         opacity: 0.4,
  //         image: AssetImage('assets/taste-background.jpg'),
  //       ), 
  //     ),
  //   );  
    
    // Container(
    //   alignment: Alignment.bottomCenter,
    //   width: double.infinity,
    //   height: double.infinity,
    //   color: Colors.white,
    //   child: const Opacity(
    //     opacity: 0.4,
    //     child: Image(
    //       image: AssetImage('assets/taste-background.jpg'),
    //     ),
    //   ),
    // );
  
