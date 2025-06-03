import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/mappers/mappers.dart';
import 'package:puntuacion_tacher/models/wines.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleTacherPage extends StatelessWidget {
  const MultipleTacherPage({
    super.key,
    required this.appBarTitle,
    required this.selectedWineTaste,
  });

  final String appBarTitle;
  final WineTaste? selectedWineTaste;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final wineForm = context.watch<CreateEditWineFormProvider>();

    return TacherScreen(
      appBarTitle: appBarTitle,
      onPressedBackButon: () {
        wineForm.resetSettings();
        multipleProvider.setandMoveToPage(null);
      },
      bottomSheet: CustomBottomSheet(
        widgetButton: SendTasteButton(
          isWineTasted: multipleProvider.isWineTasted(selectedWineTaste?.id ?? wineForm.wine.id!),
          customLabel: multipleProvider.multipleSelected.hidden ? appBarTitle : null,
        ),
      ),
      selectedWineTaste: selectedWineTaste,
    );
  }
}

class SendTasteButton extends StatelessWidget {
  const SendTasteButton({super.key, required this.isWineTasted, this.customLabel});

  final bool isWineTasted;
  final String? customLabel;

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

    final wineForm = context.watch<CreateEditWineFormProvider>();
    final winesService = context.watch<WineServices>();
    final multipleProvider = context.watch<MultipleProvider>();

    return CustomElevatedButton(
      width: 120,
      label: isWineTasted ? 'Cerrar' : 'Valorar',
      isSendingLabel: 'Valorando',
      onPressed: () async {
        // Si el vino esta catado solo quiero volver a la pantalla de origen
        if (isWineTasted) {
          wineForm.resetSettings();
          multipleProvider.setandMoveToPage(null);
          return;
        }
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
        // Actualizo Multiple y AverageRatings
        await multipleProvider.validateWineTaste(wineTaste);
        // Lanzo la confirmacion
        if (context.mounted) {

        showCustomDialog(context, child: PointsBox(
          wine: wineForm.wine,
          puntuacionFinal: wineForm.puntosFinal,
          closeAction: () {
            multipleProvider.setandMoveToPage(null);
          },
          customLabel: customLabel,
        ));
        }
      },
    );
  }
}