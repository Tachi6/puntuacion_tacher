import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/mappers/mappers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SingleTacherScreen extends StatelessWidget {
  const SingleTacherScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);

    return TacherScreen(
      appBarTitle: wineForm.wine.nombre == '' ? 'Vino catado a ciegas' : wineForm.wine.nombre,
      onPressedBackButon: () {
        wineForm.resetSettings();
        Navigator.pop(context);
      }, 
      bottomSheet: CustomBottomSheet(
        widgetButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          layoutBuilder: (currentChild, previousChildren) {
            return currentChild!;
          },
          child: wineForm.wine.nombre == '' 
            ? const HiddenTasteButtons(key: ValueKey<String>('hiddenTasteButtons'))
            : const SendTasteButton(key: ValueKey<String>('SendTasteButton')), 
        ),
      ),
    );
  }
}

class SendTasteButton extends StatelessWidget {
  const SendTasteButton({super.key});

  void showCustomDialog(BuildContext context, {required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final winesService = Provider.of<WineServices>(context);

    return CustomElevatedButton(
      width: 120,
      label: 'Valorar',
      isSendingLabel: 'Valorando',
      onPressed: () async {
        // Verifico si se has rellenado todos los campos del formulario
        if (!wineForm.isValidRating()) {
          NotificationServices.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
          return;
        }
        // Actualizo info del wine desde server
        final Wines wineFromServer = await winesService.loadWine(wineForm.wine.id!);
        // Mando updates de los diferentes campos al wine y creo el wineTaste
        wineForm.addUpdatesToWine(wineFromServer);
        // Creo el wineTaste
        final WineTaste wineTaste = WineTasteMapper.tastedWineToWinesTaste(
          wine: wineForm.wine,
          ratingVista: wineForm.ratingVista,
          ratingNariz: wineForm.ratingNariz,
          ratingBoca: wineForm.ratingBoca,
          ratingPuntos: wineForm.ratingPuntos,              
        );
        // Actualizo el server con wine y añado nuevo wineTaste
        await winesService.updateWine(wineForm.wine);
        await winesService.saveTastedWine(wineTaste);
        // Lanzo la confirmacion
        if (context.mounted) showCustomDialog(context, child: PointsBox(wine: wineForm.wine, puntuacionFinal: wineForm.puntosFinal));
      },
    );
  }
}

class HiddenTasteButtons extends StatelessWidget {
  const HiddenTasteButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomElevatedButton(
          width: 120,
          label: 'Buscar', 
          customLabel: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, color: colors.outline),

              Text('Buscar', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () async {
            winesService.loadWines();
            if (context.mounted) {
              final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));
              if (wineSearched != null) {
                wineForm.setEditSearchedWine(wineSearched);
              }
            }
          },
        ),

        const SizedBox(width: 30),
                  
        CustomElevatedButton(
          width: 120,
          label: 'Añadir',
          customLabel: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add, color: colors.outline),

              Text('Añadir', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () async {
            wineForm.setCreateNewWine();

            final newRoute = MaterialPageRoute(
              builder: (context) => CreateEditWineScreen(
                saveEndAction: () {
                  Navigator.pop(context);
                }
              ),
            );
            Navigator.push(context, newRoute);
          },
        ),
      ],
    );
  }
}