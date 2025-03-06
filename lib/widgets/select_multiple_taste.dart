import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SelectMultipleTaste extends StatefulWidget {
  const SelectMultipleTaste({super.key});

  @override
  State<SelectMultipleTaste> createState() => _SelectMultipleTasteState();
}

class _SelectMultipleTasteState extends State<SelectMultipleTaste> {

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<TasteOptionsProvider>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);

    void onPressed() async {
      multipleService.loadMultiples();
      if (context.mounted) {
        final multipleSearched = await showSearch(context: context, delegate: SearchDelegateMultiple(multipleList: multipleService.multipleTasteList));

        if (multipleSearched != null) {
          multipleTaste.multipleName = multipleSearched.name;
          textEditingController.text= multipleSearched.name;
          taste.showContinueButton = true;
        }
        else {
          multipleTaste.multipleName = '';
          textEditingController.clear();
          taste.showContinueButton = false;
        }
      }
    }

    return SizedBox(
      height: 85,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Busca la cata múltiple a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 14),
                  canRequestFocus: false,
                  decoration: InputDecoration(
                    labelText: 'Cata múltiple',
                    isDense: true,
                    labelStyle: const TextStyle(fontSize: 14),
                    floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  onTap: onPressed,
                ),
              ),

              CustomIconButton(
                onPressed: onPressed,
                icon: Icons.search, 
              ),  
            ],
          ), 
        ],  
      ),
    );
  }
}


