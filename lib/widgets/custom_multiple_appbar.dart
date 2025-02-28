import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomMultipleAppBar({
    super.key, 
    this.allowActionButtons = false, 
    this.refreshQuiz,
    this.refreshOverview,
    this.changeOverview
  });

  final bool allowActionButtons;
  final void Function()? refreshQuiz;
  final void Function()? refreshOverview;
  final void Function()? changeOverview;

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
   
        (multipleService.isMultipleTasted && multipleTaste.overview && refreshOverview != null && refreshQuiz == null) 
          ? IconButton(
            onPressed: refreshOverview,
            icon: const Icon(Icons.refresh_rounded)
          )
          : const SizedBox(width: 48),

        if (multipleService.isMultipleTasted && changeOverview != null) IconButton(
          onPressed: changeOverview,
          icon: const Icon(Icons.autorenew_rounded)
        ),

        if (refreshQuiz != null) IconButton(
          onPressed: refreshQuiz,
          icon: const Icon(Icons.refresh_rounded)
        ),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}