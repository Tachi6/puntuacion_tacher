import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';


enum TasteOptionsNormal { empty, vino, ciega }

class RadioTasteNormal extends StatelessWidget {
  const RadioTasteNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return const RadioWidgetNormal();
  }
}

class RadioWidgetNormal extends StatefulWidget {
  const RadioWidgetNormal({super.key});

  @override
  State<RadioWidgetNormal> createState() => _RadioWidgetNormalState();
}

class _RadioWidgetNormalState extends State<RadioWidgetNormal> {
  TasteOptionsNormal? _taste;  //  = TasteOptions.normal

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context, listen: false);
    final taste = Provider.of<VisibleOptionsProvider>(context);
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
              groupValue: _taste, 
              onChanged: (TasteOptionsNormal? value) {

                wineForm.setDefaultCreateWine();
                winesService.selectedWine = wineForm.wine;
                _taste = value;
                taste.tasteNormal = value!;
                taste.showContinueButton = false;

                setState(() {});
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
              groupValue: _taste, 
              onChanged: (TasteOptionsNormal? value) {
                _taste = value;
                taste.tasteNormal = value!;
                taste.showContinueButton = true;

                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}
