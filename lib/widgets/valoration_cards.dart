import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/router/transitions_route.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ValorationCards extends StatelessWidget {
 
  const ValorationCards({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final List<WineTaste> winesTasteLatest = winesService.winesTaste;
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
    
        final WineTaste wineTaste = winesTasteLatest[index];
        final wine = winesService.obtainWine(wineTaste.id);
    
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colors.primaryContainer,
                    colors.inversePrimary,
                  ]
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: -27,
                    child: Transform.rotate(
                      angle: -0.33,
                      child: Icon(
                        Icons.wine_bar,
                        color: colors.surface.withAlpha(128),
                        size: 225,
                      ),
                    ),
                  ),
            
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomLeadingTile(wine: wine, index: index),
                                  
                          CustomBodyTile(wine: wine, wineTaste: wineTaste)
                        ],
                      ),
                    ],
                  ),
        
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12)))
                    ),
                    onPressed: () {
                      // Asigno el selected WineTaste
                      otherTasteProvider.selectedWineTaste = wineTaste;
                      // Permito ordenar los otherTaste
                      otherTasteProvider.isChangingSelectedWineTaste = false;
                      
                      final newRoute = slidetransitionRoute(context, DetailsScreen(wine: wine.copy(), email: 'latest', source:'latest-$index'));
                      Navigator.push(context, newRoute);
                    },
                    child: const SizedBox(
                    height: 3/6 * 300,
                    width: double.infinity,
                    )
                  ),
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

    final userServices = Provider.of<UserServices>(context);
    final size = MediaQuery.of(context).size;

    final double fontSize = 12;

    String wineNameTwoLines() {

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
      height: 3/6 * 300,
      padding: const EdgeInsets.only(left: 8, right: 8),
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
            children: [
              Text('${wineTaste.puntosFinal}', style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
              Text(' puntos', style: TextStyle(fontSize: fontSize)),
            ],
          ),

          const Spacer(),

          // RatingCategory(rating: wineTaste.puntosVista),

          const Divider(
            height: 6,
          ),

          Text(
            'Catado por ${userServices.obtainDisplayName(wineTaste.user)} hace ${CustomDatetime().timeToNow(wineTaste.fecha)}', 
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
