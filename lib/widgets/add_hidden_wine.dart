import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search_delegate_form.dart';
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

    final authService = Provider.of<AuthService>(context, listen: true);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: colors.surfaceContainer,
        insetPadding: const EdgeInsets.all(20),
        actionsPadding: const EdgeInsets.only(bottom: 12, right: 16),
        title: const Text('Añade tu vino valorado', textAlign: TextAlign.center,),
        content: _SearchTasteWine(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              winesService.selectedWine = null;
              taste.clearWidgets();
              wineForm.setDefaultCreateWine();
              Navigator.pushNamed(context, 'home');
            }, 
            child: const Text('Cancelar')
          ),

          TextButton(
            onPressed: () async {
              // Mando updates de los diferentes campos al wine
              wineForm.addUpdatesToWine();
              // Mando wine al servidor
              if (wineForm.wine.id == '-1') {
                await winesService.createWine(winesService.selectedWine!);
                await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
              }
              else {
                await winesService.updateWine(winesService.selectedWine!);
                await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
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
            child: const Text('Enviar')
          ),
        ],
      ),
    );
  }
}

class _SearchTasteWine extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final colors = Theme.of(context).colorScheme;

    TextEditingController textEditingControllerListener() {
      final textEditingController = TextEditingController();

      if (winesService.selectedWine == null) {
        textEditingController.text = 'Vino catado a ciegas a añadir';
      }
      else {
        textEditingController.text = winesService.selectedWine!.nombre;
      }

      return textEditingController;
    }

    return SizedBox(
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Busca en nuestro listado o añadelo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      
          // const SizedBox(width: 260),
          // TODO theme this
          TextFormField(
              controller: textEditingControllerListener(),
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              // decoration: InputDecoration(
              //   enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
              //   focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
              //   // labelText: 'Busca tu vino',
              //   labelStyle: const TextStyle(fontSize: 14),
              //   floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),                     
              // ),
              // cursorColor: redColor(),
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
                onPressed: () {
                  final winesService = Provider.of<WinesService>(context, listen: false);
                  winesService.loadWines;
                            
                  showSearch(context: context, delegate: WineSearchForm());
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
                    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false); // TODO listen tru dentro de funcion
                    final winesService = Provider.of<WinesService>(context, listen: false);
                    final taste = Provider.of<VisibleOptionsProvider>(context, listen: false);
                          
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return PopScope(
                          canPop: false,
                          child: AlertDialog( // TODO pasar a Dialog
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
                
              // const SizedBox(width: 10),
                
              // CircleAvatar(
              //   backgroundColor: redColor(),
              //   child: IconButton(
              //     onPressed: () {
              //       final winesService = Provider.of<WinesService>(context, listen: false);
              //       winesService.loadWines;
                            
              //       showSearch(context: context, delegate: WineSearchForm());                   
              //     }, 
              //     icon: const Icon(
              //       Icons.search,
              //       color: Colors.white,
              //     ) 
              //   ),
              // ),
          
              // Transform.translate(
              //   offset: const Offset(12, 0),
              //   child: const Text('Buscar', style: TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis)))
            ],
          ),
      
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: [
          //     CircleAvatar(
          //       backgroundColor: redColor(),
          //       child: IconButton(
          //         onPressed: () {
                    
          //           final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: false); // TODO listen tru dentro de funcion
          //           final winesService = Provider.of<WinesService>(context, listen: false);
          //           final taste = Provider.of<VisibleOptionsProvider>(context, listen: false);
                          
          //           showDialog(
          //             barrierDismissible: false,
          //             context: context,
          //             builder: (BuildContext context) {
          //               return PopScope(
          //                 canPop: false,
          //                 child: AlertDialog( // TODO pasar a Dialog
          //                   actionsPadding: const EdgeInsets.all(10),
          //                   insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          //                   title: const Text('Añadir vino al listado'),
          //                   content: ChangeNotifierProvider(
          //                     create: ( _ ) => ShowMoreFieldsCreateWine(),
          //                     child: CreateNewWineForm(wineForm)
          //                     ),
          //                   actions: <Widget>[
          //                     TextButton(
          //                       onPressed: () {
          //                         wineForm.setDefaultCreateWine();
          //                         Navigator.pop(context, 'Cancelar');
          //                       },
          //                       child: const Text('Cancelar'),
          //                     ),
          //                     TextButton(
          //                       onPressed: () {
          //                         if (wineForm.isValidForm()) {
                          
          //                           wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                                    
          //                           winesService.selectedWine = wineForm.wine;
          //                           taste.showContinueButton = true;
          //                           Navigator.pop(context, 'Guardar');
          //                         }
          //                       },
          //                       child: const Text('Guardar'),
          //                     ),
          //                   ],
          //                 ),
          //               );
          //             },
          //           );
          //         },
          //         icon: const Icon(
          //           Icons.add,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          
          //     Transform.translate(
          //       offset: const Offset(12, 0),
          //       child: const Text('Añadir', style: TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis)))
          //   ],
          // ),
        ],  
      ),
    );
  }
}

