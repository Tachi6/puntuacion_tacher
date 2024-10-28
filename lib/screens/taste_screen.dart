import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
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
    
    double innerSizedBox() {
      // CUSTOM HEIGHT OF APPBAR
      const double appBarSize = 0;
      // CUSTOM HEIGHT OF BOTTOMNAVIGATIONBAR
      const double bottomNavigationBarSize = 58;
      // HEIGHT OF STATUS 
      final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
      // HEIGHT OF WIDGETS: SIZEDBOX + 1ST WIDGET + 2ND WIDGET + 3RD WIDGET + CONTINUE BUTTON
      const widgetsHeight = 20 + 150 + 20 + 150 + 20 + 85 + 90;
      // SCREEN HEIGHT
      final double screenSize = MediaQuery.of(context).size.height;
      // FILLED SPACE IN SCREEN
      final filledScreen = appBarSize + bottomNavigationBarSize + statusBarHeight + widgetsHeight;
      // EMPTY HEIGHT OF THE SCREEN
      return screenSize - filledScreen; // 25 is the same padding of right of continue button
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BottomImageBackground(image: 'assets/taste-background.jpg', opacity: 0.8),

          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                    
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width - 240 - 10,
                    ),
                    const RadioTaste()
                  ]
                ),
          
                const SizedBox(
                  height: 20,
                ),
                    
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: const Offset(20, 0),
                      child: _SecondFormWidget()
                    )
                  ]
                ),
          
                const SizedBox(
                  height: 20,
                ),
                    
                _ThirdFormWidget(),
                    
                SizedBox(height: innerSizedBox()),
                    
                _ContinueButton(),
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

    return Stack(
      children: [
        Container(
          height:70,
        ),

        Visibility(
          visible: taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.vino,
          child: const SearchTasteWine(),
        ),
        Visibility(
          visible: taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.ciega,
          child: const HiddenTaste(),
        ),
        Visibility(
          visible: taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.organizar,
          child: const MultipleTasteName(),
        ),
        Visibility(
          visible: taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.acceder,
          child: const SelectMultipleTaste(),
        ),

      ],
    );
  }
}

class _SecondFormWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);

    return Stack(
      children: [
        Container(
          height: 150,
        ),
        Visibility(
          visible: taste.showSecondWidget && taste.taste == TasteOptions.unica,
          child: const RadioTasteNormal(),
        ),
        Visibility(
          visible: taste.showSecondWidget && taste.taste == TasteOptions.multiple,
          child: const RadioTasteMultiple(),
        ),
      ]
    );
  }
}

class _ContinueButton extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    if (taste.showContinueButton) {
      return Container(
        alignment: Alignment.bottomRight,
        height: 90,
        padding: const EdgeInsets.only(right: 25, bottom: 25),
        child: CustomElevatedButton(
          width: 150, 
          onPressed: () {
            if (taste.tasteMultiple == TasteOptionsMultiple.acceder) {
              final routeList = CupertinoPageRoute(
                builder: (context) => const PopScope(
                  canPop: false,
                  child: MultipleTasteScreen()
                ),
              );
              Navigator.push(context, routeList);
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
            }
          },
          child: const Text('Continuar'),
        ),
      );
    }

    return const SizedBox();    
  }
}

class _SingleTacherScreen extends StatelessWidget {
  const _SingleTacherScreen();

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
    final authService = Provider.of<AuthService>(context, listen: true);

    return TacherScreen(
      appBarTitle: wineForm.wine.nombre == '' ? 'Vino catado a ciegas' : wineForm.wine.nombre,
      onPressedBackButon: () {
        wineForm.clearNotas();
        wineForm.clearNotas();
        wineForm.setDefaultRatings();
        wineForm.setDefaultCreateWine();
        Navigator.pop(context);
      }, 
      bottomSheet: CustomBottomSheet(
        wine: wineForm.wine,
        buttonText: 'Enviar valoración',
        onPressed: () async {
          // Verifico si se has rellenado todos los campos del formulario
          if (!wineForm.isValidRating()) {
            NotificationsService.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
            return;
          } 
          // Verifico si es cata oculta y fuerzo a añadir el vino
          if (wineForm.wine.nombre == '') {
            if (!context.mounted) return;
            showCustomDialog(context, child: const AddHiddenWine());     
          }
          else {
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
            showCustomDialog(context, child: PointsBox(wine: wineForm.wine, puntuacionFinal: wineForm.puntosFinal));
      
            // Elimino registros para poder valorar de nuevo
            wineForm.clearNotas();
            wineForm.clearNotas();
            wineForm.setDefaultRatings();
            wineForm.setDefaultCreateWine();
          }
        },
      ) ,
    );
  }
}