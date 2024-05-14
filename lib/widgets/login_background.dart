
// Link https://www.freepik.es/foto-gratis/corchos-vino-sobre-mesa_7630502.htm#query=wine%20taste&position=41&from_view=search&track=ais 
// Image of de Racool_studio en Freepik

import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';

class LoginBackground extends StatelessWidget {

  final Widget widget;

  const LoginBackground(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                opacity: 0.6,
                fit: BoxFit.fitHeight,
                alignment: Alignment.topCenter,
                // TODO poner de nuevo el assets antes del background
                image: AssetImage('assets/login-background.jpg'),
              ), 
            ),
          ),
          Positioned(
            right: 40,
            top: 60,
            child: Text(
              'TACHER', 
              style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: redColor()),
            ),
          ),
          Positioned(
            right: 40,
            top: 130,
            child: Text(
              'Tu rincon de amigos y... Vinos', 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: redColor()),
            ),
          ),
          
          widget          
        ],
      ),
    );
  }
}