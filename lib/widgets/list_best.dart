import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ListBestScreen extends StatelessWidget {

  final String category;
  final List<Wines> wines;

  const ListBestScreen({required this.category, required this.wines, super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.265,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 4),
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold)
            )
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (wines.length < 10) ? wines.length : 10,
              itemBuilder: ( _  , index) {
                return GestureDetector(
                  onTap: () {
                    final routeDetails = MaterialPageRoute(
                      builder: (context) => DetailsScreen(wine: wines[index], source: 'best')
                    );
                    Navigator.push(context, routeDetails);
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

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    String wineNameTwoLines() { // TODO entender esta funcion

      final text = wine.vino;
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
      height: height * 0.25,
      width: width * 0.25, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LoadWineImage(
            wine: wine, 
            heightReducer: 0.16, 
            widthReducer: 0.25,
            borderRadius: circularRadius,
            source: 'best',
          ),

          SizedBox(height: height * 0.004),

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
                    color: Colors.grey.shade800)
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }
}