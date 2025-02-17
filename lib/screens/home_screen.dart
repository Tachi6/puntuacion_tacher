/*
<a href="https://www.freepik.es/foto-gratis/salpicaduras-vino-tinto-sobre-fondo-blanco_13635709.htm#query=vino&position=12&from_view=search&track=sph">Imagen de master1305</a> en Freepik
*/

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
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
      keepPage: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setElementsSize(context));
  }

  void setElementsSize(BuildContext context) {
    final screenElementsSizeProvider = Provider.of<ScreenElementsSizeProvider>(context, listen: false);
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    screenElementsSizeProvider.bottomElementHeight = bottomPadding;
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
   
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const ClampingScrollPhysics(),
        controller: pageController,
        children: screensList,
        onPageChanged: (value) => screenProvider.currentScreen = value,
      ),
      bottomNavigationBar: CustomNavigationBar(pageController: pageController)
    );
  }
}