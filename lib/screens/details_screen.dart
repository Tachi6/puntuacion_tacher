// Photo by <a href="/photographer/muddy-31912">muddy</a> on <a href="/">Freeimages.com</a>

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {

  final Wines wine;
  final WineTaste? wineTaste;
  final String? email;
  final String source;

  const DetailsScreen({
    super.key, 
    required this.wine, 
    this.wineTaste,
    this.email, 
    required this.source
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BottomImageBackground(image: 'assets/details-background.jpg', opacity: 0.4),

          CustomScrollView(
            slivers: [
              _CustomAppBar(wine: wine, user: email, source: source),

              SliverList(
                delegate: SliverChildListDelegate([
          
                  _WinePoster(wine: wine, wineTaste: wineTaste, user: email, source: source)
                
                ])           
              )
            ],
          ),
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({
    required this.wine, 
    this.user, 
    required this.source
  });

  final Wines wine;
  final String? user;
  final String source;

  ImageProvider<Object>? imageProvider() {
    if (wine.logoBodega != null) return NetworkImage(wine.logoBodega!);
    return const AssetImage('initial-multiple-background.jpg');
  }

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    
    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;

    return ImagePixels(
      imageProvider: imageProvider(), 
      builder: (context, img) {

        final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
        final Color backgroundColor = img.pixelColorAtAlignment!(Alignment.topLeft);
        Color frontColor;
        SystemUiOverlayStyle? statusBarMode;

        if(backgroundColor.computeLuminance() > 0.179) {
          if (themeColor.isDarkMode) {
            frontColor = colors.surface;
          }
          else {
            frontColor = colors.inverseSurface;
          }
          statusBarMode = SystemUiOverlayStyle.dark;
        }
        else {
          if (themeColor.isDarkMode) {
            frontColor = colors.inverseSurface;
          }
          else {
            frontColor = colors.surface;
          }
          statusBarMode = SystemUiOverlayStyle.light;
        }

        return SliverAppBar(
          toolbarHeight: 150 + statusBarHeight,
          systemOverlayStyle: wine.logoBodega != null ? statusBarMode : null,
          automaticallyImplyLeading: false,
          pinned: true,
          floating: false,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.all(0),
            centerTitle: true,
            title: _AppBarTextAndButtons(statusBarHeight: statusBarHeight, wine: wine, frontColor: frontColor, user: user, source: source),
            background: _AppBarBackgroundImage(wine: wine, backgroundColor: backgroundColor),
          ),
        );  
      },
    );
  }
}

class _AppBarTextAndButtons extends StatelessWidget {
  const _AppBarTextAndButtons({
    required this.statusBarHeight,
    required this.wine,
    required this.frontColor,
    required this.user,
    required this.source,
  });

  final double statusBarHeight;
  final Wines wine;
  final Color frontColor;
  final String? user;
  final String source;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: wine.logoBodega != null ? frontColor : null
    );     

    return Container(
      width: double.infinity,
      color: Colors.black12,
      alignment: Alignment.center,
      child:Column(
        children: [
          SizedBox(
            height: statusBarHeight
          ),
    
          Container(
            height: 48,
            width: double.infinity,
            alignment: Alignment.center,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: wine.logoBodega != null 
                      ? frontColor
                      : null
                    ),
                  onPressed: () => Navigator.pop(context),
                ),
          
                const Spacer(),
          
                IconButton(
                  tooltip: 'Editar logo de la bodega',
                  onPressed: () {}, 
                  icon: Icon(
                    Icons.edit,
                    color: wine.logoBodega != null 
                      ? frontColor
                      : null
                  )
                ),
              ],
            ),
          ),
    
          const Spacer(),
          
          user == null // styles.headlineSmall
            ?
            Text('Ficha técnica global', style: styles)
            :
              source == 'latest' 
                ?
                Text('Valoración de la cata', style: styles)
                :
                Text('Valoración de mi cata', style: styles),
    
          const SizedBox(height: 5),             
        ],
      ),
    );
  }
}

