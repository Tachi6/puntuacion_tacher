import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

class RatingBox extends StatelessWidget {

  final String textoTitulo;
  final String textoDescripcion;
  final double? initialRating;
  final double? minRating;
  final int? itemCount;
  final String? name;


  const RatingBox({
    super.key, 
    required this.textoTitulo, 
    required this.textoDescripcion,
    this.initialRating, 
    this.minRating, 
    this.itemCount, 
    this.name
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Material(
        elevation: 1,
        shadowColor: colors.shadow,
        borderRadius: BorderRadius.circular(16),
        color: themeColor.isDarkMode 
          ? colors.surfaceContainerHighest
          : colors.surfaceContainerHighest.withOpacity(0.6),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(textoTitulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
              const SizedBox(height:5),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(textoDescripcion, style: const TextStyle(fontSize: 12), textAlign: TextAlign.justify)),
              const SizedBox(height: 5),
        
              if (name != null) Transform.translate(
                offset: const Offset(-2, 0),
                child: _RatingCustomWidget(
                  initialRating: initialRating!, 
                  minRating: minRating!, 
                  itemCount: itemCount!, 
                  name: name!
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingCustomWidget extends StatelessWidget{
  
  final double initialRating;
  final double minRating;
  final int itemCount;
  final String name;

  const _RatingCustomWidget({
    required this.initialRating, 
    required this.minRating, 
    required this.itemCount, 
    required this.name
  });

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final double itemSize = ((size.width * 0.75) / 11).truncateToDouble();

    return RatingBar.builder(
      initialRating: initialRating,
      minRating: minRating,
      itemCount: itemCount,
      direction: Axis.horizontal,
      allowHalfRating: false,
      glow: false,
      itemSize: itemSize,
      itemPadding: const EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 0), 
      itemBuilder: (context, index) {
        if (name == 'puntos') {
          return SvgPicture.asset(
            'assets/wine_bar_$index.svg',
            colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
          );
        } 
        else {
          return SvgPicture.asset(
            'assets/wine_bar_full.svg',
            colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
          );
        }
      },
      onRatingUpdate: (value) {
        if (name == 'vista') {
          wineForm.editRatingVista(value);
        }
        if (name == 'nariz') {
          wineForm.editRatingNariz(value);
        }
        if (name == 'boca') {
          wineForm.editRatingBoca(value);
        }
        if (name == 'puntos') {
          wineForm.editRatingPuntos(value);
        }
      },
    );
  }
}