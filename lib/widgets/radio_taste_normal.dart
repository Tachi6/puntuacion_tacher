

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/providers/providers.dart';


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

    final taste = Provider.of<VisibleOptionsProvider>(context);

    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: 305,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecciona el tipo de cata a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Transform.translate(
            offset: const Offset(-10, -3),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              subtitle: Text('Catar vino del listado o añadirlo', style: TextStyle(fontSize:12, color: Colors.grey[600])),
              activeColor: redColor(),
              title: const Text('Cata con referencia', style: TextStyle(fontSize: 14)),
              value: TasteOptionsNormal.vino, 
              groupValue: _taste, 
              onChanged: (TasteOptionsNormal? value) {
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
              subtitle: Text('Catar sin referencias del vino', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              activeColor: redColor(),
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
