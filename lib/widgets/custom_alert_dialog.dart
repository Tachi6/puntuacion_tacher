import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key, 
    required this.title,
    required this.content, 
    this.onPressedCancel, 
    this.onPressedSave, 
    required this.cancelText, 
    required this.saveText
  });

  final String title;
  final Widget content;
  final VoidCallback? onPressedCancel;
  final VoidCallback? onPressedSave;
  final String cancelText;
  final String saveText;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);   

    return AlertDialog(
      backgroundColor: themeColor.isDarkMode
        ? colors.surfaceContainer
        : colors.surfaceContainerLow,
      insetPadding: const EdgeInsets.all(20),
      actionsPadding: const EdgeInsets.only(bottom: 12, right: 16),
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: onPressedCancel, 
          child: Text(cancelText),
        ),

        TextButton(
          onPressed: onPressedSave,
          child: Text(saveText),
        ),
      ],
    );
  }
}