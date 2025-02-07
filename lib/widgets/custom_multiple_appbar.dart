import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMultipleAppBar({super.key, this.allowActionButtons = false});

  final bool allowActionButtons;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleServices>(context);
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
   
        multipleService.isMultipleTasted && allowActionButtons && multipleTaste.overview
          ? IconButton(
            onPressed: () async {
              final Multiple multipleUpdated = await multipleService.loadMultipleToUpdate(multipleTaste.multipleName);
              multipleTaste.updateMultipleTaste(multipleUpdated);
            },
            icon: const Icon(Icons.refresh_rounded)
          )
          : const SizedBox(width: 48),

        multipleService.isMultipleTasted && allowActionButtons
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