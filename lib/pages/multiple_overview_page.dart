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

    final size = MediaQuery.of(context).size;
    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
    // 20 of lateral padding
    final newWidth = size.width - 20;
    // Height of StatusBar, AppBar, BottomSheet, 4 x Normal Row, 2 x Thin Row 
    final newHeight = size.height - statusBarHeight - 48 - 58 - 160 - 40;

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: PreviewMultipleTaste(newWidth: newWidth),
      // body: OverviewMultipleTaste(newWidth: newWidth, newHeight: newHeight),
    );
  }
}

class OverviewMultipleTaste extends StatelessWidget {
  const OverviewMultipleTaste({
    super.key,
    required this.newWidth,
    required this.newHeight,
  });

  final double newWidth;
  final double newHeight;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final wineTasteList = multipleTaste.anotherUserMultipleTaste(multipleTaste.userView);

    return SizedBox(
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
                            style: styles.bodyLarge
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
                            style: styles.bodyLarge
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
    );
  }
}

class PreviewMultipleTaste extends StatelessWidget {
  const PreviewMultipleTaste({
    super.key, 
    required this.newWidth
  });

  final double newWidth;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final wineTasteList = multipleTaste.userMultipleTaste;
    final Formulas formulas = Formulas();

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 40,
            child: Text('Resumen de mi cata', style: styles.titleMedium),
          ),

          Expanded(
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
                            child: Text('Final', style: styles.bodyMedium),
                          ),
                        ],
                      ),
                    ),

            
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: newWidth * 0.28,
                          alignment: Alignment.center,
                          child: RatingDetailsCategory(
                            ratingCategory: formulas.puntosVistaFunction(wineTasteList[index].ratingVista),
                            itemSize: 14,
                          ),
                        ),
                  
                        Container(
                          width: newWidth * 0.28,
                          alignment: Alignment.center,                         
                          child: RatingDetailsCategory(
                            ratingCategory: formulas.puntosNarizFunction(wineTasteList[index].ratingNariz),
                            itemSize: 14,
                          ),
                        ),
                  
                        Container(
                          width: newWidth * 0.28,
                          alignment: Alignment.center,
                          child: RatingDetailsCategory(
                            ratingCategory: formulas.puntosBocaFunction(wineTasteList[index].ratingBoca),
                            itemSize: 14,
                          ),
                        ),
                  
                       Container(
                          width: newWidth * 0.16,
                          alignment: Alignment.center,
                          child: Text(
                            wineTasteList[index].ratingPuntos.toInt() == -1 ? '0' : wineTasteList[index].ratingPuntos.toInt().toString(), 
                            style: styles.bodyLarge
                          ),
                        ),
                      ],
                    ),

                    if (wineTasteList[index].notasVista != '' || wineTasteList[index].notasNariz != '' || wineTasteList[index].notasBoca != '') Column(
                      children: [
                        const SizedBox(height: 10),

                        const _InsideListViewText(label: 'Notas de cata'),
                        
                        const SizedBox(height: 5),

                        _InsideListViewText(label: 'Vista: ', content: wineTasteList[index].notasVista),
                        
                        const SizedBox(height: 5),
                        
                        _InsideListViewText(label: 'Nariz: ', content: wineTasteList[index].notasNariz),
                        
                        const SizedBox(height: 5),
                        
                        _InsideListViewText(label: 'Boca: ', content: wineTasteList[index].notasBoca),
                        
                        const SizedBox(height: 5),
                      ],
                    ),
                    
                    const SizedBox(height: 5),

                    if (wineTasteList[index].comentarios != '') Column(
                      children: [

                        const _InsideListViewText(label: 'Comentarios'),
                      
                        const SizedBox(height: 5),
                        
                        _InsideListViewText(label: '', content: wineTasteList[index].comentarios),
                        
                        const SizedBox(height: 5),
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
        ]
      ),
    );
  }
}

class _InsideListViewText extends StatelessWidget {
  const _InsideListViewText({
    required this.label, 
    this.content,
  });

  final String label;
  final String? content;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;


    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        content != null 
          ? '$label$content'
          : label,
        style: content != null 
          ? styles.bodySmall 
          : styles.bodySmall!.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
