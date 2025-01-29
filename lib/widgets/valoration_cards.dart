import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';
import 'package:puntuacion_tacher/widgets/rating_details_category.dart';

class ValorationCards extends StatelessWidget {
 
  const ValorationCards({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    // final List<Wines> wines = winesService.winesLatestTasted;
    final List<WineTaste> winesTasteLatest = winesService.winesTaste;

    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
    
        final WineTaste wineTaste = winesTasteLatest[index];
        final wine = winesService.obtainWine(wineTaste.id);
    
        return GestureDetector(
          onTap: () {
            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine: wine, wineTaste: wineTaste, email: 'latest', source:'latest-$index'));
            Navigator.push(context, routeDetails);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card.filled(
              elevation: 2,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLeadingTile(wine: wine, index: index),
            
                  CustomBodyTile(wine: wine, wineTaste: wineTaste)
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
  final int index;

  const CustomLeadingTile({super.key, required this.wine, required this.index});

  @override
  Widget build(BuildContext context) {

    final String source = 'latest-$index';

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
  final WineTaste wineTaste;

  const CustomBodyTile({
    super.key, 
    required this.wineTaste,
    required this.wine, 
  });

  @override
  Widget build(BuildContext context) {

    final userService = Provider.of<UserServices>(context);
    final String displayName = userService.obtainDisplayName(wineTaste.user);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.only(left: 8, top: 4, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$displayName cató ${wineTaste.nombre} y lo valoró con ${wineTaste.puntosFinal} puntos',
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
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesVista!.last)
                      ],
                    ),
                                
                    Row(
                      children: [
                        const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz!.last)
                      ],
                    ),
                                
                    Row(
                      children: [
                        const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                        RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca!.last)
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