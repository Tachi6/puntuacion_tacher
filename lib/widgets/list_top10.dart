import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';

class ListTop10 extends StatelessWidget {

  final List<Wines> wines;

  const ListTop10({super.key, required this.wines});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 360,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        loop: false,
        itemCount: wines.length >= 10 ? 10 : wines.length,
        layout: SwiperLayout.DEFAULT,
        axisDirection: AxisDirection.right,
        itemHeight: 360,
        itemWidth: 240,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final routeDetails = MaterialPageRoute(
                builder: (context) => DetailsScreen(wine: wines[index], source: 'top10-$index'));
              Navigator.push(context, routeDetails);
            },
            child: _WinePosterTop10(wine: wines[index], index: index),
          );
        }
      ),
    );
  }
}

class _WinePosterTop10 extends StatelessWidget {

  final Wines wine;
  final int index;
  final double circularRadius = 15;

  const _WinePosterTop10({required this.wine, required this.index});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: double.infinity,
      width: double.infinity,
      color: colors.surface,
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(circularRadius), topRight: Radius.circular(circularRadius)),
                child: Container(
                  color: colors.surface,
                  height: 300,
                  width: 240,
                ),
              ),
              
              Container(
                alignment: Alignment.center,
                child: LoadWineImage(
                  wine: wine,
                  scale: 1,
                  imageWidth: 240,
                  source: 'top10-$index',
                ),
              ),
            ],
          ),
    
          const Expanded(child: SizedBox()),
                    
          Container(
            color: colors.surface,
            alignment: Alignment.bottomCenter,
            child: Text(
              wine.nombre,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(circularRadius), bottomRight: Radius.circular(circularRadius)),
            child: Container(
              color: colors.surface,
              alignment: Alignment.bottomCenter,
              child: Text(
                '${wine.puntuacionFinal.toString()} Puntos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colors.outline
                ) //color: Colors.grey.shade800),
              ),
            ),
          ),
        ]
      )
    );
  }
}
