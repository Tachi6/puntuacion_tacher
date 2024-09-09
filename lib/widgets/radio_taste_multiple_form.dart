import 'package:flutter/material.dart';

enum TasteOptionsMultipleForm { empty, acceder, organizar }

class RadioTasteMultipleForm extends StatelessWidget {
  const RadioTasteMultipleForm({super.key});

  @override
  Widget build(BuildContext context) {
    return const RadioWidgetMultipleForm();
  }
}

class RadioWidgetMultipleForm extends StatefulWidget {
  const RadioWidgetMultipleForm({super.key});

  @override
  State<RadioWidgetMultipleForm> createState() => _RadioWidgetMultipleFormState();
}

class _RadioWidgetMultipleFormState extends State<RadioWidgetMultipleForm> {
  TasteOptionsMultipleForm? _taste;  //  = TasteOptions.normal

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 285,
      height: 110,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          const Text('Selecciona el tipo de cata a realizar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          // const SizedBox(height: 10),
          Transform.scale(
            scale: 0.7,
            alignment: Alignment.topCenter,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: RadioListTile(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    contentPadding: const EdgeInsets.only(right: 0),
                    subtitle: Text('Catar vino del listado o añadirlo', style: TextStyle(fontSize:15, color: colors.outline)),
                    title: const Text('Cata con referencia', style: TextStyle(fontSize: 20)),
                    value: TasteOptionsMultipleForm.acceder, 
                    groupValue: _taste, 
                    onChanged: (TasteOptionsMultipleForm? value) {
                      _taste = value;
                      setState(() {});
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: RadioListTile(
                    contentPadding: const EdgeInsets.only(right: 0),
                    subtitle: Text('Catar sin referencias del vino', style: TextStyle(fontSize: 15, color: colors.outline)),
                    title: const Text('Cata a ciegas', style: TextStyle(fontSize: 20)),
                    value: TasteOptionsMultipleForm.organizar, 
                    groupValue: _taste, 
                    onChanged: (TasteOptionsMultipleForm? value) {
                      _taste = value;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
