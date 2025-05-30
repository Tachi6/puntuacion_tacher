import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/router/transitions_route.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';

class ListTop10 extends StatelessWidget {

  final List<Wines> wines;

  const ListTop10({super.key, required this.wines});

  @override
  Widget build(BuildContext context) {

    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final size = MediaQuery.of(context).size;
    
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
        itemWidth: size.width * 0.6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Limpio el selected WineTaste
              if (otherTasteProvider.selectedWineTaste != null) {
                otherTasteProvider.selectedWineTaste = null;
              }
              final newRoute = slidetransitionRoute(context, DetailsScreen(wine: wines[index].copy(), source: 'top10-$index'));
              Navigator.push(context, newRoute);
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
    final size = MediaQuery.of(context).size;

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
                  width: size.width * 0.6,
                ),
              ),
              
              Container(
                alignment: Alignment.center,
                child: LoadWineImage(
                  wine: wine,
                  scale: 1,
                  imageWidth: size.width * 0.6,
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
