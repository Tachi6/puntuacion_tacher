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
    this.cancelText, 
    this.saveText,
    this.textAlign,
  });

  final String title;
  final Widget content;
  final VoidCallback? onPressedCancel;
  final VoidCallback? onPressedSave;
  final String? cancelText;
  final String? saveText;
  final TextAlign? textAlign;

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
      title: Text(title, textAlign: textAlign),
      content: content,
      actions: [
        if (cancelText != null) TextButton(
          onPressed: onPressedCancel, 
          child: Text(cancelText!),
        ),

        if (saveText != null) TextButton(
          onPressed: onPressedSave,
          child: Text(saveText!),
        ),
      ],
    );
  }
}