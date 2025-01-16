import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
    final authService = Provider.of<AuthService>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final wineService = Provider.of<WinesService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    Widget showContinueButton() {
      if (taste.showContinueButton) {
        return CustomElevatedButton(
          width: 150, 
          onPressed: () {
            if (taste.tasteMultiple == TasteOptionsMultiple.acceder) {
              final routeList = CupertinoPageRoute(
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
              multipleTaste.editMultipleTaste(() => multipleTaste.multipleTaste = multipleService.loadMultipleTaste(multipleTaste.multipleName).copy());
              List<Wines> visibleWines = [];
              multipleTaste.multipleTaste.wines.forEach((key, value) {
                visibleWines.add(wineService.winesByIndex[int.parse(key)].copy());
              },);
              multipleTaste.addVisibleWines(visibleWines);
              
              multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);
              multipleTaste.initUserTaste(multipleService.isMultipleTasted);

              Navigator.push(context, routeList);
              taste.showContinueButton = false;
              return;
            }

            if (taste.showThirdWidget) {
              // To reset RatingBox if multiple taste is used
              screenProvider.multipleScreen = 0;

              final newRoute = CupertinoPageRoute(
                builder: (context) => const PopScope(
                  canPop: false,
                  child: _SingleTacherScreen()
                ),
              );
        
              Navigator.push(context, newRoute);
              taste.showContinueButton = false;
              return;
            }
          },
          child: const Text('Continuar'),
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
    final winesService = Provider.of<WinesService>(context);

    return TacherScreen(
      appBarTitle: wineForm.wine.nombre == '' ? 'Vino catado a ciegas' : wineForm.wine.nombre,
      onPressedBackButon: () {
        wineForm.resetSettings();
        winesService.selectedWine = null;
        Navigator.pop(context);
      }, 
      bottomSheet: CustomBottomSheet(
        wine: wineForm.wine,
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
    final winesService = Provider.of<WinesService>(context);

    return CustomElevatedButton(
      width: 170,
      height: 100/3,
      onPressed: () async {
        // Verifico si se has rellenado todos los campos del formulario
        if (!wineForm.isValidRating()) {
          NotificationsService.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
          return;
        } 
        // Mando updates de los diferentes campos al wine y creo el wineTaste
        wineForm.addUpdatesToWine();
        final WineTaste wineTaste = WineTasteMapper.winesToWinesTaste(
          wine: winesService.selectedWine!,
          ratingVista: wineForm.ratingVista,
          ratingNariz: wineForm.ratingNariz,
          ratingBoca: wineForm.ratingBoca,
          ratingPuntos: wineForm.ratingPuntos,              
        );
        // Lanzo la confirmacion
        showCustomDialog(context, child: PointsBox(wine: wineForm.wine, puntuacionFinal: wineForm.puntosFinal));
        // Mando wine al servidor
        if (wineForm.wine.id == '-1') {
          final String newId = await winesService.createWine(winesService.selectedWine!);
          wineTaste.id = newId;
          await winesService.saveDeleteLatestTastedWine(wineTaste);
        }
        else {
          await winesService.updateWine(winesService.selectedWine!);
          await winesService.saveDeleteLatestTastedWine(wineTaste);
        }
      },
      child: const Text('Enviar Valoración'),
    );
  }
}

class HiddenTasteButtons extends StatelessWidget {
  const HiddenTasteButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final taste = Provider.of<VisibleOptionsProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomElevatedButton(
          width: 120,
          height: 100/3, 
          child: Row(
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
              final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines());
              if (wineSearched != null) {
                winesService.selectedWine = wineSearched;
                wineForm.setWineToEdit(wineSearched);
                taste.showContinueButton = true;
              }
            }
          },
        ),

        const SizedBox(width: 30),
                  
        CustomElevatedButton(
          width: 120,
          height: 100/3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add, color: colors.outline),

              const Spacer(),

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
                    child: CustomAlertDialog(
                      title: 'Añadir vino al listado',
                      saveText: 'Guardar',
                      cancelText: 'Cancelar',
                      onPressedSave: () {
                        if (wineForm.isValidForm()) {
                
                          wineForm.wine.nombre = '${wineForm.wine.vino} ${wineForm.wine.anada.toString()}';
                          
                          winesService.selectedWine = wineForm.wine;
                          taste.showContinueButton = true;
                          Navigator.pop(context, 'Guardar');
                        }
                      },
                      onPressedCancel: () {
                        wineForm.setDefaultCreateWine();
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