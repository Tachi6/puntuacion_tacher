import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleOverviewPage extends StatelessWidget {
  const MultipleOverviewPage({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final size = MediaQuery.of(context).size;
    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
    final styles = Theme.of(context).textTheme;
    // 20 of lateral padding
    final newWidth = size.width - 20;
    // Height of StatusBar, AppBar, BottomSheet, 4 x Normal Row, 2 x Thin Row 
    final newHeight = size.height - statusBarHeight - 48 - 58 - 160 - 40;
    final wineTasteList = multipleTaste.anotherUserMultipleTaste(multipleTaste.userView);

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [           
            Container(
              alignment: Alignment.center,
              height: 40,
              child: Text('Resultados de cata', style: styles.titleMedium)
            ),
               
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,
                    child: Text('Vista', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,                         
                    child: Text('Nariz', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,
                    child: Text('Boca', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.16,
                    alignment: Alignment.bottomCenter,
                    child: Text('Puntos', style: styles.bodyMedium),
                  ),
                ],
              ),
            ),
        
            SizedBox(
              height: newHeight / 2,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [   
                      if (index == 0) const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                        ),
                      ),
        
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
                        alignment: Alignment.center,
                        child: Text(
                          multipleTaste.userMultipleTaste[index].nombre,
                          style: styles.bodyMedium
                        ),
                      ),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              ratingCategory: wineTasteList[index].puntosVista,
                              itemSize: 14,
                            ),
                          ),
        
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,                         
                            child: RatingDetailsCategory(
                              ratingCategory: wineTasteList[index].puntosNariz,
                              itemSize: 14,
                            ),
                          ),
        
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              ratingCategory: wineTasteList[index].puntosBoca,
                              itemSize: 14,
                            ),
                          ),
        
                         Container(
                            width: newWidth * 0.16,
                            alignment: Alignment.center,
                            child: Text(
                              wineTasteList[index].puntosFinal.toInt().toString(), 
                              style: styles.titleMedium
                            ),
                          ),
                        ],
                      ),
        
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                    ],
                  );
                },
              ),
            ),
        
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Catas realizadas', style: styles.titleMedium)
            ),
               
            Container(
              margin: const EdgeInsets.only(left: 10),
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: multipleTaste.otherUsersTaste().length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: FilterChip.elevated(
                      showCheckmark: false,
                      label: Text(multipleTaste.otherUsersTaste()[index]),
                      labelStyle: styles.bodySmall,
                      selected: multipleTaste.userView == multipleTaste.otherUsersTaste()[index],
                      onSelected: (value) => multipleTaste.userView = multipleTaste.otherUsersTaste()[index],
                    ),
                  );
                },
              ),
            ),
               
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text('Valoraciones medias de cata', style: styles.titleMedium)),
               
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,
                    child: Text('Vista', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,                         
                    child: Text('Nariz', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.28,
                    alignment: Alignment.bottomCenter,
                    child: Text('Boca', style: styles.bodyMedium),
                  ),
                      
                  Container(
                    width: newWidth * 0.16,
                    alignment: Alignment.bottomCenter,
                    child: Text('Puntos', style: styles.bodyMedium),
                  ),
                ],
              ),
            ),
            
            SizedBox(
              height: newHeight / 2,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
        
                  final List<AverageRatings> averageRatings = [];
                  multipleTaste.multipleTaste.averageRatings.forEach((key, value) => averageRatings.add(value));
        
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [   
                      if (index == 0) const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                        ),
                      ),
        
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
                        alignment: Alignment.center,
                        child: Text(
                          multipleTaste.userMultipleTaste[index].nombre,
                          style: styles.bodyMedium
                        ),
                      ),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              ratingCategory: averageRatings[index].vista,
                              itemSize: 14,
                            ),
                          ),
        
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,                         
                            child: RatingDetailsCategory(
                              ratingCategory: averageRatings[index].nariz,
                              itemSize: 14,
                            ),
                          ),
        
                          Container(
                            width: newWidth * 0.28,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              ratingCategory: averageRatings[index].boca,
                              itemSize: 14,
                            ),
                          ),
        
                          Container(
                            width: newWidth * 0.16,
                            alignment: Alignment.center,
                            child: Text(
                              averageRatings[index].puntos.toString(), 
                              style: styles.titleMedium
                            ),
                          ),
                        ],
                      ),
        
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Height of BottomSHeet
            const SizedBox(height: 58),
          ],
        ),
      ),
    );
  }
}
