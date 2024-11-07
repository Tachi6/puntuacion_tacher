import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/pages/pages.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/mappers/winetaste_to_wines.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleTasteScreen extends StatefulWidget {
  const MultipleTasteScreen({super.key});

  @override
  State<MultipleTasteScreen> createState() => _MultipleTasteScreenState();
}

class _MultipleTasteScreenState extends State<MultipleTasteScreen> {

  late PageController pageController;  

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final winesService = Provider.of<WinesService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    final tasteScreenOptions = Provider.of<VisibleOptionsProvider>(context);

    void onPressed() async {
      if (multipleService.isMultipleTasted) {
        multipleTaste.resetSettings();
        tasteScreenOptions.showContinueButton = false;
        Navigator.pop(context);
        return;
      }
      if (!multipleTaste.isValidRating()) {
        NotificationsService.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
        return;
      }
      // Cargo la cata multiples para tener los ultimos cambios
      final Multiple multipleUpdated = await multipleService.loadMultipleTaste(multipleTaste.multipleTaste.name);
      // Actualizo el multiple local
      multipleTaste.updateMultipleTaste(multipleUpdated);
      // Calculo puntuaciones de Vista, Nariz y Boca
      multipleTaste.calculateValoration();
      // Calculo puntuaciones medias
      multipleTaste.calculateAverageRatings();
      // Moverme a la ultima página // TODO ver que lo hace fluido...
      final int newPageIndex = multipleTaste.winesMultipleTaste.length + 1;
      if (screenProvider.multipleScreen != newPageIndex) {
        screenProvider.multipleScreen = newPageIndex;
        pageController.animateToPage(
          newPageIndex, 
          duration: const Duration(milliseconds: 250), 
          curve: Curves.easeInOut,           
        );
      }
      // Desactivar que vuelvan a catar, retraso para la animacion
      await Future.delayed(
        const Duration(milliseconds: 250),
        () => multipleService.isMultipleTasted = true,
      );
      // Subo WineTaste del usuario
      await multipleService.createUserMultipleTaste(multipleName: multipleTaste.multipleTaste.name, userMultipleTaste: multipleTaste.userMultipleTaste);
      // Subo AverageRatings
      await multipleService.updateAverageRatings(multipleName: multipleTaste.multipleTaste.name, averageRatings: multipleTaste.multipleTaste.averageRatings);
      // Mapear todos los vinos y subir los cambios a firebase
      for (var wineTaste in multipleTaste.userMultipleTaste) {
        final wineId = int.parse(wineTaste.id);
        await winesService.updateWine(WinesMapper.wineTasteToWines(wineTaste, winesService.winesByIndex[wineId]));
      }
    }

    List<Widget> tastePages() {
      List<Widget> tastePages = [];

      final DateTime datelimit = multipleTaste.multipleTaste.dateLimit == null
        ? CustomDatetime().toDateTime('2020-01-01T00:00:00.000')
        : CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!);

      if (datelimit.isAfter(DateTime.now())) {
        tastePages = [];
      } 
      else {
        for (var wine in multipleTaste.winesMultipleTaste) {
          final Widget tastePage = TacherScreen(
            appBarTitle: wine.nombre,
            onPressedBackButon: () {
              Navigator.pop(context);
              multipleTaste.resetSettings();
            },
          );
          tastePages = [...tastePages, tastePage];
        }
      }

      return [
        const MultipleInitialPage(),
        
        if (!multipleService.isMultipleTasted) ...tastePages,
        
        const MultipleOverviewPage(),
      ];
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
        child: PageView(
          physics: const ClampingScrollPhysics(),
          controller: pageController,
          children: tastePages(),
          onPageChanged: (value) => screenProvider.multipleScreen = value,
        ),
      ),
      bottomSheet: CustomMultipleBottomSheet(
        pageController: pageController, 
        onPressed: onPressed,
        totalPages: tastePages().length,
      ),
    );
  }
}