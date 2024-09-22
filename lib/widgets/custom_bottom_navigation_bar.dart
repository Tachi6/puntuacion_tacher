import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class CustomNavigationBar extends StatelessWidget {

  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreensProvider>(context);
    final int currentScreen = screenProvider.currentScreen;

    return SizedBox(
      child: NavigationBar(
        height: 58,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined), label: 'Valoraciones'),
          NavigationDestination(
            icon: Icon(Icons.wine_bar), label: 'Catar'),
          NavigationDestination(
            icon: Icon(Icons.list), label: 'Listado'),
          NavigationDestination(
            icon: Icon(Icons.person), label: 'Usuario'),
        ],

        selectedIndex: currentScreen,
        onDestinationSelected: (index) {
          screenProvider.currentScreen = index;
        },
      ),
    );
  }
}