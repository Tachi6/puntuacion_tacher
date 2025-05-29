import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/pages/pages.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class MultipleScreen extends StatelessWidget {
  const MultipleScreen({super.key, required this.multipleTaste});

  final Multiple multipleTaste;

  @override
  Widget build(BuildContext context) {

    final String userUuid = context.watch<AuthServices>().userUuid;
    final List<Wines> winesByIndex = context.watch<WineServices>().winesByIndex;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => QuizProvider(
            wineSequence: multipleTaste.wineSequence,
            defaultQuestionList: context.read<QuizServices>().selectedQuestionsList,
            defaultUser: userUuid,
            quizType: multipleTaste.tasteQuiz,
            hidden: multipleTaste.hidden,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MultipleProvider(multipleTaste, winesByIndex, userUuid)
        ),
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

class _MultipleTasteScreenBodyState extends State<MultipleTasteScreenBody> with AutomaticKeepAliveClientMixin {
  
  late final PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleTaste = context.watch<MultipleProvider>();

    context.read<MultipleProvider>().pageController = pageController;

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const MultipleMainPage(),

        multipleTaste.pageDestination,
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}