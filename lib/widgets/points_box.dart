import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class PointsBox extends StatelessWidget {
  
  final Wines? wine;
  final int puntuacionFinal;
  final void Function()? closeAction;
  final String? customLabel;
  
  const PointsBox({this.wine, required this.puntuacionFinal, this.closeAction, this.customLabel, super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<TasteOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final styles = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: CustomAlertDialog(
        title: 'Valoración',
        textAlign: TextAlign.center,
        content: SizedBox(
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Has catado:', style: styles.bodyLarge),
                
              const SizedBox(height: 16),
                
              Text(customLabel ?? wine!.nombre, style: styles.headlineSmall, textAlign: TextAlign.center),
              if (customLabel == null) Text(wine!.tipo, style: styles.bodyLarge, textAlign: TextAlign.center),
                
              const SizedBox(height: 16),
                
              Text('Tu puntuación:', style: styles.bodyLarge),
                
              Text('$puntuacionFinal', style: styles.displayLarge)
            ]
          ),
        ),
        cancelText: 'Cerrar',
        onPressedCancel: () async {
          // Cierro dialog
          Navigator.pop(context);
          // Limpio el taste_screen
          taste.clearOptions();
          // Limpio el wineform y elimino registros para poder valorar de nuevo
          wineForm.resetSettings();
          // Cierro y elimino ventana de Tacher del context o mando la accion predeterminada si la hay
          if (closeAction != null) {
            closeAction!();
            return;
          }
          if (context.mounted) {
            Navigator.pop(context);
          } 
        },
      )
    );
  }
}
