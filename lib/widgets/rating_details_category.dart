import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RatingDetailsCategory extends StatelessWidget {

  final double ratingCategory;
  final double itemSize;

  const RatingDetailsCategory({
    required this.ratingCategory, 
    this.itemSize = 14, 
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final Widget full = SvgPicture.asset(
      'assets/wine_bar_full.svg',
      colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
    );

    final Widget half = SvgPicture.asset(
      'assets/wine_bar_half.svg',
      colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
    );

    final Widget empty = SvgPicture.asset(
      'assets/wine_bar_empty.svg',
      colorFilter: ColorFilter.mode(colors.onSurface, BlendMode.srcIn),
    );

    return RatingBar(
      itemSize: itemSize,
      ratingWidget: RatingWidget(
        full: full,// const Icon(customicon.FontAwesome5.wine_glass, color: Colors.black,), 
        half: half, // const Icon(customicon.FontAwesome5.wine_glass_alt, color: Colors.black,), 
        empty: empty, //const Icon(null, color: Colors.black,),
      ),
      onRatingUpdate: ( _ ) {},
      allowHalfRating: true,
      itemCount: 5,
      initialRating: ratingCategory,
      ignoreGestures: true,
      glow: false,
    );
  }
}