
// Link https://www.freepik.es/foto-gratis/corchos-vino-sobre-mesa_7630502.htm#query=wine%20taste&position=41&from_view=search&track=ais 
// Image of de Racool_studio en Freepik

import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  const LoginBackground({
    super.key, 
    required this.widget, 
    required this.backgroundColor
  });

  final Widget widget;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.6,
                fit: BoxFit.fitHeight,
                alignment: Alignment.topCenter,
                image: AssetImage('assets/login-background.jpg'),
              ), 
            ),
          ),
          Positioned(
            right: 40,
            top: 60,
            child: Text(
              'TACHER', 
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: colors.primary),
            ),
          ),
          Positioned(
            right: 40,
            top: 130,
            child: Text(
              'Tu rincon de amigos y... Vinos', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primary),
            ),
          ),
          
          widget,          
        ],
      ),
    );
  }
}