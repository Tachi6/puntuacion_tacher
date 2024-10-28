import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key, 
    this.wine, 
    required this.buttonText,
    this.leading, 
    this.trailing, 
    this.onPressed, 
  });

  final Wines? wine;
  final String buttonText;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 58, 
            width: 58, 
            child: leading
          ),

          CustomElevatedButton(
            width: 160,
            height: 100/3,
            onPressed: onPressed,
            child: Text(buttonText),
          ),

          SizedBox(
            height: 58, 
            width: 58, 
            child: trailing
          ),
        ],
      ),
    );
  }
}
