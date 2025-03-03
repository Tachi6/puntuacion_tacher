import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/mappers/mappers.dart';
import 'package:puntuacion_tacher/models/models.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class TasteScreen extends StatefulWidget {
   
  const TasteScreen({super.key});

  @override
  State<TasteScreen> createState() => _TasteScreenState();
}

class _TasteScreenState extends State<TasteScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final Size size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final double backgroundHeight = (size.width / 1.5);
    
    double innerSizedBox() {
      // CUSTOM HEIGHT OF APPBAR
      final appBarHeight = Theme.of(context).appBarTheme.toolbarHeight;
      // CUSTOM HEIGHT OF NAVIGATIONBAR
      final navigationBarHeight = Theme.of(context).navigationBarTheme.height;
      // HEIGHT OF STATUS
      final statusBarHeight = MediaQuery.of(context).padding.top;
      // HEIGHT OF WIDGETS: SIZEDBOX + 1ST WIDGET + 2ND WIDGET + 3RD WIDGET
      final widgetsHeight = (screenHeight * 0.01) + 150 + 150 + 85 + backgroundHeight;
      // SCREEN HEIGHT
      final double screenSize = MediaQuery.of(context).size.height;
      // FILLED SPACE IN SCREEN
      final filledScreen = appBarHeight! + navigationBarHeight! + statusBarHeight + widgetsHeight;
      
      if (filledScreen > screenSize) {
        return backgroundHeight - (filledScreen - screenSize);
      }
      return backgroundHeight;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
           if (screenHeight > 600) const BottomImageBackground(image: 'assets/taste-background.jpg', opacity: 0.8),
      
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ), 
      
                Container(
                  width: double.infinity,
                  height: 150,
                  padding: EdgeInsets.only(right: screenHeight * 0.02),
                  alignment: Alignment.centerRight,
                  child: const RadioTaste(),
                ),
      
                const Spacer(),
      
                Container(
                  width: double.infinity,
                  height: 150,
                  alignment: Alignment.center,
                  child: _SecondFormWidget(),
                ),
      
                const Spacer(), 
                    
                Padding(
                  padding: EdgeInsets.only(left: screenHeight * 0.02),
                  child: _ThirdFormWidget(),
                ),
                    
                const Spacer(),
      
                Container(
                  height: innerSizedBox(),
                  padding: EdgeInsets.only(right: screenHeight * 0.02, bottom: screenHeight * 0.02),
                  child: _ContinueButton(),
                ),
              ]
            ),
          ),
        ],
      )
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _ThirdFormWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);

    Widget thirdRowWidget() {
      if (taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.vino) return const SearchTasteWine();
      if (taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.ciega) return const HiddenTaste();
      if (taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.organizar) return const MultipleTasteName();
      if(taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.acceder) return const SelectMultipleTaste();
      return const SizedBox();
    }

    return SizedBox(
      height:85,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (currentChild, previousChildren) {
          return currentChild!;
        },
        child: thirdRowWidget(),
      )
    );
  }
}

class _SecondFormWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);

    Widget secondRowWidget() {
      if (taste.showSecondWidget && taste.taste == TasteOptions.unica) return const RadioTasteNormal();
      if (taste.showSecondWidget && taste.taste == TasteOptions.multiple) return const RadioTasteMultiple();
      return const SizedBox();
    }

    return SizedBox(
      height: 150,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        layoutBuilder: (currentChild, previousChildren) {
          return currentChild!;
        },
        child: secondRowWidget(),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final authService = Provider.of<AuthServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final wineService = Provider.of<WineServices>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    Widget showContinueButton() {
      if (taste.showContinueButton) {
        return CustomElevatedButton(
          width: 150,
          label: 'Continuar',
          onPressed: () async {
            if (taste.tasteMultiple == TasteOptionsMultiple.acceder) {
              final routeList = MaterialPageRoute(
                builder: (context) => const PopScope(
                  canPop: false,
                  child: MultipleTasteScreen()
                ),
              );
              // TODO implements hidden???
              // if (multipleSearched.hidden) {
              //   multipleTaste.winesHiddenNumber = multipleSearched.wines.keys.length;
              //   multipleTaste.addHiddenWines();
              // }
              multipleTaste.initLoadedMultipleTaste(multipleService.loadMultipleTaste(multipleTaste.multipleName).copy());
              List<Wines> winesMultipleTaste = [];
              multipleTaste.multipleTaste.wines.forEach((key, value) {
                winesMultipleTaste.add(wineService.winesByIndex[int.parse(key)].copy());
              },);
              multipleTaste.addMultipleTasteWines(winesMultipleTaste);
              
              multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userUuid);
              multipleTaste.initUserTaste(multipleService.isMultipleTasted);
              // Activo vista global en el overview si esta catada
              if (multipleService.isMultipleTasted) {
                multipleTaste.overview = true;
              }
              // Navego a siguiente pantalla
              Navigator.push(context, routeList);
              taste.showContinueButton = false;
              return;
            }

            if (taste.showThirdWidget) {
              // To reset RatingBox if multiple taste is used
              screenProvider.multiplePage = 0; // TODO: poner provider mas abajo

              final newRoute = MaterialPageRoute(
                builder: (context) => const PopScope(
                  canPop: false,
                  child: _SingleTacherScreen()
                ),
              );
        
              Navigator.push(context, newRoute);
              // Para que cuadre la desaparicion del boton con el final de la animacion
              Future.delayed(const Duration(milliseconds: 300), () => taste.showContinueButton = false);
              return;
            }
          },
        );
      }
      return const SizedBox();
    }

    return Container(
      alignment: Alignment.bottomRight,
      height: 90,
      padding: const EdgeInsets.only(right: 0, bottom: 0),
      child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      layoutBuilder: (currentChild, previousChildren) {
        return currentChild!;
      },
      child: showContinueButton(),
      ),
    );
  }
}

