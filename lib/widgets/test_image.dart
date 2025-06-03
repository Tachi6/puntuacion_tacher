import 'package:flutter/material.dart';

class TestImage extends StatelessWidget {
  const TestImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage('assets/bottle_noimage.jpg'),
      fit: BoxFit.none,
    );
  }
}