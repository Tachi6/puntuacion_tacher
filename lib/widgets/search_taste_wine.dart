
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchTasteWine extends StatelessWidget {

  const SearchTasteWine({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);

    TextEditingController textEditingControllerListener() {
      final textEditingController = TextEditingController();

      if (winesService.selectedWine == null) {
        textEditingController.text = 'Pulsa el icono correspondiente';
      }
      else {
        textEditingController.text = winesService.selectedWine!.nombre;
      }

      return textEditingController;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(16, 0),
            child: const Text('Busca el vino en nuestro listado o añadelo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),)),
          Padding(
            padding: const EdgeInsets.only(left: 0),
            child: TextFormField(
              controller: textEditingControllerListener(),
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
                // labelText: 'Busca tu vino',
                labelStyle: const TextStyle(fontSize: 14),
                floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),                     
                icon: const CreateAddWine(),
              ),
              cursorColor: redColor(),
              // onTap: () {
              //   showSearch(context: context, delegate: WineSearchForm());
              // },
            ),
          ), 
        ],  
      ),
    );
  }
}


