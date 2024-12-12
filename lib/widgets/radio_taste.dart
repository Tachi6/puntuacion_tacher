import 'dart:io' show Platform;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';


enum TasteOptions { empty, unica, multiple }

class RadioTaste extends StatelessWidget {
  const RadioTaste({super.key});

  @override
  Widget build(BuildContext context) {
    return const RadioWidget();
  }
}

class RadioWidget extends StatefulWidget {
  const RadioWidget({super.key});

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  TasteOptions? _taste;  //  = TasteOptions.normal

  @override
  Widget build(BuildContext context) {

    final taste = Provider.of<VisibleOptionsProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
        
    return Row(
      children: [
        const Spacer(),

        SizedBox(
          width: Platform.isAndroid ? 165 : 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Elige el número de vinos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Transform.translate(
                offset: const Offset(-10, -3),
                child: RadioListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  subtitle: Text('Catar un único vino', style: TextStyle(fontSize:12, color: colors.outline)),
                  title: const Text('Cata única', style: TextStyle(fontSize: 14)),
                  value: TasteOptions.unica, 
                  groupValue: _taste, 
                  onChanged: (TasteOptions? value) {
                    _taste = value;
                    taste.taste = value!;
                    multipleTaste.multipleName = '';
                    setState(() {});
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(-10, -20),
                child: RadioListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  subtitle: Text('Catar varios vinos', style: TextStyle(fontSize: 12, color: colors.outline)),
                  title: const Text('Cata múltiple', style: TextStyle(fontSize: 14)),
                  value: TasteOptions.multiple, 
                  groupValue: _taste, 
                  onChanged: (TasteOptions? value) {
                    _taste = value;
                    taste.taste = value!;
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
