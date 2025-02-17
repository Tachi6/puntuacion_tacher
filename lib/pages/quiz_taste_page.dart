import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

class QuizTastePage extends StatelessWidget {
  const QuizTastePage({super.key});

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    const double padding = 10;
    final double width = multipleTaste.winesMultipleTaste.length < 3
      ? (MediaQuery.of(context).size.width / 2) - ((padding * 3) / 2)
      : (MediaQuery.of(context).size.width / 2) - (padding * 2);
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: multipleTaste.multipleTaste.tasteQuiz! == 'simple' 
        ? SimpleTasteQuiz(width: width, style: style, padding: padding)
        : AdvancedTasteQuiz(width: width, style: style, padding: padding),
    );
  }
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

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final List<Wines> wineList = [...multipleTaste.winesMultipleTaste];
    if (!multipleService.isMultipleTasted) wineList.shuffle();

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

    double textMaxHeight() {
      List<double> textHeight = [];
      for (Wines wine in wineList) {
        double allTextHeight = 0;
        allTextHeight = allTextHeight + obtainTextHeight(wine.nombre);
        allTextHeight = allTextHeight + obtainTextHeight(wine.bodega);
        allTextHeight = allTextHeight + obtainTextHeight(wine.region);
        allTextHeight = allTextHeight + obtainTextHeight(wine.tipo);
        allTextHeight = allTextHeight + obtainTextHeight(wine.variedades);
        allTextHeight = allTextHeight + obtainTextHeight(wine.graduacion);
        allTextHeight = allTextHeight + obtainTextHeight(wine.notaVista);
        allTextHeight = allTextHeight + obtainTextHeight(wine.notaNariz);
        allTextHeight = allTextHeight + obtainTextHeight(wine.notaBoca);
        if (multipleService.isMultipleTasted) {
          allTextHeight = allTextHeight + 50; 
        }
        textHeight.add(allTextHeight + 200); // 200 of 10 rows of label text
      }
      // To prevent context.pop on back button, then rowText is empty
      if (wineList.isEmpty) return 0;
      return textHeight.max;
    }

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
            // height: 1760,
            height: textMaxHeight() + padding + 44 + 2 + 110, // top padding + 44 _CustomDropDownButton + 2 Border + 108 of container padding
            padding: const EdgeInsets.only(top: 40, left: 10, bottom: 68),
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
                  margin: EdgeInsets.only(right: padding),
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

        _CustomDropDownButton(width: 125, style: style!),
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

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
    final List<Wines> wineList = [...multipleTaste.winesMultipleTaste];
    if (!multipleService.isMultipleTasted) wineList.shuffle();

    final List<String> notasVista = [];
    for (Wines wine in wineList) {
      notasVista.add(wine.notaVista);
    }
    final List<String> notasNariz = [];
    for (Wines wine in wineList) {
      notasNariz.add(wine.notaNariz);
    }
    final List<String> notasBoca = [];
    for (Wines wine in wineList) {
      notasBoca.add(wine.notaBoca);
    }

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
            padding: const EdgeInsets.only(top: 40, left: 10, bottom: 68),
            child: Column(
              children: [
                AdvancedQuizRowSpecs(
                  label: 'Ficha Técnica',
                  wineList: wineList, 
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),

                AdvancedQuizRowNotes(
                  label: 'Cata Vista',
                  rowText: notasVista, 
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  label: 'Cata Nariz',
                  rowText: notasNariz, 
                  padding: padding, 
                  width: width, 
                  style: style
                ),
      
                const SizedBox(height: 10),
      
                AdvancedQuizRowNotes(
                  label: 'Cata Boca',
                  rowText: notasBoca, 
                  padding: padding, 
                  width: width, 
                  style: style
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
    required this.wineList,
    required this.padding,
    required this.width,
    required this.style,
  });

  final String label;
  final List<Wines> wineList;
  final double padding;
  final double width;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

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

    double textMaxHeight() {
      List<double> textHeight = [];
      for (Wines wine in wineList) {
        double allTextHeight = 0;
        allTextHeight = allTextHeight + obtainTextHeight(wine.nombre);
        allTextHeight = allTextHeight + obtainTextHeight(wine.bodega);
        allTextHeight = allTextHeight + obtainTextHeight(wine.region);
        allTextHeight = allTextHeight + obtainTextHeight(wine.tipo);
        allTextHeight = allTextHeight + obtainTextHeight(wine.variedades);
        allTextHeight = allTextHeight + obtainTextHeight(wine.graduacion);
        if (multipleService.isMultipleTasted) {
          allTextHeight = allTextHeight + 50; 
        }
        textHeight.add(allTextHeight + 120); // 120 of 6 rows of label text
      }
      // To prevent context.pop on back button, then rowText is empty
      if (wineList.isEmpty) return 0;
      return textHeight.max;
    }

    return SizedBox(
      height: textMaxHeight() + padding + 44 + 2, // top padding + 44 _CustomDropDownButton + 2 Border
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
            margin: EdgeInsets.only(right: padding),
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
            
                _CustomDropDownButton(width: 125, style: style!),
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
    required this.label,
    required this.rowText,
    required this.padding,
    required this.width,
    required this.style,
  });

  final String label;
  final List<String> rowText;
  final double padding;
  final double width;
  final TextStyle? style;

  double textMaxHeight() {
    List<double> textHeight = [];
    for (String text in rowText) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text, 
          style: style
        ),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: width - (padding * 2) - 2); // 2 Border
      
      textHeight.add(textPainter.size.height);
    }
    // To prevent context.pop on back button, then rowText is empty
    if (rowText.isEmpty) return 0;
    return textHeight.max;
  }

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

    return SizedBox(
      height: textMaxHeight() + padding + 20 + 44 + 2 + (multipleService.isMultipleTasted ? 50 : 0), // top padding + 20 Label text + 44 _CustomDropDownButton + 2 Border
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: rowText.length,
        itemBuilder: (context, index) {
      
          final String text = rowText[index];
      
          return Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(12),         
            ),
            width: width,
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            margin: EdgeInsets.only(right: padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(label, style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                Text(text, style: style, textAlign: TextAlign.center),
                  
                const Spacer(),

                if (multipleService.isMultipleTasted) const SizedBox(height: 20),

                if (multipleService.isMultipleTasted) Text('Vino correcto: ${(index + 1).toString()}', style: style!.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                if (multipleService.isMultipleTasted) const SizedBox(height: 10),
            
                _CustomDropDownButton(width: 125, style: style!),
              ],
            ),
          );
        },
      
      ),
    );
  }
}

class _CustomDropDownButton extends StatefulWidget {
  const _CustomDropDownButton({required this.width, required this.style});

  final double width;
  final TextStyle style;

  @override
  State<_CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<_CustomDropDownButton> {

  int selectedWine = 1;

  final List<int> wineNumbers = [10, 20, 30, 40, 50];

  @override
  Widget build(BuildContext context) {

    final multipleService = Provider.of<MultipleServices>(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: DropdownMenu(
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
          contentPadding: const EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 17),
        ),
        initialSelection: wineNumbers[0],
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
        // onSelected: (value) {
        //   selectedWine = value!;
        //   setState(() {});
        // },
      ),
    );
  }
}