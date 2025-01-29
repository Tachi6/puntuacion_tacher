import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/services/services.dart';

class LoadWineImage extends StatelessWidget {

  final Wines wine;
  final double scale;
  final double imageWidth;
  final String source;

  const LoadWineImage({
    super.key, 
    required this.wine, 
    required this.scale, 
    required this.imageWidth, 
    required this.source, 
  });

  @override
  Widget build(BuildContext context) {

    final double borderRadius = 15 * scale;

    return WineImagePoster(
      source: source, 
      wine: wine, 
      scale: scale, 
      imageWidth: imageWidth,
      borderRadius: borderRadius,
    );
  }
}

class WineImagePoster extends StatelessWidget {
  const WineImagePoster({
    super.key,
    required this.source,
    required this.wine,
    required this.scale,
    required this.imageWidth,
    required this.borderRadius,
  });

  final String source;
  final Wines wine;
  final double scale;
  final double imageWidth;
  final double borderRadius;

  BoxDecoration imageDecoration(ColorScheme colors) {
    return BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius)
      ),
      boxShadow: [
        BoxShadow(
          color: colors.outline,
          blurRadius: (1 / scale),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final winesService = Provider.of<WineServices>(context);
    final int wineRatePosition = winesService.winesByRate.indexOf(wine) + 1;
    final colors = Theme.of(context).colorScheme;

    return Hero(
      tag: '$source-${wine.id}',
      child: Material(
        type: MaterialType.transparency,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: scale * 300,
              width: imageWidth,
              decoration: imageDecoration(colors),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: wine.imagenVino == null 
                  ? const _CustomAssetWineImage()
                  : _CustomUrlWineImage(wine: wine)
              ),
            ),
            
            if (wine.imagenVino == null) 
              _CustomWineBottleLabel(scale: scale, wine: wine),
            // 
            if (source.contains('top10') && scale == 1) 
              _CustomTop10Label(borderRadius: borderRadius, wineRatePosition: wineRatePosition),
          ],
        ),
      ),
    );
  }
}

class _CustomUrlWineImage extends StatelessWidget {
  const _CustomUrlWineImage({
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: wine.imagenVino!,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      placeholder: (context, url) {
        return Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        );
      },
      // TODO manejar el error de imagen sin que brinque despues en el Hero, esta manejado desde peticion http en wines service
    );
  }
}

class _CustomAssetWineImage extends StatelessWidget {
  const _CustomAssetWineImage();

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/bottle_noimage.jpg'),
      fit: BoxFit.cover,
    );
  }
}

class _CustomWineBottleLabel extends StatelessWidget {
  const _CustomWineBottleLabel({
    required this.scale,
    required this.wine,
  });

  final double scale;
  final Wines wine;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72 * scale,
      width: 60 * scale,
      margin: EdgeInsets.only(right: 3 * scale, top: 72 * scale),
      padding: EdgeInsets.symmetric(horizontal: 6 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 12 * scale),
      
          Text(
            wine.vino,
            textAlign: TextAlign.center,
            style: TextStyle(color:Colors.black, fontSize: 6 * scale, fontWeight: FontWeight.bold),
            maxLines: 3,
          ),
                    
          const Spacer(),
          
          Text(
            wine.anada.toString(),
            style: TextStyle(color:Colors.black, fontSize: 6 * scale, fontWeight: FontWeight.bold),
          ),
      
          SizedBox(height: 12 * scale),
          
          SizedBox(height: 3 * scale),
        ],
      ),
    );
  }
}

class _CustomTop10Label extends StatelessWidget {
  const _CustomTop10Label({
    required this.borderRadius,
    required this.wineRatePosition,
  });

  final double borderRadius;
  final int wineRatePosition;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context);

    return Positioned(
      top: 0,
      left: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(borderRadius), bottomRight: Radius.circular(borderRadius)),
        child: Container(
          color: colors.onPrimaryFixedVariant,
          height: 48,
          width: 36,
          padding: const EdgeInsets.only(left: 2),
          alignment: Alignment.center,
          child: Text(
            wineRatePosition.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18, color: themeColor.isDarkMode ? colors.inverseSurface : colors.surface),
          ),
        ),
      ),
    );
  }
}