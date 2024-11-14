import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMultipleAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context);
    final size = MediaQuery.of(context).size;
    
    return AppBar(
      toolbarHeight: 48,
      automaticallyImplyLeading: false, 
      actions: [
        IconButton(
          onPressed: () {
            multipleTaste.resetSettings();            
            Navigator.pop(context);
            screenProvider.multipleScreen = 0;
          },
          icon: const Icon(Icons.arrow_back_rounded)
        ),
          
        Container(
          height: 48,
          alignment: Alignment.center,
          width: size.width - 96,
          child: Text(
            multipleTaste.multipleTaste.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, height: 1.1)
          ),
        ),
    
        multipleService.isMultipleTasted && screenProvider.multipleScreen != 0
          ? IconButton(
            onPressed: () => multipleTaste.overview = !multipleTaste.overview,
            icon: const Icon(Icons.autorenew_rounded)
          )
          : const SizedBox(width: 48),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}