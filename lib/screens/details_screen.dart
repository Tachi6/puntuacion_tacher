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

    const double chipListHeight = 65;

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
                    _WinePoster(wine: wine, wineTaste: wineTaste, source: source, chipListHeight: chipListHeight),
                  ])
                )
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: _OtherTasteChipList(wine: wine, wineTaste: wineTaste, chipListHeight: chipListHeight),
            ),
          ],
        ),
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

    final winesService = Provider.of<WineServices>(context);

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
    
        if (backgroundColor.a == 0.0) {
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

    final screenHeight = MediaQuery.of(context).size.height;

    return SliverAppBar(
      toolbarHeight: screenHeight * 0.2,
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

    final winesService = Provider.of<WineServices>(context);
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
  const _WinePoster({
    required this.wine, 
    this.wineTaste,
    required this.source,
    required this.chipListHeight,
  });

  final Wines wine;
  final WineTaste? wineTaste;
  final String source;
  final double chipListHeight;

  @override
  Widget build(BuildContext context) {
    
    final styles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Flex(
        direction: Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),

          _LabelLine(wineTaste: wineTaste, styles: styles),

          const SizedBox(height: 15),

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
                    _NameLine(wine: wine, styles: styles),

                    const SizedBox(height: 2),

                    _DefaultLine(text: wine.bodega, styles: styles),

                    _DefaultLine(text: wine.region, styles: styles),

                    _DefaultLine(text: wine.tipo, styles: styles),

                    _DefaultLine(text: wine.variedades, styles: styles),

                    _DefaultLine(text: '${wine.graduacion}% vol.', styles: styles),

                    _RatingColumn(wine: wine, wineTaste: wineTaste, styles: styles),

                    _PointsLine(wine: wine, wineTaste: wineTaste, styles: styles),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          if (wineTaste != null) _CustomLine(text: 'Comentarios: ${wineTaste!.comentarios}', styles: styles),
          
          if (wineTaste != null && wineTaste!.comentarios != '') const SizedBox(height: 15),
          
          if (wineTaste != null) _CustomLine(text: 'Cata Vista: ${wineTaste?.notasVista}', styles: styles),
          
          if (wineTaste != null) _CustomLine(text: 'Cata Nariz: ${wineTaste?.notasNariz}', styles: styles),
          
          if (wineTaste != null) _CustomLine(text: 'Cata Boca: ${wineTaste?.notasBoca}', styles: styles),

          SizedBox(height: chipListHeight + 15),
        ],
      )
    );
  }
}

class _LabelLine extends StatelessWidget {
  const _LabelLine({
    this.wineTaste,
    required this.styles,
  });

  final WineTaste? wineTaste;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      child: Text(
        wineTaste == null 
          ? 'Ficha técnica global'
          : 'Valoración de la cata', 
        style: styles.titleLarge!.copyWith(fontWeight: FontWeight.bold)
      ),
    );
  }
}

class _NameLine extends StatelessWidget {
  const _NameLine({
    required this.wine,
    required this.styles,
  });

  final Wines wine;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    String wineNameTwoLines() { // TODO entender esta funcion

      final text = wine.nombre;
      final TextStyle style = styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 17);

      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      
      if (textPainter.size.width > (width * 0.6 - 30)) {
        return wine.nombre;
      }
      else {
        return '${wine.vino}\n${wine.anada}';
      }
    }

    return Text(
      wineNameTwoLines(), 
      style: styles.bodyLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 17),
      maxLines: 2,
      overflow: TextOverflow.ellipsis
    );
  }
}

class _DefaultLine extends StatelessWidget {
  const _DefaultLine({
    required this.text,
    required this.styles,
  });

  final String text;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {

    if (text == '' || text == '% vol.') return const SizedBox();

    return Text(
      text, 
      style: styles.bodyMedium!.copyWith(fontSize: 15),
      maxLines: 2,
      overflow: TextOverflow.ellipsis
    );
  }
}

class _CustomLine extends StatelessWidget {
  const _CustomLine({
    required this.text,
    required this.styles,
  });

  final String text;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {

    if (text == 'Comentarios: ' || text == 'Cata Vista: ' || text == 'Cata Nariz: ' || text == 'Cata Boca: ') return const SizedBox();

    return Text(
      text, 
      style: styles.bodyMedium!.copyWith(fontSize: 15),
      // overflow: TextOverflow.ellipsis
    );
  }
}

