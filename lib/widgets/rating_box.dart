import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

class RatingBox extends StatelessWidget {

  final String titleText;
  final String bodyText;
  final AutoSizeGroup titleGroup;
  final AutoSizeGroup bodyGroup;
  final double? initialRating;
  final double? minRating;
  final int? itemCount;
  final String? name;
  final bool ignoreGestures;

  const RatingBox({
    super.key, 
    required this.titleText, 
    required this.bodyText,
    required this.titleGroup,
    required this.bodyGroup,
    this.initialRating, 
    this.minRating, 
    this.itemCount, 
    this.name,
    required this.ignoreGestures,
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
          : colors.surfaceContainerHighest.withAlpha((255 *0.6).toInt()),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AutoSizeText(
                  titleText,
                  group: titleGroup,
                  minFontSize: 15,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 2),
        
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AutoSizeText(
                  bodyText,
                  minFontSize: 11,
                  group: bodyGroup,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 2),
        
              if (name != null) _RatingCustomWidget(
                initialRating: initialRating!, 
                minRating: minRating!, 
                itemCount: itemCount!, 
                name: name!,
                ignoreGestures: ignoreGestures,
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
  final bool ignoreGestures;

  const _RatingCustomWidget({
    required this.initialRating, 
    required this.minRating, 
    required this.itemCount, 
    required this.name,
    required this.ignoreGestures,
  });

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final double itemSize = ((size.width * 0.90) / 11).truncateToDouble();

    return RatingBar.builder(
      ignoreGestures: ignoreGestures,
      updateOnDrag: true,
      wrapAlignment: WrapAlignment.center,
      initialRating: initialRating,
      minRating: minRating,
      itemCount: itemCount,
      direction: Axis.horizontal,
      allowHalfRating: false,
      glow: false,
      itemSize: itemSize,
      itemPadding: const EdgeInsets.only(top: 6, bottom: 6, left: 0, right: 0), 
      itemBuilder: (context, index) {
        if (name == 'puntos') {
          return Container(
            color: Colors.transparent,
            width: itemSize,
            height: itemSize,
            child: SvgPicture.asset(
              'assets/wine_bar_$index.svg',
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),
          );
        } 
        else {
          return Container(
            color: Colors.transparent,
            width: itemSize,
            height: itemSize,
            child: SvgPicture.asset(
              'assets/wine_bar_full.svg',
              fit: BoxFit.fitHeight,
              colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
            ),
          );
        }
      },
      onRatingUpdate: (value) {
        if (name == 'vista') wineForm.editRatingVista(value);
        if (name == 'nariz') wineForm.editRatingNariz(value);
        if (name == 'boca') wineForm.editRatingBoca(value);
        if (name == 'puntos') wineForm.editRatingPuntos(value);
      },
    );
  }
}