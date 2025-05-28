
import 'package:flutter/material.dart';

class CreateMultipleWidget extends StatelessWidget {

  const CreateMultipleWidget({super.key});

  @override
  Widget build(BuildContext context) {
   
    return const SizedBox(
      height: 85,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Crea una cata múltiple', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

          SizedBox(height: 18),

          Text('Organiza tu propia cata múltiple personalizada', style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}