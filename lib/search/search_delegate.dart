import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';

class WineSearch extends SearchDelegate{

  final List<Wines> wines;

  late List<Wines> _filtro;

  WineSearch(this.wines);

  @override
  String? get searchFieldLabel => 'Buscar vino';

  @override
  TextStyle? get searchFieldStyle => const TextStyle(fontSize: 16, decorationThickness: 0, decoration: TextDecoration.none);

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

    final colors = Theme.of(context).colorScheme;

    if(_filtro.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            SvgPicture.asset(
              'assets/wine_bar_half.svg',
              height: 120,
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),

            const SizedBox(height: 20),

            const Text('Vino no disponible en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            const Text('Puedes crearlo y para obtener su valoración.', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].nombre),
          subtitle: Text(_filtro[index].tipo),
          onTap: () {
            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine:_filtro[index], source: 'search'));
              Navigator.push(context, routeDetails);
          },
        );
      },
      );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    if (query.isEmpty) {
      return Container(
        color: colors.surface,
        width: double.infinity,
        child: Center(
          child: SvgPicture.asset(
            'assets/wine_bar_half.svg',
            height: 120,
            colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
          ),
        ),
      );
    }
    
    _filtro = wines.where((wines) {
      return wines.nombre.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    if(_filtro.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            SvgPicture.asset(
              'assets/wine_bar_half.svg',
              height: 120,
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),

            const SizedBox(height: 20),

            const Text('Vino no disponible en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            const Text('Puedes crearlo para obtener su valoración.', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _filtro.length,
      itemBuilder: ( _ , index) {
        return ListTile(
          title: Text(_filtro[index].nombre),
          subtitle: Text(_filtro[index].tipo),
          onTap: () {
            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine:_filtro[index], source: 'search'));
              Navigator.push(context, routeDetails);
          },
        );
      },
      );
   }
}