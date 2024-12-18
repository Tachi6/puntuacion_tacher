import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key, 
    this.wine,
    required this.widgetButton, 
    this.leading, 
    this.trailing,
  });

  final Wines? wine;
  final Widget widgetButton;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {

    final screenElementsSizeProvider = Provider.of<ScreenElementsSizeProvider>(context);
    final double bottomPadding = screenElementsSizeProvider.bottomElementHeight;
    
    return Container(
      height: 58 + bottomPadding,
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.only(bottom: bottomPadding, right: 16, left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading != null || trailing != null 
            ? SizedBox(
              height: 58, 
              width: 58, 
              child: leading
            )
            : const SizedBox(),

          widgetButton,

          leading != null || trailing != null
            ? SizedBox(
              height: 58, 
              width: 58, 
              child: trailing
            )
            : const SizedBox(),
        ],
      ),
    );
  }
}
