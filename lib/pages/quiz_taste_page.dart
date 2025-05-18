import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

enum QuizTypes {vino, vista, nariz, boca}

class QuizTastePage extends StatefulWidget {
  const QuizTastePage({super.key});

  @override
  State<QuizTastePage> createState() => _QuizTastePageState();
}

class _QuizTastePageState extends State<QuizTastePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    const double padding = 10;
    final double width = multipleTaste.winesMultipleTaste.length < 3
      ? (MediaQuery.of(context).size.width / 2) - ((padding * 3) / 2)
      : (MediaQuery.of(context).size.width / 2) - (padding * 2.25);
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: CustomMultipleAppBar(
        actionButton2: multipleService.isMultipleTasted 
          ? IconButton(
            onPressed: () async {
              final reloadedQuestions = await context.read<QuizServices>().loadQuiz(multipleTaste.multipleTaste.name);
              if (context.mounted) context.read<QuizProvider>().reloadQuestions(reloadedQuestions);
            },
            icon: const Icon(Icons.refresh_rounded)
          )
          : null,
      ),
      body: multipleTaste.multipleTaste.tasteQuiz! == 'simple' 
        ? SimpleTasteQuiz(width: width, style: style, padding: padding)
        : AdvancedTasteQuiz(width: width, style: style, padding: padding),
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
    ..layout(minWidth: 0, maxWidth: width - (padding * 2) - 2); // 2 Border

    return textPainter.size.height;
  }

  double textMaxHeight(List<Wines> wineList, MultipleTasteProvider multipleTaste) {
    List<double> textHeight = [];
    for (Wines wine in wineList) {
      final double labelsHeight = multipleTaste.multipleTaste.hidden ? (20 * 9) : (3 * 20); // rows of label text of 20px height
      double allTextHeight = labelsHeight + 10; // 10px of separation of spec and notes

      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.nombre);
      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.bodega);
      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.region);
      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.tipo);
      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.variedades);
      if (multipleTaste.multipleTaste.hidden) allTextHeight = allTextHeight + obtainTextHeight(wine.graduacion);
      allTextHeight = allTextHeight + obtainTextHeight(wine.notaVista);
      allTextHeight = allTextHeight + obtainTextHeight(wine.notaNariz);
      allTextHeight = allTextHeight + obtainTextHeight(wine.notaBoca);

      textHeight.add(allTextHeight); 
    }
    return textHeight.max;
  }

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);

    List<Wines> wineList = [];

    !multipleService.isMultipleTasted
      ? wineList = [...multipleTaste.wineListShuffled()]
      : wineList = [...multipleTaste.winesMultipleTaste];
    
    String customLabel() {
      if (multipleService.isMultipleTasted) {
        return 'Cata Quiz - ${context.read<QuizProvider>().obtainPuntuation()}';
      }
      return 'Cata Quiz';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  customLabel(),
                  style: style!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                if (multipleService.isMultipleTasted) const _OtherUsersQuiz(),
              ],
            ),
          ),
             
          Container(
            // height: 1760, //TODO: hacer height mas dinamico
            height: textMaxHeight(wineList, multipleTaste) + padding + 44 + 2 + 110 + (multipleService.isMultipleTasted ? (30 + 55) : 0), // top padding + 44 _CustomDropDownButton + 2 Border + 108 of container padding + rows checkWine
            padding: EdgeInsets.only(top: 40 + (multipleService.isMultipleTasted ? 55 : 0)),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: wineList.length,
              itemBuilder: (context, index) {
            
                final Wines wine = wineList[index];
            
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(12)          
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  margin: EdgeInsets.only(
                    left: index == 0 ? padding : (padding / 2), 
                    right: index == (wineList.length -1) ? padding : (padding / 2)
                  ),
                  width: width,
                  child: SimpleQuizRow(style: style, wine: wine, index: index, wineList: wineList),
                );
              },
            ),
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

    final multipleService = Provider.of<MultipleServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (multipleTaste.multipleTaste.hidden) Column(
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
            // Text('', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),

        Text('Cata Vista', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaVista, style: style, textAlign: TextAlign.center),
        Text('Cata Nariz', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaNariz, style: style, textAlign: TextAlign.center),
        Text('Cata Boca', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaBoca, style: style, textAlign: TextAlign.center),
                
        const Spacer(),

        if (multipleService.isMultipleTasted) const SizedBox(height: 10),

        if (multipleService.isMultipleTasted) Text(
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

    final multipleService = context.read<MultipleServices>(); 
    final multipleTaste = context.read<MultipleTasteProvider>();

    List<Wines> wineList(MultipleServices multipleService, MultipleTasteProvider multipleTaste) {
      List<Wines> wineList = [];

      !multipleService.isMultipleTasted
        ? wineList = [...multipleTaste.wineListShuffled()]
        : wineList = [...multipleTaste.winesMultipleTaste];

      return wineList;
    }


    String customLabel() {
      if (multipleService.isMultipleTasted) {
        return 'Cata Quiz - ${context.read<QuizProvider>().obtainPuntuation()}';
      }
      return 'Cata Quiz';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  customLabel(), 
                  style: style!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                if (multipleService.isMultipleTasted) const _OtherUsersQuiz(),
              ],
            ),
          ),
      
          Padding(
            padding: EdgeInsets.only(top: 40 + (multipleService.isMultipleTasted ? 55 : 0)),
            child: Column(
              children: [
                if (multipleTaste.multipleTaste.hidden) AdvancedQuizRowSpecs(
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                if (multipleTaste.multipleTaste.hidden) const SizedBox(height: 10),

                AdvancedQuizRowNotes(
                  quizType: QuizTypes.vista,
                  padding: padding, 
                  width: width, 
                  style: style,
                  wineList: wineList(multipleService, multipleTaste),
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  quizType: QuizTypes.nariz,
                  padding: padding, 
                  width: width, 
                  style: style,
                  wineList: wineList(multipleService, multipleTaste),
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  quizType: QuizTypes.boca, 
                  padding: padding, 
                  width: width, 
                  style: style,
                  wineList: wineList(multipleService, multipleTaste),
                ),
              ],
            ),
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
    required this.style,
  });

  final double padding;
  final double width;
  final TextStyle? style;

  double obtainTextHeight(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: style,
      ),
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: width - (padding * 2) - 2); // 2 Border

    return textPainter.size.height;
  }

  double textMaxHeight(List<Wines> wineList) {
    List<double> textHeight = [];
    for (Wines wine in wineList) {
      double allTextHeight = 120; // 120 of 6 rows of label text

      allTextHeight = allTextHeight + obtainTextHeight(wine.nombre);
      allTextHeight = allTextHeight + obtainTextHeight(wine.bodega);
      allTextHeight = allTextHeight + obtainTextHeight(wine.region);
      allTextHeight = allTextHeight + obtainTextHeight(wine.tipo);
      allTextHeight = allTextHeight + obtainTextHeight(wine.variedades);
      allTextHeight = allTextHeight + obtainTextHeight(wine.graduacion);

      textHeight.add(allTextHeight);
    }
    return textHeight.max;
  }

  @override
  Widget build(BuildContext context) {

    final multipleService = context.read<MultipleServices>(); 
    final multipleTaste = context.read<MultipleTasteProvider>();
    List<Wines> wineList = [];

    !multipleService.isMultipleTasted
      ? wineList = [...multipleTaste.wineListShuffled()]
      : wineList = [...multipleTaste.winesMultipleTaste];

    return SizedBox(
      // TODO: simpllificar height dinamicxamente
      height: textMaxHeight(wineList) + padding + 44 + 2 + (multipleService.isMultipleTasted ? 30 : 0), // top padding + 44 _CustomDropDownButton + 2 Border
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wineList.length,
        itemBuilder: (context, index) {
      
          final Wines wine = wineList[index];
      
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(
              left: index == 0 ? padding : (padding / 2), 
              right: index == (wineList.length -1) ? padding : (padding / 2)
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
                  
                const Spacer(),

                if (multipleService.isMultipleTasted) const SizedBox(height: 10),

                if (multipleService.isMultipleTasted) Text(
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

  List<Map<String, String>> wineIdNotas() {

    final List<Map<String, String>> wineIdNotas = [];
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

      wineIdNotas.add({
        wine.id!: notas,
      });
    }
    return wineIdNotas;
  }

  double textMaxHeight(MultipleServices multipleService, MultipleTasteProvider multipleTaste) {
    List<double> textHeight = [];
    for (Map<String, String> wineIdText in wineIdNotas()) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: wineIdText.values.first, 
          style: style
        ),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: width - (padding * 2) - 2); // 2 Border
      
      textHeight.add(textPainter.size.height);
    }
    return textHeight.max;
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

    final multipleService = Provider.of<MultipleServices>(context);
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    
    return SizedBox(
      height: textMaxHeight(multipleService, multipleTaste) + padding + 20 + 44 + 2 + (multipleService.isMultipleTasted ? 30 : 0), // top padding + 20 Label text + 44 _CustomDropDownButton + 2 Border
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wineIdNotas().length,
        itemBuilder: (context, index) {
          
          final String wineId = wineIdNotas()[index].keys.first;
          final String text = wineIdNotas()[index].values.first;

          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(
              left: index == 0 ? padding : (padding / 2), 
              right: index == (wineIdNotas().length -1) ? padding : (padding / 2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label, style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                Text(text, style: style, textAlign: TextAlign.center),
                  
                const Spacer(),

                if (multipleService.isMultipleTasted) const SizedBox(height: 10),

                if (multipleService.isMultipleTasted) Text(
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

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);
    final multipleTaste = context.read<MultipleTasteProvider>();
    final quizProvider = context.watch<QuizProvider>();

    final correctAnswer = quizProvider.obtainCorrectAnswer(widget.wineId);

    void onselected(int? value) {
      switch (widget.quizTypes) {
        case QuizTypes.vino:
          quizProvider.completeAnswers(wineId: widget.wineId, answerWine: value);
          break;
        case QuizTypes.vista:
          quizProvider.completeAnswers(wineId: widget.wineId, answerEyes: value);
          break;
        case QuizTypes.nariz:
          quizProvider.completeAnswers(wineId: widget.wineId, answerNose: value);
          break;
        case QuizTypes.boca:
          quizProvider.completeAnswers(wineId: widget.wineId, answerMouth: value);                
          break;
      }
    }

    int? userAnswer() {
      final Answer? answer = quizProvider.obtainUserAnswer(widget.wineId);
      switch (widget.quizTypes) {
        case QuizTypes.vino:
          return answer?.answerWine;
        case QuizTypes.vista:
          return answer?.answerEyes;
        case QuizTypes.nariz:
          return answer?.answerNose;
        case QuizTypes.boca:
          return answer?.answerMouth;
      }
    }

    final List<Map<int, String>> wineNumberNameList = List.generate(
      widget.wineList.length, 
      (index) => {
        index + 1: widget.wineList[index].nombre
      }, 
      growable: false,
    );

    Color? answerColor() {
      if (userAnswer() == null) return null;
      if (userAnswer() == correctAnswer) return const Color.fromARGB(255, 0, 143, 57);
      if (userAnswer() != correctAnswer) return const Color.fromARGB(255, 203, 50, 52);
      return null;
    }

    return Transform.translate(
      offset: Offset(multipleTaste.multipleTaste.hidden ? 0 : 14, 0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: DropdownMenu<Map<int, String>>(
          hintText: multipleService.isMultipleTasted 
            ? multipleTaste.multipleTaste.hidden
              ? 'Vino ${userAnswer().toString()}'
              : wineNumberNameList[userAnswer()! - 1].values.first 
            : ' Escoge',
          enabled: multipleService.isMultipleTasted 
            ? false 
            : true,
          alignmentOffset: const Offset(-1, 0),
          width: widget.width,
          textAlign: TextAlign.center,
          textStyle: widget.style.copyWith(
            fontWeight: FontWeight.bold, 
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
          expandedInsets: multipleTaste.multipleTaste.hidden
            ? null
            : EdgeInsets.zero,
          inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            constraints: BoxConstraints.tight(const Size.fromHeight(44)),
            contentPadding: multipleTaste.multipleTaste.hidden
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
              label: multipleTaste.multipleTaste.hidden
                ? 'Vino ${item.keys.first}'
                : item.values.first,
              value: item,
              style: ButtonStyle(
                fixedSize: const WidgetStatePropertyAll(Size.fromHeight(44)),
                padding: WidgetStatePropertyAll(multipleTaste.multipleTaste.hidden 
                  ? const EdgeInsets.only(left: 18) 
                  : const EdgeInsets.symmetric(horizontal: 5)
                ),
              ),
              // labelWidget: Text('Vino ${number.toString()}', style: widget.style)
              labelWidget: Text(
                multipleTaste.multipleTaste.hidden
                  ? 'Vino ${item.keys.first}'
                  : item.values.first,
                style: widget.style,
                textAlign: multipleTaste.multipleTaste.hidden
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