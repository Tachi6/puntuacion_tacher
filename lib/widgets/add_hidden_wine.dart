
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/colors.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/search/search_delegate_form.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class AddHiddenWine extends StatelessWidget {
  
  const AddHiddenWine({super.key});

  void confirmationDialog(BuildContext context,{required int points, required Wines wine}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PointsBox(wine: wine, puntuacionFinal: points);
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: true);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);

    return PopScope(
      canPop: false,
      child: AlertDialog(
        shadowColor:const Color.fromARGB(255, 114, 47, 55),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
        title: const Text('Añade tu vino valorado'),
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
            child: const Text('Cancelar', style: TextStyle(color: Colors.black))
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
              confirmationDialog(context, points: wineForm.puntosFinal, wine: wineForm.wine);

              // Elimino registros para poder valorar de nuevo
              wineForm.clearNotas();
              wineForm.clearNotas();
              wineForm.setDefaultRatings();
              wineForm.setDefaultCreateWine();

            },
            child: const Text('Enviar', style: TextStyle(color: Colors.black))
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
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Busca en nuestro listado o añadelo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          const SizedBox(width: 250),

          TextFormField(
              controller: textEditingControllerListener(),
              readOnly: true,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor())),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: redColor(), width: 2)),  
                // labelText: 'Busca tu vino',
                labelStyle: const TextStyle(fontSize: 14),
                floatingLabelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),                     
              ),
              cursorColor: redColor(),
            ),          

          const SizedBox(
            height: 12,
          ),
          
          Row(
            children: [
              CircleAvatar(
                backgroundColor: redColor(),
                child: IconButton(
                  onPressed: () {
                    final winesService = Provider.of<WinesService>(context, listen: false);
                    winesService.loadWines;
                            
                    showSearch(context: context, delegate: WineSearchForm());                   
                  }, 
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ) 
                ),
              ),
          
              Transform.translate(
                offset: const Offset(12, 0),
                child: const Text('Buscar vino en el listado', style: TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis)))
            ],
          ),

          const SizedBox(
            height: 12,
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: redColor(),
                child: IconButton(
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
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(20)),
                            actionsPadding: const EdgeInsets.all(10),
                            insetPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                            title: const Text('Añadir vino al listado', style: TextStyle(fontSize: 16, color: Colors.black)),
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
                                child: Text('Cancelar', style: TextStyle(fontSize: 14, color: redColor())),
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
                                child: Text('Guardar', style: TextStyle(fontSize: 14, color: redColor())),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
          
              Transform.translate(
                offset: const Offset(12, 0),
                child: const Text('Añadir vino al listado', style: TextStyle(fontSize: 14, color: Colors.black, overflow: TextOverflow.ellipsis)))
            ],
          ),
        ],  
      ),
    );
  }
}

