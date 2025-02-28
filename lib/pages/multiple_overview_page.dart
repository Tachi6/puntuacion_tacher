import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleOverviewPage extends StatefulWidget {
  const MultipleOverviewPage({super.key});

  @override
  State<MultipleOverviewPage> createState() => _MultipleOverviewPageState();
}

class _MultipleOverviewPageState extends State<MultipleOverviewPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleService = Provider.of<MultipleServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final size = MediaQuery.of(context).size;
    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
    // 20 of lateral padding
    final newWidth = size.width - 20;
    // Height of StatusBar, AppBar, BottomSheet, 4 x Normal Row, 2 x Thin Row, 1 SizedBox 5px 
    final newHeight = size.height - statusBarHeight - 48 - 58 - 160 - 40 - 5;

    return Scaffold(
      appBar: CustomMultipleAppBar(
        refreshOverview: () async {
          final Multiple multipleUpdated = await multipleService.loadMultipleToUpdate(multipleTaste.multipleName);
          multipleTaste.initLoadedMultipleTaste(multipleUpdated);
        },
        changeOverview: () => multipleTaste.overview = !multipleTaste.overview,
        allowActionButtons: true
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (currentChild, previousChildren) {
          return currentChild!;
        },
        child: multipleTaste.overview
          ? OverviewMultipleTaste(key: const ValueKey<String>('overviewMultiple'), newWidth: newWidth, newHeight: newHeight)
          : UserMultipleTasteDetails(key: const ValueKey<String>('userDetails'), newWidth: newWidth),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class UserMultipleTasteDetails extends StatelessWidget {
  const UserMultipleTasteDetails({
    super.key, 
    required this.newWidth
  });

  final double newWidth;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final wineTasteList = multipleTaste.userMultipleTaste;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const _OutsideTitle(label: 'Resumen de mi cata'),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: multipleTaste.winesMultipleTaste.length,
              itemBuilder: (context, index) {

                final Formulas formulas = Formulas(
                  ratingVista: wineTasteList[index].ratingVista,
                  ratingNariz: wineTasteList[index].ratingNariz,
                  ratingBoca: wineTasteList[index].ratingBoca,
                  ratingPuntos: wineTasteList[index].ratingPuntos,
                );

                return _CustomListItem(
                  index: index,
                  wineName: (multipleTaste.multipleTaste.hidden && !multipleService.isMultipleTasted) 
                    ? 'Vino a catar a ciegas ${index + 1}' 
                    : wineTasteList[index].nombre, 
                  vista: formulas.puntosVista,
                  nariz: formulas.puntosNariz,
                  boca: formulas.puntosBoca,
                  puntosOrFinal: wineTasteList[index].ratingPuntos == -1 ? 0 : wineTasteList[index].ratingPuntos.toInt(),
                  newWidth: newWidth,
                  tasteHeader: _TasteHeader(newWidth: newWidth, lastLabel: 'Final'),
                  itemsDetailsNotes: (wineTasteList[index].notasVista != '' || wineTasteList[index].notasNariz != '' || wineTasteList[index].notasBoca != '')
                    ? _ItemDetailsNotes(
                      notesVista: wineTasteList[index].notasVista!,
                      notesNariz: wineTasteList[index].notasNariz!,
                      notesBoca: wineTasteList[index].notasBoca!,
                    )
                    : null,
                  itemsDetailsComments: (wineTasteList[index].comentarios != '')
                    ? _ItemDetailsComments(comments: wineTasteList[index].comentarios!)
                    : null,
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

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final wineTasteList = multipleTaste.anotherUserMultipleTaste(multipleTaste.userView);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [           
          const _OutsideTitle(label: 'Resultado de cata'),

          _TasteHeader(newWidth: newWidth, lastLabel: 'Puntos'),

          SizedBox(
            height: newHeight / 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: wineTasteList.length,
              itemBuilder: (context, index) {
                return _CustomListItem(
                  index: index,
                  wineName: wineTasteList[index].nombre, 
                  vista: wineTasteList[index].puntosVista,
                  nariz: wineTasteList[index].puntosNariz,
                  boca: wineTasteList[index].puntosBoca,
                  puntosOrFinal: wineTasteList[index].puntosFinal,
                  newWidth: newWidth,
                );
              },
            ),
          ),

          const _OutsideTitle(label: 'Catas Realizadas'),
             
          const _OtherUsersTaste(),

          const SizedBox(height: 5),

          const _OutsideTitle(label: 'Valoraciones medias de cata'),  

          _TasteHeader(newWidth: newWidth, lastLabel: 'Puntos'),   
          
          SizedBox(
            height: newHeight / 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: wineTasteList.length,
              itemBuilder: (context, index) {
      
                final List<AverageRatings> averageRatings = [];
                multipleTaste.multipleTaste.averageRatings.forEach((key, value) => averageRatings.add(value));
                
                return _CustomListItem(
                  index: index,
                  wineName: wineTasteList[index].nombre, 
                  vista: averageRatings[index].vista,
                  nariz: averageRatings[index].nariz,
                  boca: averageRatings[index].boca,
                  puntosOrFinal: averageRatings[index].puntos,
                  newWidth: newWidth,
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

class _OtherUsersTaste extends StatelessWidget {
  const _OtherUsersTaste();

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: multipleTaste.otherUsersTaste().length,
        itemBuilder: (context, index) {

          final userService = Provider.of<UserServices>(context);
          final String displayName = userService.obtainDisplayName(multipleTaste.otherUsersTaste()[index]); // TODO comprobar que funciona

          return Container(
            margin: EdgeInsets.only(left: 10, right: index + 1 == multipleTaste.otherUsersTaste().length ? 10 : 0),
            child: FilterChip.elevated(
              showCheckmark: false,
              label: Text(displayName),
              labelStyle: styles.bodySmall,
              selected: multipleTaste.userView == multipleTaste.otherUsersTaste()[index],
              onSelected: (value) => multipleTaste.userView = multipleTaste.otherUsersTaste()[index],
            ),
          );
        },
      ),
    );
  }
}

class _CustomListItem extends StatelessWidget {
  const _CustomListItem({
    required this.index,
    required this.wineName, 
    required this.vista, 
    required this.nariz, 
    required this.boca, 
    required this.puntosOrFinal,
    required this.newWidth,
    this.tasteHeader,
    this.itemsDetailsNotes,
    this.itemsDetailsComments,
  });

  final int index;
  final String wineName;
  final double vista;
  final double nariz;
  final double boca;
  final int puntosOrFinal;
  final double newWidth;
  final Widget? tasteHeader;
  final Widget? itemsDetailsNotes;
  final Widget? itemsDetailsComments;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

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
            wineName,
            style: styles.bodyMedium
          ),
        ),

        if (tasteHeader != null) tasteHeader!,
                
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: newWidth * 0.28,
              alignment: Alignment.center,
              child: RatingDetailsCategory(
                ratingCategory: vista,
                itemSize: 14,
              ),
            ),
    
            Container(
              width: newWidth * 0.28,
              alignment: Alignment.center,                         
              child: RatingDetailsCategory(
                ratingCategory: nariz,
                itemSize: 14,
              ),
            ),
    
            Container(
              width: newWidth * 0.28,
              alignment: Alignment.center,
              child: RatingDetailsCategory(
                ratingCategory: boca,
                itemSize: 14,
              ),
            ),
    
          Container(
              width: newWidth * 0.16,
              alignment: Alignment.center,
              child: Text(
                puntosOrFinal.toString(), 
                style: styles.bodyLarge
              ),
            ),
          ],
        ),

        if (itemsDetailsNotes != null) itemsDetailsNotes!,

        if (itemsDetailsComments != null) itemsDetailsComments!,
                  
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),
      ],
    );
  }
}

