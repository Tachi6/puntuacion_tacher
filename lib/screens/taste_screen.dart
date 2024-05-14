import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class TasteScreen extends StatelessWidget {
   
  const TasteScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    
    double innerSizedBox() {
      // CUSTOM HEIGHT OF APPBAR
      const double appBarSize = 56;
      // CUSTOM HEIGHT OF BOTTOMNAVIGATIONBAR
      const double bottomNavigationBarSize = 58;
      // HEIGHT OF STATUS 
      final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
      // HEIGHT OF WIDGETS: SIZEDBOX + 1ST WIDGET + 2ND WIDGET + 3RD WIDGET + CONTINUE BUTTON
      const widgetsHeight = 20 + 150 + 150 + 70 + 90;
      // SCREEN HEIGHT
      final double screenSize = MediaQuery.of(context).size.height;
      // FILLED SPACE IN SCREEN
      final filledScreen = appBarSize + bottomNavigationBarSize + statusBarHeight + widgetsHeight;
      // EMPTY HEIGHT OF THE SCREEN
      return screenSize - filledScreen;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Puntuación Tacher', style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child:Form(
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
      
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: const Offset(20, 0),
                    child: _SecondFormWidget()
                  )
                ]
              ),
      
              _ThirdFormWidget(),
      
              SizedBox(height: innerSizedBox()),
      
              _ContinueButton(),
        
            ]
          ),
        )
      )
    );
  }
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
          visible: taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.acceder,
          child: const ComingSoon(),
        ),
        Visibility(
          visible: taste.showThirdWidget && taste.tasteMultiple == TasteOptionsMultiple.organizar,
          child: const ComingSoon(),
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

    if (taste.showContinueButton) {
      return Container(
        height: 90,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(156),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 114, 47, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Continuar', style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center),
          onPressed: () {
            if (taste.showThirdWidget) {
              final newRoute = MaterialPageRoute(
                builder: (context) => TacherScreen()
              );

              Navigator.push(context, newRoute);
            }
            // TODO hacer warning de que no es correcto
          }
        ),
      );
    }

    return const SizedBox();
  }
}