import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class WineSearchForm extends SearchDelegate{

  late List<Wines> _filtro;
  
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

    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
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

            const Text('Vino no encontrado en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            const Text('Vuelve atras y crea tu vino a catar.', style: TextStyle(fontSize: 16)),
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
 
    _filtro = winesService.winesByIndex.where((wines) {
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

            const Text('Vino no encontrado en nuestra base de datos.', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 20),

            const Text('Vuelve atras y crea tu vino a catar.', style: TextStyle(fontSize: 16)),
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