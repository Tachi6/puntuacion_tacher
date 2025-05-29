import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/presentation/providers/providers.dart';

class CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMultipleAppBar({
    super.key, 
    this.onPressedActionButton,
    this.onPressedBackButton,
  });

  final void Function()? onPressedActionButton;
  final void Function()? onPressedBackButton;

  @override
  Widget build(BuildContext context) {

    final multipleProvider = context.watch<MultipleProvider>();
    final size = MediaQuery.of(context).size;
    
    return AppBar(
      toolbarHeight: 48,
      automaticallyImplyLeading: false, 
      actions: [
        IconButton(
          onPressed: onPressedBackButton,
          icon: const Icon(Icons.arrow_back_rounded)
        ),

        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            width: size.width - 96,
            child: Text(
              multipleProvider.multipleSelected.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20, height: 1.1)
            ),
          ),
        ),

        onPressedActionButton != null 
          ? IconButton(
            onPressed: onPressedActionButton,
            icon: const Icon(Icons.refresh_rounded)
          )
          : const SizedBox(width: 48),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}