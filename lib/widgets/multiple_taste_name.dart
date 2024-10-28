import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleTasteName extends StatelessWidget {

  const MultipleTasteName({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);

    multipleTaste.nameController.text = multipleTaste.multipleTaste.name;

    return Container(
      height: 85,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Inserta el nombre de tu cata múltiple y continua', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: multipleTaste.formNameKey,
                  child: TextFormField(
                    controller: multipleTaste.nameController,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Nombre de la cata múltiple',
                      // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.onSurface)),
                      labelStyle: const TextStyle(fontSize: 14),
                      floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == '') {
                        return 'El nombre de la cata no puede estar vacio';
                      }
                      const List<String> invalidCharacters = ['.', '\$', '#', '[', ']', '/'];
                      bool isInvalidName = false; 
                      for (var character in invalidCharacters) {
                        if (value!.contains(character)) isInvalidName = true;
                      }
                      if (isInvalidName) {
                        return 'Los caracteres . \$ # [ ] / no son permitidos.';
                      }
                      if (multipleService.isMultipleNameUsed(multipleTaste.multipleTaste.name)) {
                        return 'El nombre de la cata ya ha sido utilizado.';
                      }
                      return null;
                    },
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) => multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste.name = value),
                  ),
                )
              ),
          
              IconButton(
                onPressed: () {
                  final routeList = CupertinoPageRoute(
                    builder: (context) => const PopScope(
                      canPop: false,
                      child: CreateMultipleTaste(),
                    ),
                  );

                  if (multipleTaste.isValidForm()) {
                    Navigator.push(context, routeList);
                  } 
                }, 
                icon: Icon(
                  Icons.check, 
                  color: colors.onSurface,
                  size: 22
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}