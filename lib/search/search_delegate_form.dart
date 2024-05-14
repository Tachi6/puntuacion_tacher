import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/colors.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class WineSearchForm extends SearchDelegate{

  late List<Wines> _filtro;
  
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

    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    if(_filtro.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            
            Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),

            SizedBox(height: 10),

            Text('Vino no encontrado en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            Text('Vuelve atras y crea tu vino a catar.', style: TextStyle(fontSize: 16)),
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
            showResults(context);
            winesService.selectedWine = _filtro[index].copy();
            wineForm.setWineToEdit(winesService.selectedWine!);
            taste.showContinueButton = true;
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    if (query.isEmpty) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        child: const Center(
          child: Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),
        ),
      );
    }
 
    _filtro = winesService.winesByIndex.where((wines) {
      return wines.nombre.toLowerCase().contains(query.trim().toLowerCase());
    }).toList();

    if(_filtro.isEmpty) {
      return const Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            
            Icon(Icons.wine_bar, color: Color.fromARGB(180, 114, 47, 55), size: 140),

            SizedBox(height: 10),

            Text('Vino no encontrado en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            SizedBox(height: 20),

            Text('Vuelve atras y crea tu vino a catar.', style: TextStyle(fontSize: 16)),
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
            showResults(context);
            winesService.selectedWine = _filtro[index].copy();
            wineForm.setWineToEdit(winesService.selectedWine!);
            taste.showContinueButton = true;
            close(context, null);
          },
        );
      },
      );
   }
}