class _SingleTacherScreen extends StatelessWidget {
  const _SingleTacherScreen();

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);

    return TacherScreen(
      appBarTitle: wineForm.wine.nombre == '' ? 'Vino catado a ciegas' : wineForm.wine.nombre,
      onPressedBackButon: () {
        wineForm.resetSettings();
        Navigator.pop(context);
      }, 
      bottomSheet: CustomBottomSheet(
        widgetButton: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          layoutBuilder: (currentChild, previousChildren) {
            return currentChild!;
          },
          child: wineForm.wine.nombre == '' 
            ? const HiddenTasteButtons(key: ValueKey<String>('hiddenTasteButtons'))
            : const SendTasteButton(key: ValueKey<String>('SendTasteButton')), 
        ),
      ),
    );
  }
}

class SendTasteButton extends StatelessWidget {
  const SendTasteButton({super.key});

  void showCustomDialog(BuildContext context, {required Widget child}) {
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

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final winesService = Provider.of<WineServices>(context);

    return CustomElevatedButton(
      width: 170,
      height: 100/3,
      label: 'Valorar',
      isSendingLabel: 'Valorando',
      onPressed: () async {
        // Verifico si se has rellenado todos los campos del formulario
        if (!wineForm.isValidRating()) {
          NotificationServices.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
          return;
        }
        // Actualizo info del wine desde server
        final Wines wineFromServer = await winesService.loadWine(wineForm.wine.id!);
        // Mando updates de los diferentes campos al wine y creo el wineTaste
        wineForm.addUpdatesToWine(wineFromServer);
        // Creo el wineTaste
        final WineTaste wineTaste = WineTasteMapper.winesToWinesTaste(
          wine: wineForm.wine,
          ratingVista: wineForm.ratingVista,
          ratingNariz: wineForm.ratingNariz,
          ratingBoca: wineForm.ratingBoca,
          ratingPuntos: wineForm.ratingPuntos,              
        );
        // Actualizo el server con wine y añado nuevo wineTaste
        await winesService.updateWine(wineForm.wine);
        await winesService.saveTastedWine(wineTaste);
        // Lanzo la confirmacion
        if (context.mounted) showCustomDialog(context, child: PointsBox(wine: wineForm.wine, puntuacionFinal: wineForm.puntosFinal));
        return;
      },
    );
  }
}

class HiddenTasteButtons extends StatelessWidget {
  const HiddenTasteButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomElevatedButton(
          width: 120,
          height: 100/3,
          label: 'Buscar', 
          customLabel: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.search, color: colors.outline),

              const Spacer(),

              Text('Buscar', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () async {
            winesService.loadWines();
            if (context.mounted) {
              final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));
              if (wineSearched != null) {
                wineForm.setEditSearchedWine(wineSearched);
              }
            }
          },
        ),

        const SizedBox(width: 30),
                  
        CustomElevatedButton(
          width: 120,
          height: 100/3,
          label: 'Añadir',
          customLabel: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add, color: colors.outline),

              const Spacer(),

              Text('Añadir', style: TextStyle(fontSize: 14, color: colors.outline), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () async {
              wineForm.setCreateNewWine();
                    
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return PopScope(
                    canPop: false,
                    child: CustomAlertDialog(
                      title: 'Añadir vino al listado',
                      saveText: 'Guardar',
                      cancelText: 'Cancelar',
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
                          // To chnage view and show enviar button
                          wineForm.notifylisteners();
                          if (context.mounted) Navigator.pop(context, 'Guardar');
                          wineForm.autovalidateMode = AutovalidateMode.disabled;
                        }
                      },
                      onPressedCancel: () {
                        wineForm.setCreateNewWine();
                        Navigator.pop(context, 'Cancelar');
                      },
                      content: CreateNewWineForm(wineForm),
                    ),
                  );
                },
              );
          },
        ),
      ],
    );
  }
}