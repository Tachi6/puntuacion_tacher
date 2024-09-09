import 'package:flutter/material.dart';

class MaterialBoxButtonStyle extends StatelessWidget {
  const MaterialBoxButtonStyle({
    super.key,
    this.color,
    this.shadow,
    required this.child,
  });

  final Color? color;
  final Color? shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Material(
      color: color ?? colors.primary,
      shadowColor: shadow ?? colors.shadow,
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      child: child
    );
  }
}