class _ItemDetailsNotes extends StatelessWidget {
  const _ItemDetailsNotes({
    required this.notesVista, 
    required this.notesNariz, 
    required this.notesBoca
  });

  final String notesVista;
  final String notesNariz;
  final String notesBoca;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        const _InsideListViewText(label: 'Notas de cata'),
        
        const SizedBox(height: 5),

        _InsideListViewText(label: 'Vista: ', content: notesVista),
        
        const SizedBox(height: 5),
        
        _InsideListViewText(label: 'Nariz: ', content: notesNariz),
        
        const SizedBox(height: 5),
        
        _InsideListViewText(label: 'Boca: ', content: notesBoca),
        
        const SizedBox(height: 5),
      ],
    );
  }
}

class _ItemDetailsComments extends StatelessWidget {
  const _ItemDetailsComments({
    required this.comments, 
  });

  final String comments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _InsideListViewText(label: 'Comentarios'),
      
        const SizedBox(height: 5),
        
        _InsideListViewText(label: '', content: comments),
        
        const SizedBox(height: 5),
      ],
    );
  }
}

class _TasteHeader extends StatelessWidget {
  const _TasteHeader({
    required this.newWidth,
    required this.lastLabel,
  });

  final double newWidth;
  final String lastLabel;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    return SizedBox(
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
            child: Text(lastLabel, style: styles.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _OutsideTitle extends StatelessWidget {
  const _OutsideTitle({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;

    return Container(
      alignment: Alignment.center,
      height: 40,
      child: Text(label, style: styles.titleMedium)
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
