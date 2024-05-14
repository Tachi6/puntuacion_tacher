

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/providers/providers.dart';


enum TasteOptionsMultiple { empty, acceder, organizar }

class RadioTasteMultiple extends StatelessWidget {
  const RadioTasteMultiple({super.key});

  @override
  Widget build(BuildContext context) {
    return const RadioWidgetMultiple();
  }
}



class RadioWidgetMultiple extends StatefulWidget {
  const RadioWidgetMultiple({super.key});

  @override
  State<RadioWidgetMultiple> createState() => _RadioWidgetMultipleState();
}

class _RadioWidgetMultipleState extends State<RadioWidgetMultiple> {
  TasteOptionsMultiple? _taste;  //  = TasteOptions.normal

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    
    return Container(
      padding: const EdgeInsets.only(left: 20),
      width: 305,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Accede o crea el tipo de cata a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 10),
          Transform.translate(
            offset: const Offset(-10, -3),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.all(0),
              subtitle: Text('Accede a una cata múltiple ya creada', style: TextStyle(fontSize:12, color: Colors.grey[600])),
              activeColor: redColor(),
              title: const Text('Acceder a cata mútiple', style: TextStyle(fontSize: 14)),
              value: TasteOptionsMultiple.acceder, 
              groupValue: _taste, 
              onChanged: (TasteOptionsMultiple? value) {
                _taste = value;
                taste.tasteMultiple = value!;
                setState(() {});
              },
            ),
          ),
          Transform.translate(
            offset: const Offset(-10, -20),
            child: RadioListTile(
              dense: true,
              contentPadding: const EdgeInsets.only(right: 0),
              subtitle: Text('Organiza o crea una cata múltiple', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              activeColor: redColor(),
              title: const Text('Organizar cata múltiple', style: TextStyle(fontSize: 14)),
              value: TasteOptionsMultiple.organizar, 
              groupValue: _taste, 
              onChanged: (TasteOptionsMultiple? value) {
                _taste = value;
                taste.tasteMultiple = value!;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
