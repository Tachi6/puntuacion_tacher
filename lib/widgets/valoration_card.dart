import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';
import 'package:puntuacion_tacher/widgets/rating_details_category.dart';

class ValorationCard extends StatelessWidget {
 
  const ValorationCard({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final List<Wines> wines = winesService.winesLatestTasted;

    return ListView.builder(
      itemCount: wines.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine: wines[index], email: 'latest', source:'latest'));
            Navigator.push(context, routeDetails);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card.filled(
              elevation: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLeadingTile(wine: wines[index]),
            
                  CustomBodyTile(wine: wines[index])
                ],
              )
            ),
          ),
        );
      },
    );
  }
}

class CustomLeadingTile extends StatelessWidget {

  final Wines wine;
  final double circularRadius = 10;

  const CustomLeadingTile({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {

    const String source = 'latest';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LoadWineImage(
        wine: wine, 
        scale: 3/6, 
        imageWidth: 80,
        source: source,
      ),
    );
  }
}

class CustomBodyTile extends StatelessWidget {

  final Wines wine;

  const CustomBodyTile({super.key, required this.wine});

  @override
  Widget build(BuildContext context) {
   
    final String user;

    wine.displayName == '' || wine.displayName == null
      ? user = wine.usuarios.last
      : user = wine.displayName!;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$user cató ${wine.nombre} y lo valoró con ${wine.puntuaciones.last} puntos',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
      
            Text(wine.bodega, style: const TextStyle(fontSize: 14)),

            Text(wine.region, style: const TextStyle(fontSize: 14)),
            
            Text(wine.tipo, style: const TextStyle(fontSize: 14)),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesVista.last)
                      ],
                    ),
                                
                    Row(
                      children: [
                        const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz.last)
                      ],
                    ),
                                
                    Row(
                      children: [
                        const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca.last)
                      ],
                    ),
                  ],
                ),
            
                const Expanded(
                  child: SizedBox(
                  ),
                ),
            
                // Container(
                //   // color: Colors.amber,
                //   alignment: Alignment.bottomRight,
                //   child: Transform.translate(
                //     offset: const Offset(4, 8),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         IconButton(
                //           alignment: Alignment.bottomRight,
                //           iconSize: 24,
                //           onPressed: () {
                //             winesService.likesCount(wine);
                //             // TODO implementar likes en server
                //           },
                //           icon: const Icon(Icons.thumb_up,
                //             color: Color.fromARGB(255, 114, 47, 55)
                //           )
                //         ),
                //         Transform.translate(
                //           offset: const Offset(-4, 6),
                //           child: Container(
                //             alignment: Alignment.bottomLeft,
                //             width: 16,
                //             child: Text(
                //               wine.likes == null ? '' : wine.likes.toString(),
                //               style: TextStyle(color: redColor(), fontSize: 8),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),     
          ],
        ),
      ),
    );
  }
}