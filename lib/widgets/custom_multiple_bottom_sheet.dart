import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class CustomMultipleBottomSheet extends StatelessWidget {
  const CustomMultipleBottomSheet({
    super.key,
    required this.pageController,
    required this.onPressed, 
    required this.totalPages,
  });

  final PageController pageController;
  final void Function()? onPressed;
  final int totalPages;

  @override
  Widget build(BuildContext context) {


    final multipleService = Provider.of<MultipleService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);

    return CustomBottomSheet(
      widgetButton: CustomElevatedButton(
        width: 160,
        height: 100/3,
        onPressed: onPressed,
        child: Text(
          multipleService.isMultipleTasted
            ? 'Salir'
            : 'Enviar Valoración',
        ),
      ),

      leading: screenProvider.multipleScreen == 0 
        ? null
        : TextButton(
          onPressed: () {
            final int newPageIndex = screenProvider.multipleScreen - 1;
            screenProvider.multipleScreen = newPageIndex;
            pageController.animateToPage(
              newPageIndex, 
              duration: const Duration(milliseconds: 250), 
              curve: Curves.easeInOut,  
            );         
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 0,
                child: Icon(Icons.arrow_back_ios_new_rounded)
              ),
                        
              Positioned(
                bottom: 0,
                child: Text(
                  screenProvider.multipleScreen == 1 ? 'Inicio' : 'Cata', 
                  style: const TextStyle(fontSize: 12)
                ),
              ),
            ],
          ),
        ),

      trailing: screenProvider.multipleScreen == (totalPages - 1) 
        ? null
        : TextButton(
          onPressed: () {
            final int newPageIndex = screenProvider.multipleScreen + 1;
            screenProvider.multipleScreen = newPageIndex;
            pageController.animateToPage(
              newPageIndex, 
              duration: const Duration(milliseconds: 250), 
              curve: Curves.easeInOut,           
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Positioned(
                top: 0,
                child: Icon(Icons.arrow_forward_ios_rounded)
              ),
                        
              Positioned(
                bottom: 0,
                child: Text(
                  screenProvider.multipleScreen == (totalPages - 2) ? 'Final' : 'Cata', 
                  style: const TextStyle(fontSize: 12)
                ),
              ),
            ],
          ),
        ),
    );
  }
}