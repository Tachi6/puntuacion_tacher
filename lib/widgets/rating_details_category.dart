import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

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

    return RatingBarIndicator(
      itemCount: 5,
      itemSize: itemSize,
      unratedColor: colors.onSurface,
      itemBuilder: (context, index) {
        if (index + 1 <= ratingCategory.truncate()) return const AssetSvgPicture(assetBytesRoute: 'assets/wine_bar_full.svg.vec');
        if (index + 1 == ratingCategory.round()) return const AssetSvgPicture(assetBytesRoute: 'assets/wine_bar_half.svg.vec');
        return const AssetSvgPicture(assetBytesRoute: 'assets/wine_bar_empty.svg.vec');
      },
    );
  }
}