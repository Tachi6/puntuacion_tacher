import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

  final double width;
  final double? height;
  final Color? color;
  final void Function()? onPressed;
  final Widget child;

  const CustomElevatedButton({super.key, required this.width, this.height, this.color, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final defaultHeight = width / 3;
    final double borderRadius = (15 * (height ?? defaultHeight)) / 50;

    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size(width, height ?? defaultHeight)),
        elevation: const WidgetStatePropertyAll(1),
        backgroundColor: WidgetStatePropertyAll(color ?? colors.surfaceContainerHigh),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius))),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}