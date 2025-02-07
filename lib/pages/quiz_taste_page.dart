import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

class QuizTastePage extends StatelessWidget {
  const QuizTastePage({super.key});

  @override
  Widget build(BuildContext context) {

    final double width = MediaQuery.of(context).size.width / 2;
    final TextStyle? style = Theme.of(context).textTheme.bodyMedium;
    const double padding = 10;

    return Scaffold(
      appBar: const CustomMultipleAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),

          CustomLabelTest(label: 'Cata Vista',padding: padding, style: style),
      
          CustomQuestionTest(width: width, style: style, padding: padding),

          const SizedBox(height: 10),

          CustomLabelTest(label: 'Cata Nariz',padding: padding, style: style),
      
          CustomQuestionTest(width: width, style: style, padding: padding),

          const SizedBox(height: 10),

          CustomLabelTest(label: 'Cata Boca',padding: padding, style: style),
      
          CustomQuestionTest(width: width, style: style, padding: padding),
        ],
      ),
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

class CustomQuestionTest extends StatelessWidget {
  CustomQuestionTest({
    super.key,
    required this.width,
    required this.style,
    required this.padding,
  });

  final double width;
  final TextStyle? style;
  final double padding;
  final List<String> textTest = [
    'Velit ex do aliquip eu in est excepteur quis nostrud in quis consectetur laboris laboris.',
    'Nostrud laboris laboris consequat aute laborum in pariatur in id ullamco. Aute dolor non ad irure reprehenderit.',
    'Incididunt ea enim consectetur dolore occaecat quis exercitation ad occaecat esse consequat cillum quis. Dolor officia laborum nostrud nulla dolore voluptate.'
    'Enim nulla ad esse aliqua aute eu.',
    'Dolor officia laborum nostrud nulla dolore voluptate.'
  ];

  double textMaxHeight() {
    List<double> textHeight = [];
    for (String text in textTest) {
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: text, 
          style: style
        ),
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: width - padding);

      textHeight.add(textPainter.size.height);
    }

    return textHeight.max;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textMaxHeight() + 65, // 20 (10+10) padding, 44 dropdownbutton + 11 extra
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: textTest.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(padding),
            width: width,
            height: 10,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(textTest[index], style: style),

                const Spacer(),
            
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
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: DropdownMenu( 
        width: widget.width,
        textStyle: widget.style.copyWith(fontWeight: FontWeight.bold),
        trailingIcon: Transform.translate(
          offset: Offset(0, -2),
          child: Icon(Icons.arrow_drop_down)
        ),
        selectedTrailingIcon: Transform.translate(
          offset: Offset(0, -2),
          child: Icon(Icons.arrow_drop_up)
        ),
        menuStyle: MenuStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.all(0))
        ),
        inputDecorationTheme: InputDecorationTheme(

          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderRadius: BorderRadius.circular(12)
          ),
          constraints: BoxConstraints.tight(Size.fromHeight(44)),
          contentPadding: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 18),
          
        ),     
        initialSelection: wineNumbers[0],
        dropdownMenuEntries: wineNumbers.map((int number) {
          return DropdownMenuEntry(
            label: 'Vino ${number.toString()}',
            value: number,
            style: ButtonStyle(
              fixedSize: WidgetStatePropertyAll(Size.fromHeight(44)),
              padding: WidgetStatePropertyAll(EdgeInsets.only(left: 18))
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