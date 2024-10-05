import 'package:flutter/material.dart';

class SearchWineButton extends StatelessWidget {
  const SearchWineButton({
    super.key,
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.search, 
        color: colors.onSurface,
        size: 22
      ),
    );
  }
}
