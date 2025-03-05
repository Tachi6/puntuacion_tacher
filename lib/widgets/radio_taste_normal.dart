import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

enum TasteOptionsNormal { empty, vino, ciega }

class RadioTasteNormal extends StatelessWidget {
  const RadioTasteNormal({super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<TasteOptionsProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return SizedBox(
      width: Platform.isAndroid ? 235 : 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecciona el tipo de cata a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Transform.translate(
            offset: const Offset(-10, -3),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              subtitle: Text('Catar vino del listado o añadirlo', style: TextStyle(fontSize:12, color: colors.outline)),
              title: const Text('Cata con referencia', style: TextStyle(fontSize: 14)),
              value: TasteOptionsNormal.vino, 
              groupValue: taste.tasteNormal, 
              onChanged: (TasteOptionsNormal? value) {
                wineForm.resetSettings();
                taste.tasteNormal = value!;
                taste.showContinueButton = false;
              },
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, -20),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              subtitle: Text('Catar sin referencias del vino', style: TextStyle(fontSize: 12, color: colors.outline)),
              title: const Text('Cata a ciegas individual', style: TextStyle(fontSize: 14)),
              value: TasteOptionsNormal.ciega, 
              groupValue: taste.tasteNormal, 
              onChanged: (TasteOptionsNormal? value) {
                wineForm.resetSettings();
                taste.tasteNormal = value!;
                taste.showContinueButton = true;
              },
            ),
          )
        ],
      ),
    );
  }
}
