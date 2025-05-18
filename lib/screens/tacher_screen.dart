// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class TacherScreen extends StatefulWidget {

  final String? appBarTitle;
  final Widget? bottomSheet;
  final void Function()? onPressedBackButon;

  const TacherScreen({
    super.key, 
    this.appBarTitle, 
    this.bottomSheet, 
    this.onPressedBackButon, 
  });

  @override
  State<TacherScreen> createState() => _TacherScreenState();
}

class _TacherScreenState extends State<TacherScreen> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        const FullScreenBackground(image: 'assets/tacher-background.jpg', opacity: 0.3),

        Scaffold(
          appBar: widget.appBarTitle == null 
            ? null
            : _CustomTacherAppBar(
              onPressedBackButon: widget.onPressedBackButon, 
              appBarTitle: widget.appBarTitle!
            ),
          backgroundColor: Colors.transparent,
          body: screenHeight < 600
            ? const SingleChildScrollView(child: _CustomTacherBody(isLittleScreen: true))
            : const _CustomTacherBody(isLittleScreen: false),
          bottomSheet: widget.bottomSheet,
          resizeToAvoidBottomInset: false,
        ),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _CustomTacherBody extends StatefulWidget {
  const _CustomTacherBody({required this.isLittleScreen});

  final bool isLittleScreen;

  @override
  State<_CustomTacherBody> createState() => _CustomTacherBodyState();
}

class _CustomTacherBodyState extends State<_CustomTacherBody> {

  @override
  Widget build(BuildContext context) {

    final Textos textos = Textos();
    var titleGroup = AutoSizeGroup();
    var bodyGroup = AutoSizeGroup();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [          
        RatingBox(
          titleText: textos.vistaTitulo,
          bodyText: textos.vistaDescripcion,
          initialRating: 0,
          titleGroup: titleGroup,
          bodyGroup: bodyGroup,
          itemCount: 7,
          minRating: 1,
          name: 'vista',
        ),
    
        if (!widget.isLittleScreen) const Spacer(flex: 1),
        
        RatingBox(
          titleText: textos.narizTitulo,
          bodyText: textos.narizDescripcion,
          initialRating: 0,
          titleGroup: titleGroup,
          bodyGroup: bodyGroup,
          itemCount: 9,
          minRating: 1,
          name: 'nariz',
        ),
    
        if (!widget.isLittleScreen) const Spacer(flex: 1),
        
        RatingBox(
          titleText: textos.bocaTitulo,
          bodyText: textos.bocaDescripcion,
          initialRating: 0,
          titleGroup: titleGroup,
          bodyGroup: bodyGroup,
          itemCount: 9,
          minRating: 1,
          name: 'boca',
        ),
    
        if (!widget.isLittleScreen) const Spacer(flex: 1),
        
        RatingBox(
          titleText: textos.puntosTitulo,
          bodyText: textos.puntosDescripcion,
          initialRating: 0,
          titleGroup: titleGroup,
          bodyGroup: bodyGroup,
          itemCount: 11,
          minRating: 1,
          name: 'puntos',
        ),
    
        if (!widget.isLittleScreen) const Spacer(flex: 2),
        
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            NotesCommentsBox(titulo: 'Notas de Cata'),
        
            NotesCommentsBox(titulo: 'Comentarios')
          ]
        ),
    
        if (!widget.isLittleScreen) const Spacer(flex: 2),
        // Height of BottomSheet + Rating Box Bottom Padding + BottomElement Height
        const SafeArea(
          top: false,
          child: SizedBox(height: 68)
        ),
      ]
    );
  }
}

class _CustomTacherAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomTacherAppBar({
    required this.onPressedBackButon,
    required this.appBarTitle,
  });

  final void Function()? onPressedBackButon;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {

    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;
    
    return AppBar(
      toolbarHeight: 48,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: themeColor.isDarkMode 
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false, 
      actions: [
        IconButton(
          onPressed: onPressedBackButon,
          icon: const Icon(Icons.arrow_back_rounded)
        ),
          
        Container(
          height: 48,
          alignment: Alignment.center,
          width: size.width - 96,
          child: Text(
            appBarTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, height: 1.1)
          ),
        ),
    
        const SizedBox(width: 48),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}


