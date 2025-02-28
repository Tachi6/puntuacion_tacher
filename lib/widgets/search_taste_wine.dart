import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/search/search_delegate_wines.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchTasteWine extends StatelessWidget {

  const SearchTasteWine({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    final textEditingController = TextEditingController(
      text: wineForm.wine.nombre
    );

    void onPressed() async {
      winesService.loadWines();
      if (context.mounted) {
        final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));

        if (wineSearched != null) {
          wineForm.setEditSearchedWine(wineSearched);
          taste.showContinueButton = true;
        }
        else {
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
          const Text('Busca el vino en nuestro listado o crealo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingController,
                  readOnly: true,
                  style: const TextStyle(fontSize: 14),
                  canRequestFocus: false,
                  decoration: InputDecoration(
                    labelText: 'Vino a catar',
                    isDense: true,
                    labelStyle: const TextStyle(fontSize: 14),
                    floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  onTap: onPressed,
                ),
              ),

              Row(
                children: [
                  SearchWineButton(
                    onPressed: onPressed,
                  ),

                  AddWineButton(
                    onPressedSave: () async {
                      wineForm.autovalidateMode = AutovalidateMode.always;
                      if (wineForm.wine.imagenVino != null && wineForm.wine.imagenVino != '') {
                        final urlChecked = await winesService.isValidImage(wineForm.wine.imagenVino); // TODO circle progress de espera al await
                        if (!urlChecked && context.mounted) {
                          NotificationServices.showFlushBar('URL DE IMAGEN INCORRECTA', context);
                          return;
                        }
                      }

                      if (wineForm.isValidForm()) {
                        wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                        final String wineId = await winesService.createWine(wineForm.wine);
                        wineForm.wine.id = wineId;
                        taste.showContinueButton = true;
                        if (context.mounted) Navigator.pop(context, 'Guardar');
                        wineForm.autovalidateMode = AutovalidateMode.disabled;
                      }
                    }, 
                  ),
                ],
              ),
            ],
          ), 
        ],  
      ),
    );
  }
}


