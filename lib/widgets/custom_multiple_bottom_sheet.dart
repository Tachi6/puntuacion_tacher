import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class CustomMultipleBottomSheet extends StatelessWidget {
  const CustomMultipleBottomSheet({
    super.key,
    required this.onPressed, 
  });

  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();

    return CustomBottomSheet(
      widgetButton: CustomElevatedButton(
        width: 120,
        onPressed: onPressed,
        label: multipleProvider.isMultipleTasted
          ? 'Salir'
          : 'Enviar',
        isSendingLabel: multipleProvider.isMultipleTasted
          ? 'Salir'
          : 'Enviando',
      ),
    );
  }
}