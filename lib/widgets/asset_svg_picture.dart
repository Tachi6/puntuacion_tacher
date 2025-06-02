import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class AssetSvgPicture extends StatelessWidget {
  const AssetSvgPicture({
    super.key,
    required this.assetBytesRoute,
    this.height,
    this.color
  });

  final String assetBytesRoute;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture(
      AssetBytesLoader(assetBytesRoute),
      height: height,
      colorFilter: color == null ? null :  ColorFilter.mode(color!, BlendMode. srcIn),
    );
  }
}