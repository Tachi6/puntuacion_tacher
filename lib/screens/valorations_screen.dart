import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/widgets/widgets.dart';

class ValorationsScreen extends StatefulWidget {
  
  const ValorationsScreen({super.key});

  @override
  State<ValorationsScreen> createState() => _ValorationsScreenState();
}

class _ValorationsScreenState extends State<ValorationsScreen> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),     
      body: const ValorationCards(),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}
