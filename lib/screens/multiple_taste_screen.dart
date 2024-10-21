import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/models/models.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleTasteScreen extends StatelessWidget {
  const MultipleTasteScreen({super.key});

  // Cdigo que me puiede ser util
  // final List<String> winesTempTaste = List.from(multipleService.multipleTasteList[0].winesIndexOfTaste.keys.toList());

  // final List<Wines> printWines = winesService.wineToTaste(winesTempTaste);



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MultipleTastePages()
    );
  }
}

class MultipleTastePages extends StatelessWidget {
  const MultipleTastePages({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final multipleService = Provider.of<MultipleService>(context);

    List<Widget> multiplePages() {
      List<Widget> tempMultiplePages = [];

      for (var wine in multipleTaste.winesMultipleTaste) {

        final int index = multipleTaste.winesMultipleTaste.indexOf(wine);

        final Widget newPage = TacherScreen(
          appBarTitle: wine.nombre,
          leading: SizedBox(
            height: 58,
            width: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 9,
                  child: Icon(Icons.arrow_back_ios_new_rounded)
                ),

                Positioned(
                  bottom: 7,
                  child: Text(
                    (index == 0) ? 'Inicio' : 'Anterior', 
                    style: const TextStyle(fontSize: 12)
                  ),
                ),
              ],
            ),
          ),

          trailing: SizedBox(
            height: 58,
            width: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned(
                  top: 9,
                  child: Icon(Icons.arrow_forward_ios_rounded)
                ),

                Positioned(
                  bottom: 7,
                  child: Text(
                    (index == (multipleTaste.winesMultipleTaste.length - 1)) ? 'Resumen' : 'Siguiente', 
                    style: const TextStyle(fontSize: 12)
                  ),
                ),
              ],
            ),
          ),
          multiplePage: index,
        );
        if (CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit).isAfter(DateTime.now())) {
          tempMultiplePages = [...tempMultiplePages, newPage];
        }
      }
     
      return tempMultiplePages;
    }

    return Container(
      color: Colors.amber,
      alignment: Alignment.center,
      width: size.width,
      height: size.height,
      child: PageView(
        children: [
          // INFO DE CATA
          const _MultipleFirstPage(),
          // PAGINAS DE CATA
          if (!multipleService.isMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userEmail)) ...multiplePages(),
          // RESUMEN DE CATA
          const _MultipleLastPage(),
        ],
      ),
    );
  }
}

class _MultipleLastPage extends StatelessWidget {
  const _MultipleLastPage();

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Text(multipleTaste.multipleTaste.name),
            
            if (multipleTaste.multipleTaste.description != null) Text(multipleTaste.multipleTaste.description!),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: SizedBox()
                      ),
                      TableCell(
                        child: Text('Vista', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Nariz', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Boca', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Valoración', textAlign: TextAlign.center,)
                      ),
                    ]
                  ),

                  ...List.generate(
                    multipleTaste.winesMultipleTaste.length,
                    (index) {
                      return const TableRow(
                        children: [
                          TableCell(
                            child: Text('Vino', textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            child: Text('Vista', textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            child: Text('Nariz', textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            child: Text('Boca', textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            child: Text('Valoración', textAlign: TextAlign.center,)
                          ),
                        ]
                      );
                    },
                  ),

                  const TableRow(
                    children: [
                      TableCell(
                        child: Text('Media', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Vista', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Nariz', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Boca', textAlign: TextAlign.center,)
                      ),
                      TableCell(
                        child: Text('Valoración', textAlign: TextAlign.center,)
                      ),
                    ]
                  ),
                ],
              ),
            )

            


          ],
        ),
      ),
    );
  }
}

class _MultipleFirstPage extends StatelessWidget {
  const _MultipleFirstPage();

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final styles = Theme.of(context).textTheme;
    final dateLimit = CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Text(multipleTaste.multipleTaste.name, textAlign: TextAlign.center, style: styles.titleLarge!.copyWith(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),
            
            if (multipleTaste.multipleTaste.description != null) Text(multipleTaste.multipleTaste.description!),

            const SizedBox(height: 10),

            Text('Fecha límite para realizar la cata', textAlign: TextAlign.center, style: styles.titleMedium),

            Text(
              '${dateLimit.day}-${dateLimit.month}-${dateLimit.year}'
            ),

            Text('Vinos a catar', textAlign: TextAlign.center, style: styles.titleMedium!.copyWith(fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
                  print(multipleTaste.winesMultipleTaste[index].nombre);
                  return Text(multipleTaste.winesMultipleTaste[index].nombre);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}