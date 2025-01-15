// Photo by <a href="/photographer/muddy-31912">muddy</a> on <a href="/">Freeimages.com</a>

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:image_pixels/image_pixels.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/services/services.dart';
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const BottomImageBackground(image: 'assets/details-background.jpg', opacity: 0.4),
      
            CustomScrollView(
              slivers: [
                _ContainerSliverAppBar(wine: wine),
      
                SliverList(
                  delegate: SliverChildListDelegate([
            
                    _WinePoster(wine: wine, wineTaste: wineTaste, user: email, source: source)
                  
                  ])
                )
              ],
            ),
          ],
        )
      ),
    );
  }
}

class _ContainerSliverAppBar extends StatelessWidget {
  const _ContainerSliverAppBar({
    required this.wine, 
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);

    return winesService.refreshLogo 
      ? _CustomLogoImage(wine: wine)
      : FutureBuilder(
        future: winesService.isValidImage(wine.logoBodega), 
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return _LoadingLogoImage(
              wine: wine, 
            );
          }
          if (snapshot.data!) {
            return _CustomLogoImage(
              wine: wine,
            );
          }
          return _ErrorLogoImage(
            wine: wine, 
          );
        },
      );
  }
}

class _LoadingLogoImage extends StatelessWidget {
  const _LoadingLogoImage({
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return _CustomSliverAppBar(
      wine: wine, 
      child: Center(
        child: CircularProgressIndicator(
          color: colors.primary,
        ),
      ),
    );
  }
}

class _CustomLogoImage extends StatelessWidget {
  const _CustomLogoImage({
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return ImagePixels(
      imageProvider: NetworkImage(wine.logoBodega!), 
      builder: (context, img) {
    
        final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
        final Color backgroundColor = img.pixelColorAtAlignment!(Alignment.topLeft);
        Color frontColor;
        SystemUiOverlayStyle? statusBarMode;
    
        if (backgroundColor.opacity == 0.0) {
          statusBarMode = themeColor.isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
          frontColor = colors.inverseSurface;           
        }
        else if (backgroundColor.computeLuminance() > 0.179) {
          themeColor.isDarkMode ? frontColor = colors.surface : frontColor = colors.inverseSurface;
          statusBarMode = SystemUiOverlayStyle.dark;
        }
        else {
          themeColor.isDarkMode ? frontColor = colors.inverseSurface : frontColor = colors.surface;
          statusBarMode = SystemUiOverlayStyle.light;
        }
    
        return _CustomSliverAppBar(
          wine: wine, 
          statusBarMode: statusBarMode,
          frontColor: frontColor,
          child: _CustomBackgroundImage(wine: wine, backgroundColor: backgroundColor),
        );
      },
    );
  }
}

class _ErrorLogoImage extends StatelessWidget {
  const _ErrorLogoImage({
    required this.wine,
  });

  final Wines wine;

  @override
  Widget build(BuildContext context) {
    return _CustomSliverAppBar(
      wine: wine, 
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

class _CustomSliverAppBar extends StatelessWidget {
  const _CustomSliverAppBar({
    required this.wine,
    required this.child, 
    this.statusBarMode,
    this.frontColor,
  });

  final Wines wine;
  final Widget child;
  final SystemUiOverlayStyle? statusBarMode;
  final Color? frontColor;

  @override
  Widget build(BuildContext context) {

    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;

    return SliverAppBar(
      toolbarHeight: 150 + statusBarHeight,
      systemOverlayStyle: statusBarMode,
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.all(0),
        centerTitle: true,
        title: _SliverAppBarButtons(wine: wine, frontColor: frontColor),
        background: child,
      ),
    );
  }
}

class _SliverAppBarButtons extends StatelessWidget {
  const _SliverAppBarButtons({
    required this.wine,
    this.frontColor,
  });

  final Wines wine;
  final Color? frontColor;

  void showCustomDialog(BuildContext context, {required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;

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
                    color: frontColor
                    ),
                  onPressed: () {
                    Navigator.pop(context);
                    winesService.refreshLogo = false;
                  }
                ),
          
                const Spacer(),
          
                IconButton(
                  tooltip: 'Editar logo de la bodega',
                  onPressed: () => showCustomDialog(context, child: UrlDialog(wine: wine)), 
                  icon: Icon(
                    Icons.edit,
                    color: frontColor
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),      
        ],
      ),
    );
  }
}

class _CustomBackgroundImage extends StatelessWidget {
  const _CustomBackgroundImage({
    required this.wine, 
    this.backgroundColor
  });

