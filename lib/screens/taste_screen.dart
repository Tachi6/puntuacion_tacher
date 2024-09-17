import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
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
      const widgetsHeight = 20 + 150 + 20 + 150 + 20 + 70 + 90;
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
        alignment: Alignment.bottomRight,
        height: 90,
        padding: const EdgeInsets.only(right: 25, bottom: 25),
        child: CustomElevatedButton(
          width: 150, 
          onPressed: () {
            if (taste.showThirdWidget) {
              final newRoute = MaterialPageRoute(
                builder: (context) => TacherScreen()
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