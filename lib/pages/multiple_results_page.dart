import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/domain/entities/entities.dart';

import 'package:puntuacion_tacher/helpers/helpers.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleResultsPage extends StatefulWidget {
  const MultipleResultsPage({super.key});

  @override
  State<MultipleResultsPage> createState() => _MultipleResultsPageState();
}

class _MultipleResultsPageState extends State<MultipleResultsPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleProvider = context.watch<MultipleProvider>();
    final size = MediaQuery.of(context).size;
    // 20 of lateral padding
    final newWidth = size.width - 20;

    return Scaffold(
      appBar: CustomMultipleAppBar(
        onPressedBackButton: () => multipleProvider.setandMoveToPage(null),
        onPressedActionButton: () async {
          context.read<MultipleProvider>().reloadMultiple();
          // final Multiple multipleUpdated = await multipleService.loadMultipleToUpdate(multipleTaste.multipleName);
          // multipleTaste.initLoadedMultipleTaste(multipleUpdated);
        },
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (currentChild, previousChildren) {
          return currentChild!;
        },
        child: OverviewMultipleTaste(newWidth: newWidth),
        // multipleTaste.overview
          // ? OverviewMultipleTaste(key: const ValueKey<String>('overviewMultiple'), newWidth: newWidth)
          // : UserMultipleTasteDetails(key: const ValueKey<String>('userDetails'), newWidth: newWidth),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class UsersMultipleTasteDetails extends StatelessWidget {
  const UsersMultipleTasteDetails({
    super.key, 
    required this.newWidth
  });

  final double newWidth;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final wineTasteList = multipleProvider.anotherUserMultipleTaste(multipleProvider.userView);

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: multipleProvider.multipleWines.length,
      itemBuilder: (context, index) {

        final Formulas formulas = Formulas(
          ratingVista: wineTasteList[index].ratingVista,
          ratingNariz: wineTasteList[index].ratingNariz,
          ratingBoca: wineTasteList[index].ratingBoca,
          ratingPuntos: wineTasteList[index].ratingPuntos,
        );

        return _CustomListItem(
          index: index,
          wineName: (multipleProvider.multipleSelected.hidden && !multipleProvider.isMultipleTasted) 
            ? 'Vino a catar a ciegas ${index + 1}' 
            : wineTasteList[index].nombre, 
          vista: formulas.puntosVista,
          nariz: formulas.puntosNariz,
          boca: formulas.puntosBoca,
          puntosOrFinal: wineTasteList[index].ratingPuntos == -1 ? 0 : wineTasteList[index].ratingPuntos.toInt(),
          newWidth: newWidth,
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
          addEndSizedBox: wineTasteList.length - 1 == index ? true : null,
        );
      },
    );
  }
}

class MultipleTasteAverageRatings extends StatelessWidget {
  const MultipleTasteAverageRatings({super.key, required this.newWidth});

  final double newWidth;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();

    return ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: multipleProvider.multipleWines.length,
      itemBuilder: (context, index) {
          
        final List<AverageRatings> averageRatings = multipleProvider.sortAverageRatings();
        
        return _CustomListItem(
          index: index,
          wineName: multipleProvider.multipleWines[index].nombre, 
          vista: averageRatings[index].vista,
          nariz: averageRatings[index].nariz,
          boca: averageRatings[index].boca,
          puntosOrFinal: averageRatings[index].puntos,
          newWidth: newWidth,
          addEndSizedBox: multipleProvider.multipleWines.length - 1 == index ? true : null,
        );
      },
    );
  }
}

class OverviewMultipleTaste extends StatelessWidget {
  const OverviewMultipleTaste({
    super.key,
    required this.newWidth,
  });

  final double newWidth;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final userService = Provider.of<UserServices>(context);

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [           
          const _OtherUsersTaste(),

          const SizedBox(height: 5),

          _OutsideTitle(label: 'Cata de ${userService.obtainDisplayName(multipleProvider.userView)}'),

          _TasteHeader(newWidth: newWidth, lastLabel: 'Final'),

          Expanded(
            flex: 1,
            child: UsersMultipleTasteDetails(newWidth: newWidth),
          ),

          const _OutsideTitle(label: 'Valoraciones medias de cata'),  

          _TasteHeader(newWidth: newWidth, lastLabel: 'Puntos'),
          
          Expanded(
            flex: 1,
            child: MultipleTasteAverageRatings(newWidth: newWidth)
          ),
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
    final multipleProvider = context.watch<MultipleProvider>();
    final List<String> usersList = multipleProvider.allUsersTaste();

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: usersList.length,
        itemBuilder: (context, index) {

          final userService = Provider.of<UserServices>(context);
          final String displayName = userService.obtainDisplayName(usersList[index]);

          return Container(
            margin: EdgeInsets.only(left: 10, right: index + 1 == usersList.length ? 10 : 0),
            child: FilterChip.elevated(
              showCheckmark: false,
              label: Text(displayName),
              labelStyle: styles.bodySmall,
              selected: multipleProvider.userView == usersList[index],
              onSelected: (value) => multipleProvider.userView = usersList[index],
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
    this.itemsDetailsNotes,
    this.itemsDetailsComments,
    this.addEndSizedBox,
  });

  final int index;
  final String wineName;
  final double vista;
  final double nariz;
  final double boca;
  final int puntosOrFinal;
  final double newWidth;
  final Widget? itemsDetailsNotes;
  final Widget? itemsDetailsComments;
  final bool? addEndSizedBox;

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

        if (addEndSizedBox != null) const SafeArea(
          top: false,
          child: SizedBox(height: 10)
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
