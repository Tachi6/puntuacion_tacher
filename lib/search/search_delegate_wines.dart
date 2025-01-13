import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchDelegateWines extends SearchDelegate{
  SearchDelegateWines({this.needButton});

  late List<Wines> _filtro;
  final bool? needButton;
  final String titleLabel = 'Vino no encontrado en base de datos';

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
    return [
      IconButton(
        onPressed: () => query ='', 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(_filtro.isEmpty) {
      return NoResultsWine(
        titleLabel: titleLabel,
      );
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

    final winesService = Provider.of<WinesService>(context);

    if (query.isEmpty) return const NoResultsWine();
 
    _filtro = winesService.winesByIndex.where((wines) {
      return wines.nombre.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    if(_filtro.isEmpty) {
      return NoResultsWine(
        titleLabel: titleLabel,
      );
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
  const NoResultsWine({
    super.key, 
    this.titleLabel, 
    this.buttonLabel,
    this.needButton,
  });

  final String? titleLabel;
  final String? buttonLabel;
  final bool? needButton;

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
              child: titleLabel != null
                ? Text(titleLabel!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16))
                : null,
            ),
            
            const SizedBox(height: 20),
        
            const SingleWineImage(),
        
            const SizedBox(height: 20),
        
            buttonLabel != null 
              ? CustomElevatedButton(
                  width: 170,
                  height: 35, 
                  onPressed: () {
                    // TODO pensar como hacrelo para varios sitios


                  },
                  child: const Text('Añadir vino'),
                )
              : const SizedBox(
                height: 35
              ),
          ],
        ),
      ),
    );
  }
}