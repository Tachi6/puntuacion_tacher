import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:diacritic/diacritic.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchDelegateWines extends SearchDelegate{
  SearchDelegateWines({required this.winesList, this.onPressed});

  final List<Wines> winesList;
  final Future<void> Function()? onPressed;
  final String titleLabel = 'Vino no encontrado en base de datos';

  List<Wines> _filtro = [];

  SvgPicture wineIcon(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SvgPicture.asset(
      'assets/wine_bar_full.svg',
      height: 120,
      colorFilter: ColorFilter.mode(colors.onPrimaryFixedVariant, BlendMode.srcIn),
    );
  }

  @override
  String? get searchFieldLabel => 'Buscar vino';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 18, decorationThickness: 0, decoration: TextDecoration.none);

  @override
  List<Widget>? buildActions(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return [
      IconButton(
        onPressed: () => query ='', 
        icon: Icon(Icons.clear, color: colors.onSurface)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: Icon(Icons.arrow_back, color: colors.onSurface),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(_filtro.isEmpty) {
      return NoResultsWine(onPressed: onPressed);
    }

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].nombre),
          subtitle: Text(_filtro[index].tipo),
          onTap: () {
            showResults(context);
            FocusManager.instance.primaryFocus?.unfocus();
            close(context, _filtro[index].copy());
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);

    if (query.isEmpty) {
      _filtro = winesList;
    }
 
    _filtro = winesService.winesByIndex.where((wines) {
      return removeDiacritics(wines.nombre.toLowerCase()).contains(removeDiacritics(query.trim().toLowerCase()));
    }).toList();

    if(_filtro.isEmpty) {
      return NoResultsWine(onPressed: onPressed);
    }

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].nombre),
          subtitle: Text(_filtro[index].tipo),
          onTap: () {
            showResults(context);
            FocusManager.instance.primaryFocus?.unfocus();
            close(context, _filtro[index].copy());
          },
        );
      },
      );
   }
}

class SingleWineImage extends StatelessWidget {
  const SingleWineImage({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SvgPicture.asset(
      'assets/wine_bar_full.svg',
      height: 120,
      colorFilter: ColorFilter.mode(colors.onPrimaryFixedVariant, BlendMode.srcIn),
    );
  }
}

class NoResultsWine extends StatelessWidget {
  const NoResultsWine({super.key, this.onPressed});

  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
        
            Container(
              alignment: Alignment.center,
              height: 40,
              child: const Text(
                'Vino no encontrado', 
                textAlign: TextAlign.center, 
                style: TextStyle(fontSize: 16)
              ),
            ),
            
            const SizedBox(height: 20),
        
            const SingleWineImage(),
        
            const SizedBox(height: 20),

            Visibility(
              visible: onPressed != null,
              child: CustomElevatedButton(
                width: 160,
                height: 40, 
                onPressed: onPressed,
                label: 'Crear nuevo vino',
              ),
            ),
          ],
        ),
      ),
    );
  }
}