  final Wines wine;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;

    return CachedNetworkImage(
      imageUrl: wine.logoBodega!,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      placeholder: (context, url) {
        return Center(
          child: CircularProgressIndicator(
            color: colors.primary,
          ),
        );
      },
      // TODO manejar el error de imagen sin que brinque despues en el Hero, esta manejado desde peticion http en wines service
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

    final styles = Theme.of(context).textTheme.titleLarge!.copyWith(
      fontWeight: FontWeight.bold,
    );

    Widget detectEmptyText(String dato) {
      if (dato != "" ) {
        return Text(dato, style: const TextStyle(fontSize: 14));
      }
      return const SizedBox();
    }

    String detailsLabel() { // TODO Refactor with enum
      if (source.startsWith('latest')){
        return 'Valoración de la cata';
      }
      if (source.startsWith('email')) {
        return 'Valoración de mi cata';
      }
      return 'Ficha técnica global';
    }

    return Container(
      margin: const EdgeInsets.only(top:15, left: 20, right: 20),
      child: Column(
        children: [
          Text(detailsLabel(), style: styles),

          const SizedBox(height: 20),

          Row(
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
                              ? '${wine.puntuacionFinal} puntos'
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
                          Text('${wineTaste!.puntosFinal} puntos', style: const TextStyle(fontSize: 14)),
          
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
                          Text('${wine.puntuaciones![wine.usuarios!.indexOf(user!)]} puntos', style: const TextStyle(fontSize: 14)),
          
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
          ),
        ],
      )
    );
  }
}

class UrlDialog extends StatefulWidget {
  const UrlDialog({super.key, required this.wine});

  final Wines wine;

  @override
  State<UrlDialog> createState() => _UrlDialogState();
}

class _UrlDialogState extends State<UrlDialog> {

  bool isCheckingImage = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context);
    final size = MediaQuery.of(context).size;
    final styles = Theme.of(context).textTheme;
    String? logoImageUrl;

    return PopScope(
      canPop: false,
      child: CustomAlertDialog(
        title: 'Introduce url de la imagen',
        saveText: isCheckingImage ? 'Enviando' : 'Enviar',
        cancelText: 'Cancelar',
        content: SizedBox(
          width: size.width * 0.8,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextField(
              style: styles.bodyLarge,
              maxLines: 1,         
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(16, 16, 12, 10),               
                labelText: 'Url',
                floatingLabelStyle: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1),
                  borderRadius: BorderRadius.circular(12)
                ),
              ),
              onChanged: (value) => logoImageUrl = value,
            ),
          ),
        ),
        onPressedSave: () async {
          if (logoImageUrl != null) {
            isCheckingImage = true;
            setState(() {});
            final urlChecked = await winesService.isValidImage(logoImageUrl);
            isCheckingImage = false;
            setState(() {});
            if (!urlChecked && context.mounted) {
              NotificationsService.showFlushBar('URL DE IMAGEN INCORRECTA', context);
              return;
            }
            winesService.refreshLogo = true;
            widget.wine.logoBodega = logoImageUrl;
            winesService.updateWine(widget.wine);
            if (context.mounted) Navigator.pop(context);
          }
          if (logoImageUrl == '') {
            if (context.mounted) {
              NotificationsService.showFlushBar('URL DE IMAGEN VACIO', context);
              return;
            }            
          }
        }, 
        onPressedCancel: () => Navigator.pop(context),
      ),
    );
  }
}

