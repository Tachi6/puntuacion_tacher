import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';

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
    return Container(
      height: 58,
      alignment: Alignment.center,
      width: double.infinity,
      // padding: const EdgeInsets.symmetric(horizontal: 16),
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
            : const Spacer(),

          widgetButton,

          leading != null || trailing != null
            ? SizedBox(
              height: 58, 
              width: 58, 
              child: trailing
            )
            : const Spacer(),
        ],
      ),
    );
  }
}
