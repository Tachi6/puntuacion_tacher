
// Image of https://unsplash.com/es/@apolophotographer
// Link https://unsplash.com/es/fotos/bWAHfy-lQVA

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';

class BottomImageBackground extends StatelessWidget {
  const BottomImageBackground({super.key, required this.image, required this.opacity});

  final String image;
  final double opacity;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    if (themeColor.isDarkMode) {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: colors.surface,
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colors.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
      
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.surface,
                  Colors.white.withOpacity(opacity),
                ],
                
              )
            ),
          ),
      
          SizedBox(
            width: double.infinity,
            child: Opacity(
              opacity: opacity,
              child: Image.asset(
                image,
                alignment: Alignment.bottomCenter,
                fit: BoxFit.fitWidth,
              
              ),
            ),
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
      
            //     fit: BoxFit.fitWidth,
            //     alignment: Alignment.bottomCenter,
            //     opacity: 0.8,
            //     image: AssetImage(
            //       'assets/taste-background.jpg'
            //       ),
            //   ), 
            // ),
          ),
        ],
      ),
    );

    // return Container(
    //   width: double.infinity,
    //   height: double.infinity,
    //   decoration: const BoxDecoration(
    //     image: DecorationImage(

    //       fit: BoxFit.fitWidth,
    //       alignment: Alignment.bottomCenter,
    //       opacity: 0.8,
    //       image: AssetImage(
    //         'assets/taste-background.jpg'
    //         ),
    //     ), 
    //   ),
    // );
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
  
