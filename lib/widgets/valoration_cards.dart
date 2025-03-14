import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/load_wine_image.dart';
import 'package:puntuacion_tacher/widgets/rating_details_category.dart';

class ValorationCards extends StatelessWidget {
 
  const ValorationCards({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final List<WineTaste> winesTasteLatest = winesService.winesTaste;
    final colors = Theme.of(context).colorScheme;
    final userServices = Provider.of<UserServices>(context);

    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
    
        final WineTaste wineTaste = winesTasteLatest[index];
        final wine = winesService.obtainWine(wineTaste.id);
    
        return GestureDetector(
          onTap: () {
            // Asigno el selected WineTaste
            otherTasteProvider.selectedWineTaste = wineTaste;
            // Permito ordenar los otherTaste
            otherTasteProvider.isChangingSelectedWineTaste = false;
            
            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine: wine.copy(), email: 'latest', source:'latest-$index'));
            Navigator.push(context, routeDetails);
          },
          child: Card.filled(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top:20, right: 20),
                    child: SvgPicture.asset(
                      'assets/wine_bar_full.svg',
                      height: 135,
                
                      colorFilter: ColorFilter.mode(colors.surfaceContainerHigh, BlendMode.srcIn),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomLeadingTile(wine: wine, index: index),
                                
                        CustomBodyTile(wine: wine, wineTaste: wineTaste)
                      ],
                    ),
                          
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      height: 26,
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(width: 1, color: colors.outlineVariant))
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              'Catado por ${userServices.obtainDisplayName(wineTaste.user)} hace ${CustomDatetime().timeToNow(wineTaste.fecha)}', 
                              style: const TextStyle(fontSize: 11)
                            ),
                          ),
                
                          const Spacer(),
                
                          IconButton(
                            iconSize: 16,
                            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                            onPressed: () {}, // TODO: implement
                            icon: const Icon(Icons.favorite_border)
                          )
                
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LoadWineImage(
        wine: wine, 
        scale: 3/6, 
        imageWidth: size.width * 0.25,
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

    final size = MediaQuery.of(context).size;

    final double fontSize = 12;

    String wineNameTwoLines() { // TODO entender esta funcion

      final text = wineTaste.nombre;
      final TextStyle style = TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      
      if (textPainter.size.width > (size.width * 0.75 - 40)) {
        return wineTaste.nombre;
      }
      else {
        return '${wine.vino}\n${wine.anada}';
      }
    }


    return Container(
      alignment: Alignment.topLeft,
      width: size.width * 0.75 - 40,
      padding: const EdgeInsets.only(left: 8, top: 5.5, right: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wineNameTwoLines(),
            maxLines: 2,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
    
          Text(wine.bodega, style: TextStyle(fontSize: fontSize), overflow: TextOverflow.ellipsis),
        
          Text(wine.region, style: TextStyle(fontSize: fontSize), overflow: TextOverflow.ellipsis),
          
          Text(wine.tipo, style: TextStyle(fontSize: fontSize), overflow: TextOverflow.ellipsis),
        
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: fontSize),)),
                      RatingDetailsCategory(ratingCategory: wine.puntuacionesVista!.last)
                    ],
                  ),
                              
                  Row(
                    children: [
                      SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: fontSize),)),
                      RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz!.last)
                    ],
                  ),
                              
                  Row(
                    children: [
                      SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: fontSize),)),
                      RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca!.last)
                    ],
                  ),
                ],
              ),
          
              const Expanded(
                child: SizedBox(
                ),
              ),
            ],
          ),
          
          Row(
            children: [
              Text('${wineTaste.puntosFinal}', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
              Text(' puntos', style: TextStyle(fontSize: fontSize)),
            ],
          ),  
        ],
      ),
    );
  }
}