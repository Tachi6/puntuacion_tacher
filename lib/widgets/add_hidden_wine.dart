import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/mappers/mappers.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class AddHiddenWine extends StatelessWidget {
  
  const AddHiddenWine({super.key});

  void confirmationDialog(BuildContext context,{required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);

    return PopScope(
      canPop: false,
      child: CustomAlertDialog(
        title: 'Añade el vino valorado',
        content: _SearchTasteWine(),
        onPressedCancel: () {
          Navigator.pop(context);
          winesService.selectedWine = null;
          taste.clearWidgets();
          wineForm.setDefaultCreateWine();
        },
        onPressedSave: () async {
          // Verifico que hay vino añadido
          if (winesService.selectedWine == null) return;
          // Mando updates de los diferentes campos al wine
          wineForm.addUpdatesToWine();
          // Mando wine al servidor
          final wineTaste = WineTasteMapper.winesToWinesTaste(winesService.selectedWine!);
          if (wineForm.wine.id == '-1') {
            await winesService.createWine(winesService.selectedWine!);
            await winesService.saveDeleteLatestTastedWine(wineTaste);
          }
          else {
            await winesService.updateWine(winesService.selectedWine!);
            await winesService.saveDeleteLatestTastedWine(wineTaste);
          }
          // Mando wine a la confirmacion
          if (!context.mounted) return;
          confirmationDialog(context, child: PointsBox(puntuacionFinal: wineForm.puntosFinal, wine: wineForm.wine));

          // Elimino registros para poder valorar de nuevo
          wineForm.clearNotas();
          wineForm.clearNotas();
          wineForm.setDefaultRatings();
          wineForm.setDefaultCreateWine();
        },
        cancelText: 'Cancelar', 
        saveText: 'Enviar',
      )
      
      // AlertDialog(
      //   backgroundColor: colors.surfaceContainer,
      //   insetPadding: const EdgeInsets.all(20),
      //   actionsPadding: const EdgeInsets.only(bottom: 12, right: 16),
      //   title: const Text('Añade tu vino valorado', textAlign: TextAlign.center,),
      //   content: _SearchTasteWine(),
      //   actions: [
      //     TextButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //         winesService.selectedWine = null;
      //         taste.clearWidgets();
      //         wineForm.setDefaultCreateWine();
      //         Navigator.pushNamed(context, 'home');
      //       }, 
      //       child: const Text('Cancelar')
      //     ),

      //     TextButton(
      //       onPressed: () async {
      //         // Mando updates de los diferentes campos al wine
      //         wineForm.addUpdatesToWine();
      //         // Mando wine al servidor
      //         if (wineForm.wine.id == '-1') {
      //           await winesService.createWine(winesService.selectedWine!);
      //           await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
      //         }
      //         else {
      //           await winesService.updateWine(winesService.selectedWine!);
      //           await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
      //         }
      //         // Mando wine a la confirmacion
      //         if (!context.mounted) return;
      //         confirmationDialog(context, child: PointsBox(puntuacionFinal: wineForm.puntosFinal, wine: wineForm.wine));

      //         // Elimino registros para poder valorar de nuevo
      //         wineForm.clearNotas();
      //         wineForm.clearNotas();
      //         wineForm.setDefaultRatings();
      //         wineForm.setDefaultCreateWine();
      //       },
      //       child: const Text('Enviar')
      //     ),
      //   ],
      // ),
    );
  }
}

class _SearchTasteWine extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;

    TextEditingController textEditingControllerListener() {
      final textEditingController = TextEditingController();

      if (winesService.selectedWine == null) {
        textEditingController.text = '';
      }
      else {
        textEditingController.text = winesService.selectedWine!.nombre;
      }

      return textEditingController;
    }

    return SizedBox(
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Busca en nuestro listado o añadelo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      
          TextFormField(
              controller: textEditingControllerListener(),
              readOnly: true,
              canRequestFocus: false,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.left,
            ),          
      
          const SizedBox(
            height: 12,
          ),
          
          Row(
            children: [
              // const SizedBox(width: 10),
                
              CustomElevatedButton(
                width: 120, 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.search, color: colors.outline),
                    Text('Buscar', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
                  ],
                ),
                onPressed: () async {
                  await winesService.loadWines();
                  if (context.mounted) {
                    final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(
                      customResultText: '',
                    ));
                    if (wineSearched != null) {
                      winesService.selectedWine = wineSearched;
                      wineForm.setWineToEdit(wineSearched);
                      taste.showContinueButton = true;
                    }
                  }
                },
              ),
                
              const SizedBox(width: 20),
                
              CustomElevatedButton(
                width: 120, 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.add, color: colors.outline),
                    Text('Añadir', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
                  ],
                ),
                onPressed: () {
                    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false);
                    final winesService = Provider.of<WinesService>(context, listen: false);
                    final taste = Provider.of<VisibleOptionsProvider>(context, listen: false);

                    wineForm.setDefaultCreateWine();
                    winesService.selectedWine = null;
                          
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return PopScope(
                          canPop: false,
                          child: AlertDialog(
                            actionsPadding: const EdgeInsets.all(10),
                            insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            title: const Text('Añadir vino al listado'),
                            content: ChangeNotifierProvider(
                              create: ( _ ) => ShowMoreFieldsCreateWine(),
                              child: CreateNewWineForm(wineForm)
                              ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  wineForm.setDefaultCreateWine();
                                  Navigator.pop(context, 'Cancelar');
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (wineForm.isValidForm()) {
                          
                                    wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                                    
                                    winesService.selectedWine = wineForm.wine;
                                    taste.showContinueButton = true;
                                    Navigator.pop(context, 'Guardar');
                                  }
                                },
                                child: const Text('Guardar'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                
                },
              ),
            ],
          ),
        ],  
      ),
    );
  }
}

