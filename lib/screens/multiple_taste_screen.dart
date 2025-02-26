import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/mappers/mappers.dart';

import 'package:puntuacion_tacher/pages/pages.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
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
    final authService = Provider.of<AuthServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final winesService = Provider.of<WineServices>(context);
    final pageProvider = Provider.of<ScreensProvider>(context);

    void onPressedBottomSheetButton() async {
      if (multipleService.isMultipleTasted) {
        Navigator.pop(context);
        multipleTaste.resetSettings();
        pageProvider.multiplePage = 0;
        return;
      }
      if (!multipleTaste.isValidRating()) {
        NotificationServices.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
        return;
      }

      final int newPageIndex = multipleTaste.winesMultipleTaste.length + 1; // TODO: contar la pagina del quiz????
      pageProvider.multiplePage = newPageIndex;
      pageController.animateToPage(
        newPageIndex, 
        duration: const Duration(milliseconds: 250), 
        curve: Curves.easeInOut,           
      );
      // Mando aviso de cata enviada
      NotificationServices.showSnackbar('Cata múltiple enviada', context);
      // Cargo la cata multiples para tener los ultimos cambios
      final Multiple multipleUpdated = await multipleService.loadMultipleToUpdate(multipleTaste.multipleTaste.name);
      // Actualizo el multiple local
      multipleTaste.initLoadedMultipleTaste(multipleUpdated);
      // Calculo puntuaciones de Vista, Nariz y Boca
      multipleTaste.calculateValoration();
      // Calculo puntuaciones medias
      multipleTaste.calculateAverageRatings();
      // Activo 2 paginas del overview
      multipleTaste.overview = true;
      // Desactivar que vuelvan a catar y moverme a la nueva ultima pagina
      multipleService.isMultipleTasted = true;
      pageController.jumpToPage(1); // TODO: contar la pagina del quiz
      pageProvider.multiplePage = 1; // TODO: contar la pagina del quiz
      // Subo WineTaste del usuario
      await multipleService.createUserMultipleTaste(multipleName: multipleTaste.multipleTaste.name, userMultipleTaste: multipleTaste.userMultipleTaste);
      // Subo AverageRatings
      await multipleService.updateAverageRatings(multipleName: multipleTaste.multipleTaste.name, averageRatings: multipleTaste.multipleTaste.averageRatings);
      // Mapear todos los vinos y subir los cambios a firebase
      for (WineTaste wineTaste in multipleTaste.userMultipleTaste) {
        final Wines wineFromServer = await winesService.loadWine(wineTaste.id);
        await winesService.updateWine(WinesMapper.wineTasteToWines(wineTaste, wineFromServer, authService.userUuid));
        await winesService.saveTastedWine(wineTaste);
      }
    }

    List<Widget> tastePages() {
      List<Widget> tastePages = [];

      final DateTime datelimit = multipleTaste.multipleTaste.dateLimit == null
        ? CustomDatetime().toDateTime('3000-01-01T00:00:00.000')
        : CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!);

      if (datelimit.isBefore(DateTime.now().toUtc())) {
        tastePages = [];
      }
      if (multipleService.isMultipleTasted) {
        tastePages = [];
      }
      else {
        for (int i = 0; i < multipleTaste.winesMultipleTaste.length; i++) {
          final Wines wine = multipleTaste.winesMultipleTaste[i];

          final Widget tastePage = MultipleTacherPage(
            appBarTitle: multipleTaste.multipleTaste.hidden ? 'Vino a catar a ciegas ${i + 1}' : wine.nombre,
          );
        
          tastePages = [...tastePages, tastePage];
        }
      }

      return [
        const MultipleInitialPage(),

        ...tastePages,
        
        if (multipleTaste.multipleTaste.tasteQuiz != null) const QuizTastePage(),
        
        const MultipleOverviewPage(),
      ];
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider(
          wineSequence: multipleTaste.multipleTaste.wineSequence,
          defaultQuestionList: context.read<QuizServices>().selectedQuestionsList,
          defaultUser: authService.userUuid,
        )),
      ],
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: size.width,
          height: size.height,
          child: PageView(
            physics: const ClampingScrollPhysics(),
            controller: pageController,
            children: tastePages(),
            onPageChanged: (value) {
              pageProvider.multiplePage = value;
            }
          ),
        ),
        bottomSheet: CustomMultipleBottomSheet(
          pageController: pageController, 
          onPressed: onPressedBottomSheetButton,
          totalPages: tastePages().length,
        ),
      ),
    );
  }
}