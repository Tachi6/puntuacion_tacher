
// Link https://www.freepik.es/foto-gratis/corchos-vino-sobre-mesa_7630502.htm#query=wine%20taste&position=41&from_view=search&track=ais 
// Image of de Racool_studio en Freepik

import 'package:flutter/material.dart';

class DisplayNameBackground extends StatelessWidget {
  const DisplayNameBackground({
    super.key, 
    required this.widget, 
  });

  final Widget widget;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            image: const DecorationImage(
              opacity: 0.8,
              fit: BoxFit.fitHeight,
              alignment: Alignment.topCenter,
              image: AssetImage('assets/enter_display_name_background.jpg'),
            ), 
          ),
        ),
        
        widget,
      ],
    );
  }
}