import 'package:flutter/material.dart';

class ThemeTastePage extends StatelessWidget {
  const ThemeTastePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (context, index) {
        return Column(
          children: [
            const Text('Ut ut eiusmod commodo eiusmod laboris ea aliquip quis cupidatat nisi fugiat.'),

            DropdownButton(
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('1'),
                ),

                DropdownMenuItem(
                  value: 1,
                  child: Text('1'),
                ),

                DropdownMenuItem(
                  value: 1,
                  child: Text('1'),
                ),

                DropdownMenuItem(
                  value: 1,
                  child: Text('1'),
                ),
              ], 
              onChanged: (value) {},
            ),
          ],
        );
      },
    );
  }
}