import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/models/models.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SelectMultipleTaste extends StatelessWidget {
  const SelectMultipleTaste({super.key});

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final wineService = Provider.of<WinesService>(context);

    final textEditingController = TextEditingController(
      text: multipleTaste.multipleTaste.name, 
    );

    return Container(
      height: 85,
      width: double.infinity,
      padding: const EdgeInsets.only(right: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Busca la cata múltiple a realizar en el listado', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
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
                ),
              ),

              SearchWineButton(
                onPressed: () async {
                  multipleService.loadMultiples();
                  final multipleSearched = await showSearch(context: context, delegate: SearchDelegateMultiple());
                  if (multipleSearched != null) {
                    multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste = multipleSearched);
                    if (multipleSearched.hidden) {
                      multipleTaste.winesHiddenNumber = multipleSearched.wines.keys.length;
                      multipleTaste.addHiddenWines();
                    }
                    else {
                      List<Wines> visibleWines = [];
                      multipleSearched.wines.forEach((key, value) {
                        visibleWines.add(wineService.winesByIndex[int.parse(key)]);
                      },);
                      multipleTaste.addVisibleWines(visibleWines);
                    }
                    multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);
                    multipleTaste.initUserTaste(multipleService.isMultipleTasted);
                    // wineForm.setWineToEdit(winesService.selectedWine!);
                    taste.showContinueButton = true;
                  }
                },
              ),
            ],
          ), 
        ],  
      ),
    );
  }
}


