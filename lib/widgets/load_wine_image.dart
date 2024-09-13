import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:puntuacion_tacher/models/models.dart';

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
    final colors = Theme.of(context).colorScheme;

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

    if (wine.imagenVino != null) {
      return UrlImagePoster(
        source: source, 
        wine: wine,
        scale: scale, 
        imageWidth: imageWidth, 
        borderRadius: borderRadius,
        imageDecoration: imageDecoration(colors),
      );
    }

    else {
      return NoImagePoster(
        source: source, 
        wine: wine, 
        scale: scale, 
        imageWidth: imageWidth,
        borderRadius: borderRadius,
        imageDecoration: imageDecoration(colors),
      );
    }
  }
}

class UrlImagePoster extends StatelessWidget {
  const UrlImagePoster({
    super.key,
    required this.scale,
    required this.imageWidth,
    required this.borderRadius,
    required this.source,
    required this.wine,
    required this.imageDecoration,
  });

  final double scale;
  final double imageWidth;
  final double borderRadius;
  final String source;
  final Wines wine;
  final BoxDecoration imageDecoration;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Container(
      height: scale * 300,
      width: imageWidth,
      decoration: imageDecoration,
      child: Hero(
        tag: '$source-${wine.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: CachedNetworkImage(
            imageUrl: wine.imagenVino!,
            placeholder: (context, url) {
              return Center(
                child: CircularProgressIndicator(
                  color: colors.primary,
                ),
              );
            },
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}

class NoImagePoster extends StatelessWidget {
  const NoImagePoster({
    super.key,
    required this.source,
    required this.wine,
    required this.scale,
    required this.imageWidth,
    required this.borderRadius,
    required this.imageDecoration,
  });

  final String source;
  final Wines wine;
  final double scale;
  final double imageWidth;
  final double borderRadius;
  final BoxDecoration imageDecoration;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '$source-${wine.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: scale * 300,
              width: imageWidth,
              decoration: imageDecoration,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: const Image(
                  image: AssetImage('assets/bottle_noimage.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            
            Container(
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
            )
          ],
        ),
      ),
    );
  }
}