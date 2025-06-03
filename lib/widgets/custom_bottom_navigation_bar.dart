import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({
    super.key, 
    required this.pageController, 
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);
    final colors = Theme.of(context).colorScheme;
    
    return SizedBox(
      child: NavigationBar(
        backgroundColor: colors.primaryContainer,
        indicatorColor: colors.inversePrimary,
        overlayColor: WidgetStatePropertyAll(colors.inversePrimary.withAlpha(128)),
        elevation: 2,     
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined), label: 'Novedades'),
          NavigationDestination(
            icon: Icon(Icons.wine_bar), label: 'Catas'),
          NavigationDestination(
            icon: Icon(Icons.list), label: 'Listados'),
          NavigationDestination(
            icon: Icon(Icons.person), label: 'Usuario'),
        ],

        selectedIndex: screenProvider.currentScreen,
        onDestinationSelected: (index) {
          final int pageSteps = (screenProvider.currentScreen - index).abs();
          screenProvider.currentScreen = index;
          pageController.animateToPage(
            index, 
            duration: Duration(milliseconds: pageSteps * 250), 
            curve: Easing.standard,
          );
        },
      ),
    );
  }
}