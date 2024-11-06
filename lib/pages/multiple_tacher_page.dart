import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/wines.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';

class MultipleTacherPage extends StatelessWidget {
  const MultipleTacherPage({
    super.key, 
    required this.wine, 
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return TacherScreen(
      // appBarTitle: wine.nombre,
      onPressedBackButon: () {
        Navigator.pop(context);
        multipleTaste.resetSettings();
      },
      // bottomSheet: customMultipleBottomSheet,
    );
  }
}