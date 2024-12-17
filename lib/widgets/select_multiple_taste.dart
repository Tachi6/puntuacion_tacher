import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SelectMultipleTaste extends StatelessWidget {
  const SelectMultipleTaste({super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);

    final nameSearchedController = TextEditingController(
      text: multipleTaste.multipleName, 
    );

    void onPressed() async {
      multipleService.loadMultiples();
      // Multiple? multipleSearched;
      if (context.mounted) {
        final multipleSearched = await showSearch(context: context, delegate: SearchDelegateMultiple());

        if (multipleSearched != null) {
          multipleTaste.multipleName = multipleSearched.name;
          nameSearchedController.clear();
          taste.showContinueButton = true;
        }
        else {
          multipleTaste.multipleName = '';
          nameSearchedController.clear();
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
                  controller: nameSearchedController,
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
    
              SearchWineButton(
                onPressed: onPressed,
              ),
            ],
          ), 
        ],  
      ),
    );
  }
}


