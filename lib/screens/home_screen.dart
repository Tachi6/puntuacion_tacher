/*
<a href="https://www.freepik.es/foto-gratis/salpicaduras-vino-tinto-sobre-fondo-blanco_13635709.htm#query=vino&position=12&from_view=search&track=sph">Imagen de master1305</a> en Freepik
*/

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: _HomeScreenBody(),
      bottomNavigationBar: CustomNavigationBar(),
    );
  }
}
  
class _HomeScreenBody extends StatefulWidget {

  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true
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
    
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    if (pageController.hasClients) {
      pageController.animateToPage(
        screenProvider.currentScreen, 
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeInOut
      );
    }

    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: pageController,
      children: screensList
    );
  }
}