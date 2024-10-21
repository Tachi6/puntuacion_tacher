// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class TacherScreen extends StatefulWidget {

  final String appBarTitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottomSheet;
  final void Function()? onPressedConfirm;
  final void Function()? onPressedBackButon;
  final int? multiplePage;

  const TacherScreen({
    super.key, 
    required this.appBarTitle, 
    this.leading, 
    this.trailing, 
    this.bottomSheet, 
    this.onPressedConfirm, 
    this.onPressedBackButon, 
    this.multiplePage,
  });

  @override
  State<TacherScreen> createState() => _TacherScreenState();
}

class _TacherScreenState extends State<TacherScreen> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final Wines wine = wineForm.wine;

    return Stack(
      children: [
        const FullScreenBackground(image: 'assets/tacher-background.jpg', opacity: 0.3),

        Scaffold(
          appBar: _CustomTacherAppBar(
            onPressedBackButon: widget.onPressedBackButon, 
            appBarTitle: widget.appBarTitle
          ),
          backgroundColor: Colors.transparent,
          body: _CustomTacherBody(widget.multiplePage),
          bottomSheet: CustomBottomSheet(
            wine: wine,
            buttonText: 'Enviar valoración',
            leading: widget.leading ?? const SizedBox(),
            trailing: widget.trailing?? const SizedBox(),
            onPressed: widget.onPressedConfirm,
          ),
        ),
      ],
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class _CustomTacherBody extends StatelessWidget {
  const _CustomTacherBody(this.multiplePage);

  final int? multiplePage;

  @override
  Widget build(BuildContext context) {

    final textos = Textos();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [          
          RatingBox(
            textoTitulo: textos.vistaTitulo,
            textoDescripcion: textos.vistaDescripcion,
            initialRating: 0,
            itemCount: 7,
            minRating: 1,
            name: 'vista',
            multiplePage: multiplePage,
          ),
    
          RatingBox(
            textoTitulo: textos.narizTitulo,
            textoDescripcion: textos.narizDescripcion,
            initialRating: 0,
            itemCount: 9,
            minRating: 1,
            name: 'nariz',
            multiplePage: multiplePage,
          ),
    
          RatingBox(
            textoTitulo: textos.bocaTitulo,
            textoDescripcion: textos.bocaDescripcion,
            initialRating: 0,
            itemCount: 9,
            minRating: 1,
            name: 'boca',
            multiplePage: multiplePage,
          ),
    
          RatingBox(
            textoTitulo: textos.puntosTitulo,
            textoDescripcion: textos.puntosDescripcion,
            initialRating: 0,
            itemCount: 11,
            minRating: 1,
            name: 'puntos',
            multiplePage: multiplePage,
          ),
    
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NotesCommentsBox(titulo: 'Notas de Cata'),
          
              NotesCommentsBox(titulo: 'Comentarios')
            ]
          ),
        ]
      ),
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


