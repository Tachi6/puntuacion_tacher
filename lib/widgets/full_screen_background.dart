
// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';

class FullScreenBackground extends StatelessWidget {
  const FullScreenBackground({
    super.key, 
    required this.image, 
    required this.opacity, 
  });

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
      decoration: BoxDecoration(
        color: colors.surface,
        image: DecorationImage(
          opacity: opacity,
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
          image: AssetImage(image),
        ), 
      ),
    );
  }
}