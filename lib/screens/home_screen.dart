/*
<a href="https://www.freepik.es/foto-gratis/salpicaduras-vino-tinto-sobre-fondo-blanco_13635709.htm#query=vino&position=12&from_view=search&track=sph">Imagen de master1305</a> en Freepik
*/

import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final List<Widget> screensList = const [
    ValorationsScreen(),
    TasteScreen(),
    ListScreen(),
    MyUserScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: screensList,
      ),
      bottomNavigationBar: CustomNavigationBar(pageController: pageController)
    );
  }
}