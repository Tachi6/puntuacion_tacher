import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class PointsBox extends StatelessWidget {
  
  final Wines? wine;
  final int puntuacionFinal;
  
  const PointsBox({this.wine, required this.puntuacionFinal, super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<TasteOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final screenProvider = Provider.of<ScreensProvider>(context);
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
                
              Text(wine!.nombre, style: styles.headlineSmall, textAlign: TextAlign.center),
              Text(wine!.tipo, style: styles.bodyLarge, textAlign: TextAlign.center),
                
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
          // Vuelvo a pantalla de inicio
          screenProvider.currentScreen = 0;
          // Cierro y elimino ventana de Tacher del context
          if (context.mounted) Navigator.pop(context);
          // Elimino registros para poder valorar de nuevo
          wineForm.resetSettings();
        },
      )
    );
  }
}
