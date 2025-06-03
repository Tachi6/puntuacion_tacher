import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

enum QuizTypes {vino, vista, nariz, boca}

class MultipleQuizPage extends StatefulWidget {
  const MultipleQuizPage({super.key});

  @override
  State<MultipleQuizPage> createState() => _MultipleQuizPageState();
}

class _MultipleQuizPageState extends State<MultipleQuizPage> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleProvider = context.watch<MultipleProvider>();
    const double padding = 10;
    final double width = multipleProvider.multipleSelected.wineSequence.length < 3
      ? (MediaQuery.of(context).size.width / 2) - ((padding * 3) / 2)
      : (MediaQuery.of(context).size.width / 2) - (padding * 2.25);
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: CustomMultipleAppBar(
        onPressedBackButton: () => multipleProvider.setandMoveToPage(null),
        onPressedActionButton: () async {
          final reloadedQuestions = await context.read<QuizServices>().loadQuiz(multipleProvider.multipleSelected.id!);
          if (context.mounted) context.read<QuizProvider>().reloadQuestions(reloadedQuestions);
        },
      ),
      body: multipleProvider.multipleSelected.tasteQuiz! == 'simple' 
        ? SimpleTasteQuiz(width: width, style: style, padding: padding)
        : AdvancedTasteQuiz(width: width, style: style, padding: padding),
      resizeToAvoidBottomInset: false,
      bottomSheet: const CustomBottomSheet(
        widgetButton: ValidateButton(), 
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class SimpleTasteQuiz extends StatelessWidget {
  const SimpleTasteQuiz({
    super.key,
    required this.width,
    required this.style,
    required this.padding,
  });

  final double width;
  final TextStyle? style;
  final double padding;

  double obtainTextHeight(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: style,
      ),
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: width - (padding * 2));

    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final bool isQuizValidated = quizProvider.isValidatedQuiz();
    final bool isReorderQuizNedeed = quizProvider.isReorderQuizNedeed;
    final colors = Theme.of(context).colorScheme;

    final List<Wines> wineList = isQuizValidated && isReorderQuizNedeed
      ? multipleProvider.multipleWines
      : multipleProvider.multipleWinesShuffled1;

    double textMaxHeight([Wines? selectedWine]) {
      List<double> textHeight = [];
      for (Wines wine in wineList) {
        final double labelsHeight = multipleProvider.multipleSelected.hidden ? (20 * 9) : (3 * 20); // rows of label text of 20px height
        double allTextHeight = labelsHeight + 10; // 10px of separation of spec and notes

        final Wines checkWine = selectedWine ?? wine;

        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.nombre);
        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.bodega);
        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.region);
        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.tipo);
        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.variedades);
        if (multipleProvider.multipleSelected.hidden) allTextHeight = allTextHeight + obtainTextHeight(checkWine.graduacion);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.notaVista);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.notaNariz);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.notaBoca);

        textHeight.add(allTextHeight);

        if (selectedWine != null) break;
      }
      // top padding + 44 _CustomDropDownButton + 2 bottom padding + rows checkWine
      return textHeight.max + (padding) + 44 + 2 + (isQuizValidated ? 30 : 0);
    }

    final double containerMaxHeight = textMaxHeight();
    
    String customLabel() {
      if (isQuizValidated) {
        return 'Cata Quiz - ${context.read<QuizProvider>().obtainPuntuation()}';
      }
      return 'Cata Quiz';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10 + (quizProvider.isBottomSheetOpen ? 58 : 0)),
      child: Column(
        children: [
          Text(
            customLabel(),
            style: style!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
      
          if (isQuizValidated) const _OtherUsersQuiz(),

          const SizedBox(height: 10),
            
          Container(
            alignment: Alignment.topCenter,
            height: containerMaxHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: wineList.length,
              itemBuilder: (context, index) {
            
                final Wines wine = wineList[index];
            
                return Container(
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12)          
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 2, left: 10, right: 10),
                  margin: EdgeInsets.only(
                    left: index == 0 ? padding : (padding / 2), 
                    right: index == (wineList.length -1) ? padding : (padding / 2),
                    bottom: containerMaxHeight - textMaxHeight(wine),
                  ),
                  width: width,
                  child: SimpleQuizRow(style: style, wine: wine, index: index, wineList: wineList),
                );
              },
            ),
          ),

          const SafeArea(
            top: false,
            child: SizedBox(height: 58)
          ),
        ],
      ),
    );
  }
}

class SimpleQuizRow extends StatelessWidget {
  const SimpleQuizRow({
    super.key,
    required this.style,
    required this.wine,
    required this.index, 
    required this.wineList,
  });

