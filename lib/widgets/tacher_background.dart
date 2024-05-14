
// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';

class TacherBackground extends StatelessWidget {
  const TacherBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          opacity: 0.4,
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/tacher-background.jpg'),
        ), 
      ),
    );
  }
}