class _AppBarBackgroundImage extends StatelessWidget {
  const _AppBarBackgroundImage({
    required this.wine, 
    required this.backgroundColor
  });

  final Wines wine;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    if (wine.logoBodega != null) {
      return Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CachedNetworkImage(
          imageUrl: wine.logoBodega!,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.medium,
          placeholder: (context, url) {
            return Center(
              child: CircularProgressIndicator(
                color: colors.primary,
              ),
            );
          },
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: AutoSizeText(
          wine.bodega,
          textAlign: TextAlign.center,
          maxLines: wine.bodega.contains(' ') ? 2 : 1,
          style: const TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold, 
            height: 1
          ),
        )
      ),
    );
  }
}

class _WinePoster extends StatelessWidget {

  // TODO refactorizar mas limpio

  final Wines wine;
  final WineTaste? wineTaste;
  final String? user;
  final String source;

  const _WinePoster({
    required this.wine, 
    this.wineTaste,
    this.user, 
    required this.source
  });

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    Widget detectEmptyText(String dato) {
      if (dato != "" ) {
        return Text(dato, style: const TextStyle(fontSize: 14));
      }
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top:20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadWineImage(
            wine: wine, 
            scale: 5/6, 
            imageWidth: size.width * 0.4 - 30,
            source: source,
          ),

          const SizedBox(
            width: 20,
          ),

          SizedBox(
            width: size.width * 0.6 - 30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wine.nombre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 3, overflow: TextOverflow.ellipsis),
                detectEmptyText(wine.tipo),
                detectEmptyText(wine.bodega),
                detectEmptyText(wine.region),
                detectEmptyText(wine.variedades),
                wine.graduacion != '' ? Text('${wine.graduacion}%', style: const TextStyle(fontSize: 14)) : const SizedBox(),
                detectEmptyText(wine.descripcion),

                user == null // TODO refactorizar
                  ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wine.puntuacionFinal != -1 
                          ? '${wine.puntuacionFinal} puntos Tacher'
                          : '\nSin valoraciones',
                          style: const TextStyle(fontSize: 14)
                        ),

                      if (wine.puntuacionFinal != -1) Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionVista)
                        ],
                      ),
                      detectEmptyText(wine.notaVista),
                      
                      if (wine.puntuacionFinal != -1) Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionNariz)
                        ],
                      ),
                      detectEmptyText(wine.notaNariz),

                      if (wine.puntuacionFinal != -1) Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionBoca)
                        ],
                      ),
                      detectEmptyText(wine.notaBoca),
                    ]
                  )
                  :
                  user == 'latest'
                  ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${wineTaste!.puntosFinal} puntos Tacher', style: const TextStyle(fontSize: 14)),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wineTaste!.puntosVista),
                        ],
                      ),
                      detectEmptyText(wineTaste!.notasVista!),
                      
                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wineTaste!.puntosNariz),
                        ],
                      ),
                      detectEmptyText(wineTaste!.notasNariz!),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wineTaste!.puntosBoca),
                        ],
                      ),
                      detectEmptyText(wineTaste!.notasBoca!),

                      detectEmptyText(wineTaste!.comentarios!),
                    ]
                  )
                  :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${wine.puntuaciones![wine.usuarios!.indexOf(user!)]} puntos Tacher', style: const TextStyle(fontSize: 14)),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesVista![wine.usuarios!.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasVista![wine.usuarios!.indexOf(user!)]),
                      
                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz![wine.usuarios!.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasNariz![wine.usuarios!.indexOf(user!)]),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca![wine.usuarios!.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasBoca![wine.usuarios!.indexOf(user!)]),

                      Text(wine.comentarios![wine.usuarios!.indexOf(user!)], style: const TextStyle(fontSize: 14)),
                    ]
                  )
              ],
            ),
          ),
        ],
      )
    );
  }
}

