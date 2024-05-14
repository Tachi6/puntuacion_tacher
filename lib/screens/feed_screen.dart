import 'package:flutter/material.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Noticias', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: const [
              Center(child: Text('Trabajando en ello, pronto estará disponible'))
            ]));
  }
}
