import 'package:flutter/material.dart';

class ThemeTastePage extends StatelessWidget {
  const ThemeTastePage({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10),
              width: size.width / 2.5,
              child: Column(
                children: [
                  const Text('Ut ut eiusmod commodo eiusmod laboris ea aliquip quis cupidatat nisi fugiat.'),

                  const SizedBox(height: 10),
              
                  SizedBox(
                    width: size.width - 40,
                    child: DropdownButton(
                      isExpanded: true,
                      
                      alignment: AlignmentDirectional.center,
                      menuWidth: (size.width / 2.5),

                      items: [
                        DropdownMenuItem(
                          value: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text('1')),
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}