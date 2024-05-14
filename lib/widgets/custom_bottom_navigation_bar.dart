
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class CustomNavigationBar extends StatelessWidget {

  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {

    final screenProvider = Provider.of<ScreensProvider>(context);
    final int currentScreen = screenProvider.currentScreen;

    final taste = Provider.of<VisibleOptionsProvider>(context);

    return SizedBox(
      height: 58, // TO SET THE HEIGHT OF BOTTOMNAVIGATIONBAR
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined), label: 'Valoraciones'),
          BottomNavigationBarItem(
            icon: Icon(Icons.wine_bar), label: 'Catar'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list), label: 'Listado'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), label: 'Usuario'),
        ],
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 114, 47, 55),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentScreen,
        showUnselectedLabels: true,
        selectedItemColor: Colors.grey[50],
        unselectedItemColor: Colors.grey.shade400,
        onTap: (index) {
          taste.showSecondWidget = false;
          taste.showThirdWidget = false;
          taste.showContinueButton = false;

          screenProvider.currentScreenChange(index);
        },
      ),
    );
  }
}