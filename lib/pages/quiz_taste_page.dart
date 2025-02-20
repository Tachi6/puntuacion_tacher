import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

enum TasteNotesTypes {vista, nariz, boca}

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
    const double padding = 10;
    final double width = multipleTaste.winesMultipleTaste.length < 3
      ? (MediaQuery.of(context).size.width / 2) - ((padding * 3) / 2)
      : (MediaQuery.of(context).size.width / 2) - (padding * 2.25);
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: multipleTaste.multipleTaste.tasteQuiz! == 'simple' 
        ? SimpleTasteQuiz(width: width, style: style, padding: padding)
        : AdvancedTasteQuiz(width: width, style: style, padding: padding),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class CustomLabelTest extends StatelessWidget {
  const CustomLabelTest({
    super.key,
    required this.label,
    required this.padding,
    required this.style,
  });

  final String label;
  final double padding;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: padding),
      alignment: Alignment.centerLeft,
      child: Text(label, style: style!.copyWith(fontWeight: FontWeight.bold)),
    );
  }
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

  double textMaxHeight(List<Wines> wineList) {
    List<double> textHeight = [];
    for (Wines wine in wineList) {
      double allTextHeight = 200; // 200 of 10 rows of label text

      allTextHeight = allTextHeight + obtainTextHeight(wine.nombre);
      allTextHeight = allTextHeight + obtainTextHeight(wine.bodega);
      allTextHeight = allTextHeight + obtainTextHeight(wine.region);
      allTextHeight = allTextHeight + obtainTextHeight(wine.tipo);
      allTextHeight = allTextHeight + obtainTextHeight(wine.variedades);
      allTextHeight = allTextHeight + obtainTextHeight(wine.graduacion);
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

    return SingleChildScrollView(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Cata Quiz', // TODO: poner aciertos 5/6 por ejemplo
              style: style!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
      
          Container(
            // height: 1760, //TODO: hacer height mas dinamico
            height: textMaxHeight(wineList) + padding + 44 + 2 + 110 + (multipleService.isMultipleTasted ? 50 : 0), // top padding + 44 _CustomDropDownButton + 2 Border + 108 of container padding + rows checkWine
            padding: const EdgeInsets.only(top: 40, bottom: 68),
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
                  child: SimpleQuizRow(style: style, wine: wine, index: index),
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
  });

  final TextStyle? style;
  final Wines wine;
  final int index;

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

    return Column(
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
        Text('', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text('Cata Vista', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaVista, style: style, textAlign: TextAlign.center),
        Text('Cata Nariz', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaNariz, style: style, textAlign: TextAlign.center),
        Text('Cata Boca', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        Text(wine.notaBoca, style: style, textAlign: TextAlign.center),
                
        const Spacer(),

        if (multipleService.isMultipleTasted) const SizedBox(height: 20),

        if (multipleService.isMultipleTasted) Text('Vino correcto: ${(index + 1).toString()}', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

        if (multipleService.isMultipleTasted) const SizedBox(height: 10),

        _CustomDropDownButton(
          width: 125, 
          style: style!,
          onSelected: (value) => context.read<QuizProvider>().completeAnswers(wineId: wine.id!, answerWine: value),
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

  List<Map<String, String>> wineIdNotasVista(MultipleServices multipleService, MultipleTasteProvider multipleTaste) {
    List<Wines> wineList = [];

    !multipleService.isMultipleTasted
      ? wineList = [...multipleTaste.wineListShuffled()]
      : wineList = [...multipleTaste.winesMultipleTaste];

    final List<Map<String, String>> wineIdNotasVista = [];
    for (Wines wine in wineList) {
      wineIdNotasVista.add({
        wine.id!: wine.notaVista,
      });
    }
    return wineIdNotasVista;
  }

  List<Map<String, String>> wineIdNotasNariz(MultipleServices multipleService, MultipleTasteProvider multipleTaste) {
    List<Wines> wineList = [];

    !multipleService.isMultipleTasted
      ? wineList = [...multipleTaste.wineListShuffled()]
      : wineList = [...multipleTaste.winesMultipleTaste];

    final List<Map<String, String>> wineIdNotasNariz = [];
    for (Wines wine in wineList) {
      wineIdNotasNariz.add({
        wine.id!: wine.notaNariz
      });
    }
    return wineIdNotasNariz;
  }

  List<Map<String, String>> wineIdNotasBoca(MultipleServices multipleService, MultipleTasteProvider multipleTaste) {
    List<Wines> wineList = [];

    !multipleService.isMultipleTasted
      ? wineList = [...multipleTaste.wineListShuffled()]
      : wineList = [...multipleTaste.winesMultipleTaste];

    final List<Map<String, String>> wineIdNotasBoca = [];
    for (Wines wine in wineList) {
      wineIdNotasBoca.add({
        wine.id!: wine.notaBoca
      });
    }
    return wineIdNotasBoca;
  }

  @override
  Widget build(BuildContext context) {

    final multipleService = context.read<MultipleServices>(); 
    final multipleTaste = context.read<MultipleTasteProvider>();

    return SingleChildScrollView(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Cata Quiz', 
              style: style!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 68),
            child: Column(
              children: [
                AdvancedQuizRowSpecs(
                  label: 'Ficha Técnica',
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),

                AdvancedQuizRowNotes(
                  tasteNotesTypes: TasteNotesTypes.vista,
                  rowWineIdText: wineIdNotasVista(multipleService, multipleTaste), 
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  tasteNotesTypes: TasteNotesTypes.nariz,
                  rowWineIdText: wineIdNotasNariz(multipleService, multipleTaste), 
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  tasteNotesTypes: TasteNotesTypes.boca,
                  rowWineIdText: wineIdNotasBoca(multipleService, multipleTaste), 
                  padding: padding, 
                  width: width, 
                  style: style,
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
    required this.label,
    required this.padding,
    required this.width,
    required this.style,
  });

  final String label;
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
      height: textMaxHeight(wineList) + padding + 44 + 2 + (multipleService.isMultipleTasted ? 50 : 0), // top padding + 44 _CustomDropDownButton + 2 Border
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

                if (multipleService.isMultipleTasted) const SizedBox(height: 20),

                if (multipleService.isMultipleTasted) Text('Vino correcto: ${(index + 1).toString()}', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                if (multipleService.isMultipleTasted) const SizedBox(height: 10),
            
                _CustomDropDownButton(
                  width: 125, 
                  style: style!,
                  onSelected: (value) => context.read<QuizProvider>().completeAnswers(wineId: wine.id!, answerWine: value),
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
    required this.tasteNotesTypes,
    required this.rowWineIdText,
    required this.padding,
    required this.width,
    required this.style,
    this.onSelected,
  });

  final TasteNotesTypes tasteNotesTypes;
  final List<Map<String, String>> rowWineIdText;
  final double padding;
  final double width;
  final TextStyle? style;
  final Function(int?)? onSelected;

  double textMaxHeight() {
    List<double> textHeight = [];
    for (Map<String, String> wineIdText in rowWineIdText) {
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
    switch (tasteNotesTypes) {
      case TasteNotesTypes.vista:
        return 'Cata Vista';
      case TasteNotesTypes.nariz:
        return 'Cata Nariz';
      case TasteNotesTypes.boca:
        return 'Cata Boca';
    }
  }

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

    return SizedBox(
      height: textMaxHeight() + padding + 20 + 44 + 2 + (multipleService.isMultipleTasted ? 50 : 0), // top padding + 20 Label text + 44 _CustomDropDownButton + 2 Border
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rowWineIdText.length,
        itemBuilder: (context, index) {
          
          final String wineId = rowWineIdText[index].keys.first;
          final String text = rowWineIdText[index].values.first;
      
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(
              left: index == 0 ? padding : (padding / 2), 
              right: index == (rowWineIdText.length -1) ? padding : (padding / 2)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label, style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text(text, style: style, textAlign: TextAlign.center),
                  
                const Spacer(),

                if (multipleService.isMultipleTasted) const SizedBox(height: 20),

                if (multipleService.isMultipleTasted) Text('Vino correcto: ${(index + 1).toString()}', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                if (multipleService.isMultipleTasted) const SizedBox(height: 10),
            
                _CustomDropDownButton(
                  width: 125, 
                  style: style!,
                  onSelected: (value) {
                    switch (tasteNotesTypes) {
                      case TasteNotesTypes.vista:
                        context.read<QuizProvider>().completeAnswers(wineId: wineId, answerEyes: value);
                        break;
                      case TasteNotesTypes.nariz:
                        context.read<QuizProvider>().completeAnswers(wineId: wineId, answerNose: value);
                        break;
                      case TasteNotesTypes.boca:
                        context.read<QuizProvider>().completeAnswers(wineId: wineId, answerMouth: value);                
                        break;
                    }
                  }
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
  const _CustomDropDownButton({required this.width, required this.style, this.onSelected});

  final double width;
  final TextStyle style;
  final Function(int?)? onSelected;

  @override
  State<_CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<_CustomDropDownButton> {

  int selectedWine = 1;

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

    final List<int> wineNumbers = List.generate(
      context.read<MultipleTasteProvider>().winesMultipleTaste.length, 
      (index) => index + 1, 
      growable: false,
    );

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: DropdownMenu(
        hintText: ' Escoge',
        enabled: multipleService.isMultipleTasted ? false : true,
        alignmentOffset: const Offset(-1, 0),
        width: widget.width,
        textAlign: TextAlign.center,
        textStyle: widget.style.copyWith(fontWeight: FontWeight.bold, color: null), // TODO: change color if is right
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
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          constraints: BoxConstraints.tight(const Size.fromHeight(44)),
          contentPadding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 8),
        ),
        dropdownMenuEntries: wineNumbers.map((int number) {
          return DropdownMenuEntry(
            label: 'Vino ${number.toString()}',
            value: number,
            style: const ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size.fromHeight(44)),
              padding: WidgetStatePropertyAll(EdgeInsets.only(left: 18)),
            ),
            labelWidget: Text('Vino ${number.toString()}', style: widget.style)
          );
        }).toList(),
        onSelected: widget.onSelected,
      ),
    );
  }
}