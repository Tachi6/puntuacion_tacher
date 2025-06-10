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

    final screenProvider = context.watch<ScreenProvider>();
    final colors = Theme.of(context).colorScheme;
    
    return NavigationBar(
      backgroundColor: colors.surfaceDim,
      indicatorColor: colors.surfaceContainerHigh,
      overlayColor: WidgetStatePropertyAll(colors.surfaceContainerHighest),
      labelTextStyle: WidgetStateProperty.fromMap({
        WidgetState.selected: TextStyle(color: colors.onSurface, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.5, height: 1.3),
        WidgetState.any: TextStyle(color: colors.inverseSurface, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.5, height: 1.3),
      }),
      elevation: 2,     
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.trending_up_outlined, color: colors.inverseSurface), label: 'Novedades', selectedIcon: Icon(Icons.trending_up_outlined, color: colors.onSurface)),
        NavigationDestination(
          icon: Icon(Icons.wine_bar, color: colors.inverseSurface), label: 'Catas', selectedIcon: Icon(Icons.wine_bar, color: colors.onSurface)),
        NavigationDestination(
          icon: Icon(Icons.list, color: colors.inverseSurface), label: 'Listados', selectedIcon: Icon(Icons.list, color: colors.onSurface)),
        NavigationDestination(
          icon: Icon(Icons.person, color: colors.inverseSurface), label: 'Usuario', selectedIcon: Icon(Icons.person, color: colors.onSurface)),
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
    );
  }
}