import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/screens/screens.dart';

class CardNews extends StatelessWidget {
  const CardNews({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ListTile(
            minVerticalPadding: 16,
            leading: Icon(Icons.newspaper,
                color: Color.fromARGB(255, 114, 47, 55), size: 40),
            title: Text('SECRETOS Y CLAVES DEL MARIDAJE'),
            subtitle: Text(
                'Durante mis años trabajando como sumiller siempre tuve algo muy claro: “el mejor maridaje es el que más disfrutas tú”. Esto, para mí, es indiscutible. Sin embargo, si tienes la gran suerte de ser un foodie que ama el vino, puedes divertirte descubriendo las infinitas conexiones que existen entre el vino y la comida.'),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                  child: const Text('Leer mas', style: TextStyle(color: Color.fromARGB(255, 114, 47, 55))),
                  onPressed: () {
                    final routeList = MaterialPageRoute(
                      builder: (context) => const NewsScreen()
                    );
                    Navigator.push(context, routeList);

                  },
                ),
              ]))
        ],
      )
    );
  }
}
