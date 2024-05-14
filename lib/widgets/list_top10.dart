import 'package:flutter/material.dart';

import 'package:card_swiper/card_swiper.dart';
import 'package:puntuacion_tacher/apptheme/colors.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';

class ListTop10 extends StatelessWidget {

  final List<Wines> wines;

  const ListTop10({super.key, required this.wines});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.40 + 10, // oversize by shadows and under points sizedbox
      child: Swiper(
        loop: false,
        itemCount: wines.length >= 10 ? 10 : wines.length,
        layout: SwiperLayout.STACK,
        axisDirection: AxisDirection.right,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final routeDetails = MaterialPageRoute(
                builder: (context) => DetailsScreen(wine: wines[index], source: 'top10'));
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
  final double circularRadius = 20;

  const _WinePosterTop10({required this.wine, required this.index});

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      // decoration: BoxDecoration(
      //   color: Colors.grey.shade50,
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(circularRadius),
      //       topRight: Radius.circular(circularRadius),
      //       bottomLeft: Radius.circular(circularRadius),
      //       bottomRight: Radius.circular(circularRadius)
      //   ),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.5),
      //       spreadRadius: 1,
      //       blurRadius: 1,
      //       offset: const Offset(1, 1), // changes position of shadow
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(circularRadius), topRight: Radius.circular(circularRadius)),
                child: Container(
                  // color: Colors.grey.shade50, // WHITE
                  color: Colors.white,
                  height: height * 0.345,
                  width: width * 0.6,
                ),
              ),
    
              Container(
                // padding: EdgeInsets.only(top: height * 0.013),
                alignment: Alignment.center,
                child: LoadWineImage(
                  wine: wine, 
                  heightReducer: 0.345, // 0.345
                  widthReducer: 0.60,  // 0.60
                  borderRadius: 20,
                  source: 'top10',
                ),
              ),
                
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(circularRadius), bottomRight: Radius.circular(circularRadius)),
                child: Container(
                  color: redColor(),
                  height: 36,
                  width: 36,
                  alignment: Alignment.center,
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
    
          const Expanded(child: SizedBox()),
                    
          Container(
            // color: Colors.grey.shade50,
            color: Colors.white,
            alignment: Alignment.bottomCenter,
            child: Text(
              '${wine.vino} ${wine.anada}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black),
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(circularRadius), bottomRight: Radius.circular(circularRadius)),
            child: Container(
              // color: Colors.grey.shade50,
              color: Colors.white,
              alignment: Alignment.bottomCenter,
              child: Text(
                '${wine.puntuacionFinal.toString()} Puntos',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey.shade800),
                ),
              ),
          ),

          // SizedBox(height:height * 0.01),
        ]
      )
    );
  }
}
