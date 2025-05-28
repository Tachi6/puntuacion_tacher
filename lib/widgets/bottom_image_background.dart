
// Image of https://unsplash.com/es/@apolophotographer
// Link https://unsplash.com/es/fotos/bWAHfy-lQVA

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';

class BottomImageBackground extends StatelessWidget {
  const BottomImageBackground({
    super.key, 
    required this.image, 
    required this.opacity,
    required this.bottomFlex,
  });

  final String image;
  final double opacity;
  final int bottomFlex;

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
          const Spacer(
            flex: 4,
          ),
      
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.surface,
                  Colors.white.withAlpha((255 * opacity).toInt()),
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
          ),
   
          Expanded(
            flex: bottomFlex,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withAlpha((255 * opacity).toInt()),
                    colors.surface,
                  ],
                )
              ),
            ),
          ),   
        ],
      ),
    );
  }
}