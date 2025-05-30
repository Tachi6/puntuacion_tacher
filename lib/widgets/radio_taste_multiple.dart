import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

enum TasteOptionsMultiple { empty, acceder, organizar }

class RadioTasteMultiple extends StatelessWidget {
  const RadioTasteMultiple({super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<TasteOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;
    
    return SizedBox(
      width: Platform.isAndroid ? 265 : 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Accede o crea el tipo de cata a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 10),
          Transform.translate(
            offset: const Offset(-10, -3),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(right: 0),
              subtitle: Text('Crea una nueva cata múltiple', style: TextStyle(fontSize: 12, color: colors.outline)),
              title: const Text('Crear cata múltiple', style: TextStyle(fontSize: 14)),
              value: TasteOptionsMultiple.organizar, 
              groupValue: taste.tasteMultiple, 
              onChanged: (TasteOptionsMultiple? value) {
                wineForm.resetSettings();
                taste.tasteMultiple = value!;
                taste.showContinueButton = true;
              },
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, -20),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              subtitle: Text('Accede a una cata múltiple ya creada', style: TextStyle(fontSize:12, color: colors.outline)),
              title: const Text('Acceder a cata mútiple', style: TextStyle(fontSize: 14)),
              value: TasteOptionsMultiple.acceder, 
              groupValue: taste.tasteMultiple, 
              onChanged: (TasteOptionsMultiple? value) {
                wineForm.resetSettings();
                taste.tasteMultiple = value!;
                taste.showContinueButton = false;
              },
            ),
          ),
        ],
      ),
    );
  }
}
