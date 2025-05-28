import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/pages/multiple_taste_page.dart';
import 'package:puntuacion_tacher/presentation/providers/multiple_list_provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/create_multiple_widget.dart';
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
           if (screenHeight > 600) const BottomImageBackground(image: 'assets/taste-background.jpg', opacity: 0.8, bottomFlex: 0),
      
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

    final taste = Provider.of<TasteOptionsProvider>(context);

    Widget thirdRowWidget() {
      if (taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.vino) return const SearchAddTasteWine();
      if (taste.showThirdWidget && taste.tasteNormal == TasteOptionsNormal.ciega) return const HiddenTaste();
      if (taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.organizar) return const CreateMultipleWidget();
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

    final taste = Provider.of<TasteOptionsProvider>(context);

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

    final taste = Provider.of<TasteOptionsProvider>(context);
    final authService = Provider.of<AuthServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final wineService = Provider.of<WineServices>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    Widget showContinueButton() {
      if (taste.showContinueButton) {
        return CustomElevatedButton(
          width: 150,
          label: 'Continuar',
          onPressed: () async {
            if (taste.tasteMultiple == TasteOptionsMultiple.acceder) {
              final routeList = MaterialPageRoute(
                builder: (context) => MultipleTasteScreen(multipleTaste: context.read<MultipleListProvider>().selectedMultiple!),
              );

              // multipleTaste.initLoadedMultipleTaste(multipleService.loadMultipleTaste(multipleTaste.multipleName).copy());
              // List<Wines> winesMultipleTaste = [];
              // multipleTaste.multipleTaste.wines.forEach((key, value) {
              //   winesMultipleTaste.add(wineService.winesByIndex[int.parse(key)].copy());
              // },);
              // multipleTaste.addMultipleTasteWines(winesMultipleTaste);
              
              // multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userUuid);
              // multipleTaste.initUserTaste(multipleService.isMultipleTasted);
              // // Activo vista global en el overview si esta catada
              // if (multipleService.isMultipleTasted) {
              //   multipleTaste.overview = true;
              // }
              // Navego a siguiente pantalla
              Navigator.push(context, routeList);
              // Limpio pagina del tastescreen
              taste.clearOptions();
            }

            if (taste.tasteMultiple == TasteOptionsMultiple.organizar) {
              final routeList = MaterialPageRoute(
                builder: (context) => const PopScope(
                  canPop: false,
                  child: CreateMultipleTasteScreen()
                ),
              );
              // Navego a siguiente pantalla
              Navigator.push(context, routeList);
              // Limpio pagina del tastescreen
              taste.clearOptions();
            }

            if (taste.showThirdWidget) {
              // To reset RatingBox if multiple taste is used
              screenProvider.multiplePage = 0; // TODO: poner provider mas abajo

              final newRoute = MaterialPageRoute(
                builder: (context) => PopScope(
                  canPop: false,
                  child: SingleTacherScreen(
                    appBarTitle: wineForm.wine.nombre == '' ? 'Vino a catar a ciegas' : wineForm.wine.nombre,
                  )
                ),
              );
              // Navego a siguiente pantalla
              Navigator.push(context, newRoute);
              // Limpio pagina del tastescreen
              taste.clearOptions();
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