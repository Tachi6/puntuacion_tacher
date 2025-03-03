import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMultipleAppBar({
    super.key, 
    this.actionButton1,
    this.actionButton2,
  });

  final Widget? actionButton1;
  final Widget? actionButton2;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    final size = MediaQuery.of(context).size;
    
    return AppBar(
      toolbarHeight: 48,
      automaticallyImplyLeading: false, 
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            multipleTaste.resetSettings();            
            screenProvider.multiplePage = 0;
          },
          icon: const Icon(Icons.arrow_back_rounded)
        ),

        const SizedBox(width: 48),
          
        Container(
          height: 48,
          alignment: Alignment.center,
          width: size.width - 192,
          child: Text(
            multipleTaste.multipleTaste.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, height: 1.1)
          ),
        ),

        actionButton1 ?? const SizedBox(width: 48),

        actionButton2 ?? const SizedBox(width: 48),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}