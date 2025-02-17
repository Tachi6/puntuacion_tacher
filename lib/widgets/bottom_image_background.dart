
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
    this.bottomPadding,
  });

  final String image;
  final double opacity;
  final double? bottomPadding;

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

           if (bottomPadding != null) Container(
            height: 58 + bottomPadding!, // 58 of bottomSheet
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

        ],
      ),
    );
  }
}