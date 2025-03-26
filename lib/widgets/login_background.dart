
// Link https://www.freepik.es/foto-gratis/corchos-vino-sobre-mesa_7630502.htm#query=wine%20taste&position=41&from_view=search&track=ais 
// Image of de Racool_studio en Freepik

import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
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
                opacity: 0.6,
                fit: BoxFit.fitHeight,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/login-background.jpg'),
              ), 
            ),
          ),
          
          widget,          
        ],
    );
  }
}