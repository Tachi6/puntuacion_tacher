import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';

class MultipleTacherPage extends StatefulWidget {
  const MultipleTacherPage({
    super.key, 
    required this.appBarTitle, 
  });

  final String appBarTitle;

  @override
  State<MultipleTacherPage> createState() => _MultipleTacherPageState();
}

class _MultipleTacherPageState extends State<MultipleTacherPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final pageProvider = Provider.of<ScreensProvider>(context);

    return TacherScreen(
      appBarTitle: widget.appBarTitle,
      onPressedBackButon: () {
        Navigator.pop(context);
        pageProvider.multiplePage = 0;
        multipleTaste.resetSettings();
      },
      // bottomSheet: customMultipleBottomSheet,
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}