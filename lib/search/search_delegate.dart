import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
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
  ThemeData appBarTheme(BuildContext context) {

    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),        
      ),
      appBarTheme: const AppBarTheme(
        color: Colors.white,
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query ='', 
        icon: const Icon(Icons.clear, color: Color.fromARGB(255, 114, 47, 55))
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      }, 
      icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 114, 47, 55)),
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    if(_filtro.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            
            Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),

            SizedBox(height: 10),

            Text('Vino no disponible en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            Text('Puedes crearlo y para obtener su valoración.', style: TextStyle(fontSize: 16)),
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

    if (query.isEmpty) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        child: const Center(
          child: Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),
        ),
      );
    }
    
    _filtro = wines.where((wines) {
      return wines.nombre.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    if(_filtro.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            
            Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),

            SizedBox(height: 10),

            Text('Vino no disponible en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            Text('Puedes crearlo para obtener su valoración.', style: TextStyle(fontSize: 16)),
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