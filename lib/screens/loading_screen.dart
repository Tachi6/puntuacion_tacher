import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
   
  const LoadingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
         child: CircularProgressIndicator(
          color: colors.primary,
         ),
      ),
    );
  }
}