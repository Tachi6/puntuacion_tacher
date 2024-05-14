import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/models/models.dart';

class LoadWineImage extends StatelessWidget {

  final Wines wine;
  final double heightReducer;
  final double widthReducer;
  final double borderRadius;
  final String source;

  const LoadWineImage({
    super.key, 
    required this.wine, 
    required this.heightReducer, 
    required this.widthReducer, 
    required this.borderRadius, 
    required this.source, 
  });

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    final double height = size.height;
    final double width = size.width;

    if (wine.imagenVino != null) {
      return Container(
        height: height * heightReducer,
        width: width * widthReducer,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
              bottomLeft: Radius.circular(borderRadius),
              bottomRight: Radius.circular(borderRadius)
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Hero(
          tag: '$source-${wine.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: CachedNetworkImage(
              imageUrl: wine.imagenVino!,
              placeholder: (context, url) {
                return Center(
                  child: CircularProgressIndicator(
                    color: redColor(),
                  ),
                );
              },
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      );
    }
    else {
      return Hero(
        tag: '$source-${wine.id}',
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height * heightReducer,
              width: width * widthReducer,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                    bottomRight: Radius.circular(borderRadius)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: const Image(
                  image: AssetImage('assets/wine_bottle_noimage.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            
            Opacity(
              opacity: 0.95,
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: height * heightReducer * 0.20, right: height * heightReducer * 0.01),
                alignment: Alignment.center,
                height: height * heightReducer * 0.25,
                width: height * heightReducer * 0.19,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wine.vino,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: height * heightReducer * 0.02, color: Colors.black),
                      maxLines: 3,
                    ),
                              
                    SizedBox(
                      height: height * heightReducer * 0.05,
                    ),
                    
                    Text(
                      wine.anada.toString(),
                      style: TextStyle(fontSize: height * heightReducer * 0.02, color: Colors.black),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  }
}