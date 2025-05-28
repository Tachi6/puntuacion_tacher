import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/domain/entities/entities.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class OldMultipleTasteScreen extends StatelessWidget {
  const OldMultipleTasteScreen({super.key, required this.multipleTaste});

  final MultipleNew multipleTaste;

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider(
          wineSequence: multipleTaste.wineSequence,
          defaultQuestionList: context.read<QuizServices>().selectedQuestionsList,
          defaultUser: context.read<AuthServices>().userUuid,
          quizType: multipleTaste.tasteQuiz,
          hidden: multipleTaste.hidden,
        )),
      ],
      child: const MultipleTasteScreenBody(),
    );
  }
}

class MultipleTasteScreenBody extends StatefulWidget {
  const MultipleTasteScreenBody({super.key});

  @override
  State<MultipleTasteScreenBody> createState() => _MultipleTasteScreenBodyState();
}

class _MultipleTasteScreenBodyState extends State<MultipleTasteScreenBody> {

  late PageController pageController;
  bool isChangingTastePages = false;

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


    // Future<void> onPressedBottomSheetButton({required bool isValidQuiz, required List<Question> questionList}) async {
      // if (multipleService.isMultipleTasted) {
      //   Navigator.pop(context);
      //   multipleTaste.resetSettings();
      //   pageProvider.multiplePage = 0;
      //   return;
      // }
      // if (!multipleTaste.isValidRating()) {
      //   NotificationServices.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
      //   return;
      // }
      // if (!isValidQuiz) {
      //   NotificationServices.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
      //   return;
      // }

      // // Mando aviso de cata enviada
      // NotificationServices.showSnackbar('Cata múltiple enviada', context);
      // // Cargo la cata multiples para tener los ultimos cambios
      // final Multiple multipleUpdated = await multipleService.loadMultipleToUpdate(multipleTaste.multipleTaste.name);
      // // Actualizo el multiple local
      // multipleTaste.initLoadedMultipleTaste(multipleUpdated);
      // // Calculo puntuaciones de Vista, Nariz y Boca
      // multipleTaste.calculateValoration();
      // // Calculo puntuaciones medias
      // multipleTaste.calculateAverageRatings();
      // // Activo 2 paginas del overview
      // multipleTaste.overview = true;
      // // Subir Quiz en el caso de que la haya
      // if (multipleTaste.multipleTaste.tasteQuiz != null && context.mounted) {
      //   await quizService.uploadUserQuiz(multipleName: multipleTaste.multipleTaste.name, questionList: questionList);
      //   quizProvider.reloadQuestions(quizService.selectedQuestionsList);
      // }
      // // Subo WineTaste del usuario
      // await multipleService.createUserMultipleTaste(multipleName: multipleTaste.multipleTaste.name, userMultipleTaste: multipleTaste.userMultipleTaste);
      // // Subo AverageRatings
      // await multipleService.updateAverageRatings(multipleName: multipleTaste.multipleTaste.name, averageRatings: multipleTaste.multipleTaste.averageRatings);
      // // Mapear todos los vinos y subir los cambios a firebase
      // for (WineTaste wineTaste in multipleTaste.userMultipleTaste) {
      //   final Wines wineFromServer = await winesService.loadWine(wineTaste.id);
      //   await winesService.updateWine(WinesMapper.wineTasteToWines(wineTaste, wineFromServer, authService.userUuid));
      //   await winesService.saveTastedWine(wineTaste);
      // }
      // // Desactivar que vuelvan a catar y moverme a la nueva ultima pagina
      // final int quizPage = multipleTaste.multipleTaste.tasteQuiz != null ? 1 : 0;
      // if (pageProvider.multiplePage != multipleTaste.winesMultipleTaste.length + 1 + quizPage) {
      //   pageController.animateToPage(
      //     multipleTaste.winesMultipleTaste.length + 1 + quizPage, 
      //     duration: const Duration(milliseconds: 250), 
      //     curve: Curves.easeInOut,           
      //   );
      // }
      // await Future.delayed(const Duration(milliseconds: 500));
      // isChangingTastePages = true;
      // setState(() {});
      // pageProvider.multiplePage = 1 + quizPage;
      // multipleService.isMultipleTasted = true;
      // isChangingTastePages = false;
      // setState(() {});
    // }

    // List<Widget> tastePages() {
    //   List<Widget> tastePages = [];

    //   final DateTime datelimit = multipleTaste.multipleTaste.dateLimit == null
    //     ? CustomDatetime().toDateTime('3000-01-01T00:00:00.000')
    //     : CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!);

    //   if (datelimit.isBefore(DateTime.now().toUtc())) {
    //     tastePages = [];
    //   }
    //   if (multipleService.isMultipleTasted) {
    //     tastePages = [];
    //   }
    //   else {
    //     for (int i = 0; i < multipleTaste.winesMultipleTaste.length; i++) {
    //       final Wines wine = multipleTaste.winesMultipleTaste[i];

    //       final Widget tastePage = MultipleTacherPage(
    //         appBarTitle: multipleTaste.multipleTaste.hidden ? 'Vino a catar a ciegas ${i + 1}' : wine.nombre,
    //       );
        
    //       tastePages = [...tastePages, tastePage];
    //     }
    //   }

    //   return [
    //     // const MultipleTastePage(),

    //     ...tastePages,
        
    //     if (multipleTaste.multipleTaste.tasteQuiz != null) const QuizTastePage(),
        
    //     const MultipleOverviewPage(),
    //   ];
    // }

    return const Scaffold(
      body: Placeholder(),
      
      // Container(
      //   alignment: Alignment.center,
      //   width: size.width,
      //   height: size.height,
      //   child: PageView(
      //     physics: const ClampingScrollPhysics(),
      //     controller: pageController,
      //     children: tastePages(),
      //     onPageChanged: (value) {
      //       if (!isChangingTastePages) pageProvider.multiplePage = value;
      //     }
      //   ),
      // ),
      // bottomNavigationBar: CustomMultipleBottomSheet(
      //   pageController: pageController, 
      //   onPressed: () async {
      //     onPressedBottomSheetButton(
      //       isValidQuiz: context.read<QuizProvider>().isValidQuiz(),
      //       questionList: context.read<QuizProvider>().editingQuestionList,
      //     );
      //   },
      //   totalPages: tastePages().length,
      // ),
    );
  }
}