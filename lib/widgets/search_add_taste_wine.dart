import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/search/search_delegate_wines.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class SearchAddTasteWine extends StatelessWidget {

  const SearchAddTasteWine({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final taste = Provider.of<TasteOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    final textEditingController = TextEditingController(
      text: wineForm.wine.nombre
    );

    void onPressed() async {
      wineForm.resetSettings();
      winesService.loadWines();
      if (context.mounted) {
        final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));

        if (wineSearched != null) {
          wineForm.setEditSearchedWine(wineSearched);
          taste.showContinueButton = true;
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
                  CustomIconButton(
                    icon: Icons.search,
                    onPressed: onPressed,
                  ),

                  CustomIconButton(
                    icon: Icons.add,
                    onPressed: () {
                      wineForm.resetSettings();

                      final newRoute = MaterialPageRoute(
                        builder: (context) => CreateEditWineScreen(
                          saveEndAction: () {
                            final newRoute = MaterialPageRoute(
                              builder: (context) => const PopScope(
                                canPop: false,
                                child: SingleTacherScreen()
                              ),
                            );
                            Navigator.pushReplacement(context, newRoute);
                            taste.clearOptions();
                          },
                        ),
                      );
                      Navigator.push(context, newRoute);
                    }
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


