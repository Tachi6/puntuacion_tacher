
/*
<a href="https://www.freepik.es/foto-gratis/salpicaduras-vino-tinto-sobre-fondo-blanco_13635709.htm#query=vino&position=12&from_view=search&track=sph">Imagen de master1305</a> en Freepik
*/

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
          children: [
            // TasteBackground(),
          
            _HomeScreenBody(),
          ]
      ),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
  
class _HomeScreenBody extends StatelessWidget {

  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreensProvider>(context);
    final int currentScreen = screenProvider.currentScreen;

    switch( currentScreen ) {
      case 0:
        return const ValorationsScreen();

      case 1: 
        return const TasteScreen();

      case 2: 
        return const ListScreen();

      case 3: 
        return const MyUserScreen();

      default:
      return const ValorationsScreen();
    }

  }
}