  final TextStyle? style;
  final Wines wine;
  final int index;
  final List<Wines> wineList;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final bool isQuizValidated = context.watch<QuizProvider>().isValidatedQuiz();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (multipleProvider.multipleSelected.hidden) Column(
          children: [
            Text('Vino', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
            Text(wine.nombre, style: style, textAlign: TextAlign.center),
            Text('Bodega', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
            Text(wine.bodega, style: style, textAlign: TextAlign.center),
            Text('Region', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(wine.region, style: style, textAlign: TextAlign.center),
            Text('Tipo', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
            Text(wine.tipo, style: style, textAlign: TextAlign.center),
            Text('Variedades', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(wine.variedades, style: style, textAlign: TextAlign.center),
            Text('Graduacion', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text('${wine.graduacion}% vol.', style: style, textAlign: TextAlign.center),
            const SizedBox(height: 10),
          ],
        ),
    
        Text('Cata Vista', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaVista, style: style, textAlign: TextAlign.center),
        Text('Cata Nariz', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaNariz, style: style, textAlign: TextAlign.center),
        Text('Cata Boca', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaBoca, style: style, textAlign: TextAlign.center),
                   
        if (isQuizValidated) const SizedBox(height: 10),
    
        if (isQuizValidated) Text(
          'Vino correcto: ${context.read<QuizProvider>().obtainCorrectAnswer(wine.id!)}', 
          style: style!.copyWith(fontWeight: FontWeight.bold), 
          textAlign: TextAlign.center
        ),
    
        _CustomDropDownButton(
          width: 125, 
          style: style!,
          quizTypes: QuizTypes.vino,
          wineId: wine.id!,
          wineList: wineList,
        ),
      ],
    );
  }
}

class AdvancedTasteQuiz extends StatelessWidget {
  const AdvancedTasteQuiz({
    super.key,
    required this.width,
    required this.style,
    required this.padding,
  });

  final double width;
  final TextStyle? style;
  final double padding;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final quizProvider = context.watch<QuizProvider>();

    String customLabel() {
      if (quizProvider.isValidatedQuiz()) {
        return 'Cata Quiz - ${context.read<QuizProvider>().obtainPuntuation()}';
      }
      return 'Cata Quiz';
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 10 + (quizProvider.isBottomSheetOpen ? 58 : 0)),
      child: Column(
        children: [
          Text(
            customLabel(), 
            style: style!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
      
          if (quizProvider.isValidatedQuiz()) const _OtherUsersQuiz(),

          const SizedBox(height: 10),
      
          Column(
            children: [
              if (multipleProvider.multipleSelected.hidden) AdvancedQuizRowSpecs(
                padding: padding, 
                width: width, 
                style: style,
                wineList: quizProvider.isValidatedQuiz() && quizProvider.isReorderQuizNedeed
                  ? multipleProvider.multipleWines
                  : multipleProvider.multipleWinesShuffled1,
              ),
              
              if (multipleProvider.multipleSelected.hidden) const SizedBox(height: 10),
                      
              AdvancedQuizRowNotes(
                quizType: QuizTypes.vista,
                padding: padding, 
                width: width, 
                style: style,
                wineList: quizProvider.isValidatedQuiz() && quizProvider.isReorderQuizNedeed
                  ? multipleProvider.multipleWines
                  : multipleProvider.multipleWinesShuffled2,
              ),
              
              const SizedBox(height: 10),
              
              AdvancedQuizRowNotes(
                quizType: QuizTypes.nariz,
                padding: padding, 
                width: width, 
                style: style,
                wineList: quizProvider.isValidatedQuiz() && quizProvider.isReorderQuizNedeed 
                  ? multipleProvider.multipleWines
                  : multipleProvider.multipleWinesShuffled3,
              ),
              
              const SizedBox(height: 10),
              
              AdvancedQuizRowNotes(
                quizType: QuizTypes.boca, 
                padding: padding, 
                width: width, 
                style: style,
                wineList: quizProvider.isValidatedQuiz() && quizProvider.isReorderQuizNedeed 
                  ? multipleProvider.multipleWines
                  : multipleProvider.multipleWinesShuffled4,
              ),
          
              const SafeArea(
                top: false,
                child: SizedBox(height: 58)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdvancedQuizRowSpecs extends StatelessWidget {
  const AdvancedQuizRowSpecs({
    super.key,
    required this.padding,
    required this.width,
    required this.wineList,
    required this.style,
  });

  final double padding;
  final double width;
  final List<Wines> wineList;
  final TextStyle? style;

  double obtainTextHeight(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: style,
      ),
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: width - (padding * 2));

    return textPainter.size.height;
  }


  @override
  Widget build(BuildContext context) {

    final bool isQuizValidated = context.watch<QuizProvider>().isValidatedQuiz();
    final colors = Theme.of(context).colorScheme;

    double textMaxHeight([Wines? selectedWine]) {
      List<double> textHeight = [];
      for (Wines wine in wineList) {
        double allTextHeight = 120; // 120 of 6 rows of label text

        final Wines checkWine = selectedWine ?? wine;

        allTextHeight = allTextHeight + obtainTextHeight(checkWine.nombre);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.bodega);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.region);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.tipo);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.variedades);
        allTextHeight = allTextHeight + obtainTextHeight(checkWine.graduacion);

        textHeight.add(allTextHeight);

        if (selectedWine != null) break;
      }
      // top padding + 44 _CustomDropDownButton + 2 bottom padding + rows checkWine
      return textHeight.max + padding + 44 + 2 + (isQuizValidated ? 30 : 0);
    }

    final double containerMaxHeight = textMaxHeight();

    return SizedBox(
      height: containerMaxHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wineList.length,
        itemBuilder: (context, index) {
      
          final Wines wine = wineList[index];
      
          return Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
            margin: EdgeInsets.only(
              left: index == 0 ? padding : (padding / 2), 
              right: index == (wineList.length -1) ? padding : (padding / 2),
              bottom: containerMaxHeight - textMaxHeight(wine),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Vino', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
                Text(wine.nombre, style: style, textAlign: TextAlign.center),
                Text('Bodega', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
                Text(wine.bodega, style: style, textAlign: TextAlign.center),
                Text('Region', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text(wine.region, style: style, textAlign: TextAlign.center),
                Text('Tipo', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),  
                Text(wine.tipo, style: style, textAlign: TextAlign.center),
                Text('Variedades', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text(wine.variedades, style: style, textAlign: TextAlign.center),
                Text('Graduacion', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text('${wine.graduacion}% vol.', style: style, textAlign: TextAlign.center),
                  
                if (isQuizValidated) const SizedBox(height: 10),

                if (isQuizValidated) Text(
                  'Vino correcto: ${context.read<QuizProvider>().obtainCorrectAnswer(wine.id!)}',
                  style: style!.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center
                ),
            
                _CustomDropDownButton(
                  width: 125, 
                  style: style!,
                  quizTypes: QuizTypes.vino,
                  wineId: wine.id!,
                  wineList: wineList,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class AdvancedQuizRowNotes extends StatelessWidget {
  const AdvancedQuizRowNotes({
    super.key,
    required this.quizType,
    required this.wineList,
    required this.padding,
    required this.width,
    required this.style,
  });

  final QuizTypes quizType;
  final List<Wines> wineList;
  final double padding;
  final double width;
  final TextStyle? style;

  List<Map<String, String>> createWineIdNotes() {

    final List<Map<String, String>> wineIdNotes = [];
    for (Wines wine in wineList) {
      late String notas;
      switch (quizType) {
        case QuizTypes.vino:
          notas = '';
          break;
        case QuizTypes.vista:
          notas = wine.notaVista;
          break;
        case QuizTypes.nariz:
          notas = wine.notaNariz;
          break;
        case QuizTypes.boca:
          notas = wine.notaBoca;
          break;
      }

      wineIdNotes.add({
        wine.id!: notas,
      });
    }
    return wineIdNotes;
  }

  String get label {
    switch (quizType) {
      case QuizTypes.vino:
        return 'Cata';
      case QuizTypes.vista:
        return 'Cata Vista';
      case QuizTypes.nariz:
        return 'Cata Nariz';
      case QuizTypes.boca:
        return 'Cata Boca';
    }
  }

  @override
  Widget build(BuildContext context) {

    final quizProvider = context.watch<QuizProvider>();
    final bool isQuizValidated = quizProvider.isValidatedQuiz();
    final colors = Theme.of(context).colorScheme;
    final List<Map<String, String>> wineIdNotes = createWineIdNotes();

    double textMaxHeight([Map<String, String>? wineIdTextSelected]) {
      List<double> textHeight = [];
      for (Map<String, String> wineIdText in wineIdNotes) {

        final Map<String, String> checkWineIdText = wineIdTextSelected ?? wineIdText;

        final TextPainter textPainter = TextPainter(
          text: TextSpan(
            text: checkWineIdText.values.first, 
            style: style
          ),
          textDirection: TextDirection.ltr)
        ..layout(minWidth: 0, maxWidth: width - (padding * 2));

        final double labelHeight = 20;
        textHeight.add(textPainter.size.height + labelHeight);

        if (wineIdTextSelected != null) break;
      }
      // top padding + 44 _CustomDropDownButton + 2 bottom padding + rows checkWine
      return textHeight.max + (padding) + 44 + 2 + (isQuizValidated ? 30 : 0);
    }

    final double containerMaxHeight = textMaxHeight();
    
    return SizedBox(
      height: containerMaxHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wineIdNotes.length,
        itemBuilder: (context, index) {
          
          final String wineId = wineIdNotes[index].keys.first;
          final String text = wineIdNotes[index].values.first;

          return Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
            margin: EdgeInsets.only(
              left: index == 0 ? padding : (padding / 2), 
              right: index == (wineIdNotes.length -1) ? padding : (padding / 2),
              bottom: containerMaxHeight - textMaxHeight(wineIdNotes[index]),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label, style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                Text(text, style: style, textAlign: TextAlign.center),
                  
                const Spacer(),

                if (isQuizValidated) const SizedBox(height: 10),

                if (isQuizValidated) Text(
                  'Vino correcto: ${context.read<QuizProvider>().obtainCorrectAnswer(wineId)}',
                  style: style!.copyWith(fontWeight: FontWeight.bold), 
                  textAlign: TextAlign.center
                ),
          
                _CustomDropDownButton(
                  width: 125, 
                  style: style!,
                  quizTypes: quizType,
                  wineId: wineId,
                  wineList: wineList,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CustomDropDownButton extends StatefulWidget {
  const _CustomDropDownButton({
    required this.width, 
    required this.style, 
    required this.quizTypes,
    required this.wineId,
    required this.wineList,
  });

  final double width;
  final TextStyle style;
  final QuizTypes quizTypes;
  final String wineId;
  final List<Wines> wineList;

  @override
  State<_CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<_CustomDropDownButton> {

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<QuizProvider>().openBottomSheet(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {

    final multipleTaste = context.watch<MultipleProvider>();
    final quizProvider = context.watch<QuizProvider>();

    final int correctAnswer = quizProvider.obtainCorrectAnswer(widget.wineId);
    final int? userAnswer = quizProvider.obtainUserAnswer(widget.wineId, widget.quizTypes);

    Color? answerColor() {
      if (userAnswer == null) return null;
      if (userAnswer == correctAnswer) return const Color.fromARGB(255, 0, 143, 57);
      return const Color.fromARGB(255, 203, 50, 52);
    }

    void onselected(int? value) {
      switch (widget.quizTypes) {
        case QuizTypes.vino:
          quizProvider.completeAnswers(wineId: widget.wineId, answerWine: value);
          // quizProvider.openBottomSheet(context);
          break;
        case QuizTypes.vista:
          quizProvider.completeAnswers(wineId: widget.wineId, answerEyes: value);
          // quizProvider.openBottomSheet(context);
          break;
        case QuizTypes.nariz:
          quizProvider.completeAnswers(wineId: widget.wineId, answerNose: value);
          // quizProvider.openBottomSheet(context);
          break;
        case QuizTypes.boca:
          quizProvider.completeAnswers(wineId: widget.wineId, answerMouth: value);
          // quizProvider.openBottomSheet(context);               
          break;
      }
    }

    final List<Map<int, String>> wineNumberNameList = List.generate(
      widget.wineList.length, 
      (index) => {
        index + 1: widget.wineList[index].nombre
      }, 
      growable: false,
    );

    Map<int, String>? initialSelected() {
      if (quizProvider.editingQuestionList.isEmpty) return null;
      final Question question = quizProvider.editingQuestionList.firstWhere((question) => question.wineId == widget.wineId);
      int? number;
      switch (widget.quizTypes) {
        case QuizTypes.vino:
          number = question.answer?.values.first.answerWine;
        case QuizTypes.vista:
          number = question.answer?.values.first.answerEyes;
        case QuizTypes.nariz:
          number = question.answer?.values.first.answerNose;
        case QuizTypes.boca:
          number = question.answer?.values.first.answerMouth;
      }
      if (number != null && number != -1) return wineNumberNameList[number - 1];
      return null;
    }

    return Transform.translate(
      offset: Offset(multipleTaste.multipleSelected.hidden ? 0 : 14, 0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: DropdownMenu<Map<int, String>>(
          initialSelection: initialSelected(),
          hintText: quizProvider.isValidatedQuiz() 
            ? multipleTaste.multipleSelected.hidden
              ? 'Vino ${userAnswer.toString()}'
              : wineNumberNameList[userAnswer! - 1].values.first 
            : ' Escoge',
          enabled: quizProvider.isValidatedQuiz() 
            ? false 
            : true,
          alignmentOffset: const Offset(-1, 0),
          width: widget.width,
          textAlign: TextAlign.center,
          textStyle: widget.style.copyWith(
            fontWeight: FontWeight.bold,
            color: answerColor(), 
          ),
          trailingIcon: Transform.translate(
            offset: const Offset(0, -2),
            child: const Icon(Icons.arrow_drop_down)
          ),
          selectedTrailingIcon: Transform.translate(
            offset: const Offset(0, -2),
            child: const Icon(Icons.arrow_drop_up)
          ),
          menuStyle: const MenuStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
          ),
          expandedInsets: multipleTaste.multipleSelected.hidden
            ? null
            : EdgeInsets.zero,
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            constraints: BoxConstraints.tight(const Size.fromHeight(44)),
            contentPadding: multipleTaste.multipleSelected.hidden
              ? const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 8)
              : const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
            hintStyle: widget.style.copyWith(
              fontWeight: FontWeight.bold, 
              color: answerColor(),
            ),
          ),
          dropdownMenuEntries: wineNumberNameList.map((Map<int, String> item) {
            return DropdownMenuEntry(
              // label: 'Vino ${number.toString()}',
              label: multipleTaste.multipleSelected.hidden
                ? 'Vino ${item.keys.first}'
                : item.values.first,
              value: item,
              style: ButtonStyle(
                fixedSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
                padding: WidgetStatePropertyAll(multipleTaste.multipleSelected.hidden 
                  ? const EdgeInsets.only(left: 18) 
                  : const EdgeInsets.symmetric(horizontal: 5)
                ),
              ),
              // labelWidget: Text('Vino ${number.toString()}', style: widget.style)
              labelWidget: Text(
                multipleTaste.multipleSelected.hidden
                  ? 'Vino ${item.keys.first}'
                  : item.values.first,
                style: widget.style,
                textAlign: multipleTaste.multipleSelected.hidden
                  ? null 
                  : TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onSelected: (value) => onselected(value?.keys.first),
        ),
      ),
    );
  }
}

class _OtherUsersQuiz extends StatelessWidget {
  const _OtherUsersQuiz();

  @override
  Widget build(BuildContext context) {

    final QuizProvider quizProvider = context.watch<QuizProvider>();
    final chipStyle = Theme.of(context).textTheme.bodySmall;

    final List<Map<String, String>> usersPuntuation = quizProvider.otherUsersQuiz();

    return Container(
      height: 65,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: usersPuntuation.length,
        itemBuilder: (context, index) {

          final user = usersPuntuation[index].keys.first;
          final puntuation = usersPuntuation[index].values.first;

          return Container(
            margin: EdgeInsets.only(left: 10, right: index + 1 == usersPuntuation.length ? 10 : 0),
            child: FilterChip.elevated(
              showCheckmark: false,
              label: SizedBox(
                height: 32,
                child: Column(
                  children: [
                    Text(context.read<UserServices>().obtainDisplayName(user)),
                
                    Text(puntuation),
                  ],
                ),
              ),
              labelStyle: chipStyle,
              selected: user == quizProvider.selectedUser,
              onSelected: (value) {
                quizProvider.selectedUser = user;
              } 
            ),
          );
        },
      ),
    );
  }
}

class ValidateButton extends StatelessWidget {
  const ValidateButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final quizServices = context.watch<QuizServices>();
    final quizProvider = context.watch<QuizProvider>();
    final multipleProvider = context.watch<MultipleProvider>();

    return Container(
      height: 58,
      alignment: Alignment.center,
      child: CustomElevatedButton(
        width: 120,
        label: quizProvider.isValidatedQuiz() ? 'Salir' : 'Validar',
        isSendingLabel: 'Validando',
        onPressed: () async {
          if (quizProvider.isValidatedQuiz()) {
            multipleProvider.setandMoveToPage(null);
            return;
          }
          await quizServices.uploadUserQuiz(
            multipleId: multipleProvider.multipleSelected.id!,
            questionList: quizProvider.editingQuestionList,
          );
          quizProvider.reloadQuestions(quizServices.selectedQuestionsList);
          // if (context.mounted) quizProvider.closeBottomSheet(context);
        },
      ),
    );
  }
}
