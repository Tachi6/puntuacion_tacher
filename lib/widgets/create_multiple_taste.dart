import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/providers/multiple_taste_provider.dart';

class CreateMultippleTaste extends StatelessWidget {

  const CreateMultippleTaste({super.key});

  void setWinesNumber(BuildContext context) {

    showDialog(
      context: context, 
      builder: (context) => const SetWinesNumber(),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SetWinesNumber extends StatelessWidget {
  const SetWinesNumber({super.key});

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return AlertDialog(
      content: Column(
        children: [
          const Text('Nombre de la cata'),

          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null) {
                return 'Nombre de la cata obligatorio';
              }
              if (value.length < 3) {
                return 'Nombre de la cata demasiado corto';
              }
              return null;
            },
          ),

          const Text('Elige el numero de vinos a Catar'),

          TextFormField(
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null) {
                return 'Número de vinos obligatorio';
              }
              if (value.runtimeType != int) {
                return 'No es un número entero';
              }
              if (int.parse(value) < 2) {
                return 'El número mínimo de vinos requerido para una cata múltiple es 2';
              }
              return null;
            },
          ),

          Checkbox( 
            value: multipleTaste.hidden, 
            onChanged: (value) {
              multipleTaste.hidden = value!;
            },
          ),

          // TODO hacer form options horizontal, de realizar cata o guardar
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            multipleTaste.multiple = true;  
          }, 
          child: const Text('Continuar')
        )
      ],
    );
  }
}