import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class MultipleTasteName extends StatefulWidget {

  const MultipleTasteName({super.key});

  @override
  State<MultipleTasteName> createState() => _MultipleTasteNameState();
}

class _MultipleTasteNameState extends State<MultipleTasteName> {

  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);

    return SizedBox(
      height: 85,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Inserta el nombre de tu cata múltiple', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUnfocus,// multipleTaste.autovalidateMode,
                  key: multipleTaste.formNameKey,
                  child: TextFormField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Nombre de la cata múltiple',
                      // enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: colors.onSurface)),
                      labelStyle: const TextStyle(fontSize: 14),
                      floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.trim() == '') {
                        return 'El nombre de la cata no puede estar vacio';
                      }
                      if (value.trim().length < 4) {
                        return 'El nombre de la cata es demasiado corto';
                      }
                      const List<String> invalidCharacters = ['.', '\$', '#', '[', ']', '/', '<', '>', '&'];
                      bool isInvalidName = false; 
                      for (var character in invalidCharacters) {
                        if (value.contains(character)) isInvalidName = true;
                      }
                      if (isInvalidName) {
                        return 'Los caracteres . \$ # [ ] / < > & no son permitidos.';
                      }
                      return null;
                    },
                    onTap: () => multipleTaste.autovalidateMode = AutovalidateMode.onUserInteraction,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) => multipleTaste.multipleName = value,
                  ),
                )
              ),
          
              IconButton(
                onPressed: () async {
                  if (await multipleService.isMultipleNameUsed(multipleTaste.multipleName) && context.mounted) {
                    NotificationServices.showSnackbar('El nombre de la cata ya ha sido utilizado.', context);
                    return;
                  }
                  final routeList = MaterialPageRoute(
                    builder: (context) => const PopScope(
                      canPop: false,
                      child: CreateMultipleTasteScreen(),
                    ),
                  );
                  if (multipleTaste.isValidForm()) {
                    Navigator.push(context, routeList);
                    nameController.clear();
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