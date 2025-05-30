import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/router/slide_transition_route.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ListBestScreen extends StatelessWidget {

  final String category;
  final List<Wines> wines;

  const ListBestScreen({required this.category, required this.wines, super.key});

  @override
  Widget build(BuildContext context) {
    
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.surface,
      width: double.infinity,
      height: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 4),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (wines.length < 10) ? wines.length : 10,
              itemBuilder: ( _  , index) {
                return GestureDetector(
                  onTap: () {
                    // Limpio el selected WineTaste
                    if (otherTasteProvider.selectedWineTaste != null) {
                      otherTasteProvider.selectedWineTaste = null;
                    }
                    final newRoute = slidetransitionRoute(context, DetailsScreen(wine: wines[index].copy(), source: 'best-$index'));
                    Navigator.push(context, newRoute);
                  },
                  child: _WinePoster(wine: wines[index], index: index),
                );
              },
            ),
          )
        ]
      ),
    );
  }
}

class _WinePoster extends StatelessWidget {

  final Wines wine;
  final int index;
  final double circularRadius = 10;

  const _WinePoster({required this.wine, required this.index});
  
  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    String wineNameTwoLines() { // TODO entender esta funcion

      final text = wine.nombre;
      TextStyle style = const TextStyle(fontSize: 10, fontWeight: FontWeight.bold);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      
      if (textPainter.size.width > 110) {
        return wine.nombre;
      }
      else {
        return '${wine.vino} \n ${wine.anada}';
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
      height: 150,
      width: size.width * 0.25, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadWineImage(
            wine: wine,
            scale: 0.5,
            imageWidth: size.width * 0.25,
            source: 'best-$index',
          ),

          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.only(left: 2, right: 2,),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  wineNameTwoLines(),
                  softWrap: true,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                ),

                Text(
                  '${wine.puntuacionFinal.toString()} Puntos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colors.outline)
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}