class _PointsLine extends StatelessWidget {
  const _PointsLine({
    required this.wine, 
    this.wineTaste,
    required this.styles,
  });

  final Wines wine;
  final WineTaste? wineTaste;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {

    if (wine.puntuacionFinal == -1) {
      return Text(
        '\nSin valoraciones',
      style: styles.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
      );
    }
    
    int puntuacionFinal;

    wineTaste == null
      ? puntuacionFinal = wine.puntuacionFinal
      : puntuacionFinal = wineTaste!.puntosFinal;

    return  Row(
      children: [
        Text(
          puntuacionFinal.toString(),
          style: styles.bodyMedium!.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
        ),

        Text(
          ' puntos',
          style: styles.bodyMedium!.copyWith(fontSize: 15),
        ),
      ],
    );
  }
}

class _RatingColumn extends StatelessWidget {
  const _RatingColumn({
    required this.wine, 
    this.wineTaste,
    required this.styles,
  });

  final Wines wine;
  final WineTaste? wineTaste;
  final TextTheme styles;

  @override
  Widget build(BuildContext context) {

    if (wine.puntuacionFinal == -1) return const SizedBox();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 44, 
              child: Text(
                'Vista', 
                style: styles.bodyMedium!.copyWith(fontSize: 15)
              ),
            ),
        
            RatingDetailsCategory(
              ratingCategory: wineTaste == null
                ? wine.puntuacionVista
                : wineTaste!.puntosVista
            ),
          ],
        ),

        Row(
          children: [
            SizedBox(
              width: 44, 
              child: Text(
                'Nariz', 
                style: styles.bodyMedium!.copyWith(fontSize: 15)
              ),
            ),
        
            RatingDetailsCategory(
              ratingCategory: wineTaste == null
                ? wine.puntuacionNariz
                : wineTaste!.puntosNariz
            ),
          ],
        ),

        Row(
          children: [
            SizedBox(
              width: 44, 
              child: Text(
                'Boca', 
                style: styles.bodyMedium!.copyWith(fontSize: 15)
              ),
            ),
        
            RatingDetailsCategory(
              ratingCategory: wineTaste == null
                ? wine.puntuacionBoca
                : wineTaste!.puntosBoca
            ),
          ],
        ),
      ],
    );
  }
}

class _OtherTasteChipList extends StatelessWidget {
  const _OtherTasteChipList({
    required this.wine,
    this.wineTaste,
    required this.chipListHeight,
  });

  final Wines wine;
  final WineTaste? wineTaste;
  final double chipListHeight;

  @override
  Widget build(BuildContext context) {

    final chipStyle = Theme.of(context).textTheme.bodySmall;
    final winesService = Provider.of<WineServices>(context);
    final userService = Provider.of<UserServices>(context);
    final String? date = wineTaste?.fecha;
    final List<WineTaste> otherTaste = winesService.otherWineTaste(wine, date);
    
    if (otherTaste.length < 2) return const SizedBox();
    
    return Container(
      height: chipListHeight,
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: otherTaste.length,
        itemBuilder: (context, index) {

          final displayName = userService.obtainDisplayName(otherTaste[index].user);

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip.elevated(
              showCheckmark: false,
              label: SizedBox(
                height: 32,
                child: Column(
                  children: [
                    Text(displayName),
                
                    Text('${otherTaste[index].puntosFinal.toString()} puntos'),
                  ],
                ),
              ),
              labelStyle: chipStyle,
              // selected: multipleTaste.userView == multipleTaste.otherUsersTaste()[index],
              onSelected: (value) {
                // TODO hacer el cambio
              },
            ),
          );
        },
      ),
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

    final winesService = Provider.of<WineServices>(context);
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
              NotificationServices.showFlushBar('URL DE IMAGEN INCORRECTA', context);
              return;
            }
            winesService.refreshLogo = true;
            widget.wine.logoBodega = logoImageUrl;
            winesService.updateWine(widget.wine);
            if (context.mounted) Navigator.pop(context);
          }
          if (logoImageUrl == '') {
            if (context.mounted) {
              NotificationServices.showFlushBar('URL DE IMAGEN VACIO', context);
              return;
            }            
          }
        }, 
        onPressedCancel: () => Navigator.pop(context),
      ),
    );
  }
}

