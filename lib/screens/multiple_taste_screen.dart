import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/mappers/winetaste_to_wines.dart';
import 'package:puntuacion_tacher/models/models.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MultipleTasteScreen extends StatefulWidget {
  const MultipleTasteScreen({super.key});

  @override
  State<MultipleTasteScreen> createState() => _MultipleTasteScreenState();
}

  // Cdigo que me puiede ser util
  // final List<String> winesTempTaste = List.from(multipleService.multipleTasteList[0].winesIndexOfTaste.keys.toList());

  // final List<Wines> printWines = winesService.wineToTaste(winesTempTaste);


class _MultipleTasteScreenState extends State<MultipleTasteScreen> {

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final authService = Provider.of<AuthService>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final winesService = Provider.of<WinesService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    void onpressed() async {

      // multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);

      if (multipleService.isMultipleTasted) {
        Navigator.pop(context);
        return;
      }
      if (!multipleTaste.isValidRating()) {
        NotificationsService.showSnackbar('RELLENA TODOS LOS CAMPOS', context);
        return;
      }
      // Cargo la cata multiples para tener los ultimos cambios
      final Multiple multipleUpdated = await multipleService.loadMultipleTaste(multipleTaste.multipleTaste.name);
      // Actualizo el multiple local
      multipleTaste.updateMultipleTaste(multipleUpdated);
      // Calculo puntuaciones de Vista, Nariz y Boca
      multipleTaste.calculateValoration();
      // Calculo puntuaciones medias
      multipleTaste.calculateAverageRatings();
      // Moverme a la ultima página // TODO ver que lo hace fluido...
      final int newPageIndex = multipleTaste.winesMultipleTaste.length + 1;
      if (screenProvider.multipleScreen != newPageIndex) {
        screenProvider.multipleScreen = newPageIndex;
        pageController.animateToPage(
          newPageIndex, 
          duration: const Duration(milliseconds: 250), 
          curve: Curves.easeInOut,           
        );
      }
      // Desactivar que vuelvan a catar
      await Future.delayed(
        const Duration(milliseconds: 350),
        () => multipleService.isMultipleTasted = true,
      );
      // Subo WineTaste del usuario
      await multipleService.createUserMultipleTaste(multipleName: multipleTaste.multipleTaste.name, userMultipleTaste: multipleTaste.userMultipleTaste);
      // Subo AverageRatings
      await multipleService.updateAverageRatings(multipleName: multipleTaste.multipleTaste.name, averageRatings: multipleTaste.multipleTaste.averageRatings);
      // Mapear todos los vinos y subir los cambios a firebase
      for (var wineTaste in multipleTaste.userMultipleTaste) {
        final wineId = int.parse(wineTaste.id);
        await winesService.updateWine(WinesMapper.wineTasteToWines(wineTaste, winesService.winesByIndex[wineId]));
      }
    }

    List<Widget> tastePages() {
      List<Widget> tastePages = [];

      // multipleService.checkIsMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userDisplayName);

      for (var wine in multipleTaste.winesMultipleTaste) {

        final int index = multipleTaste.winesMultipleTaste.indexOf(wine);

        final Widget tastePage = _MultipleTacherScreen(wine: wine, index: index, pageController: pageController, onPressed: onpressed);
        
        (multipleTaste.multipleTaste.dateLimit == null)
          ? tastePages = [...tastePages, tastePage]
          : CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!).isAfter(DateTime.now())
            ? tastePages = [...tastePages, tastePage]
            : null;        
      }
      return [
        _MultipleFirstPage(pagecontroller: pageController, onPressed: onpressed),
        
        // TODO HABILITAR DE NUEVO DESPUES DE PRUEBAS
        if (!multipleService.isMultipleTasted) ...tastePages,
        // ...tastePages,
        
        _MultipleLastPage(pageController: pageController, onPressed: onpressed),
      ];
    }

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
        child: PageView(
          physics: const ClampingScrollPhysics(),
          controller: pageController,
          children: tastePages(),
          onPageChanged: (value) => screenProvider.multipleScreen = value,
        ),
      ),
    );
  }
}

class _MultipleLastPage extends StatelessWidget {
  const _MultipleLastPage({required this.pageController, required this.onPressed});

  final PageController pageController;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final authService = Provider.of<AuthService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);
    final size = MediaQuery.of(context).size;
    final Formulas formulas = Formulas();
    final newWidth = size.width - 20;
    final wineTasteList = multipleTaste.userView == '' 
      ? multipleTaste.userMultipleTaste 
      : multipleTaste.anotherUserMultipleTaste(multipleTaste.userView);

    return Scaffold(
      appBar: const _CustomMultipleAppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            const Text('Resultados de cata', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: newWidth * 0.29,
                  alignment: Alignment.center,
                  child: const Text('Vista', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                Container(
                  width: newWidth * 0.29,
                  alignment: Alignment.center,                         
                  child: const Text('Nariz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                Container(
                  width: newWidth * 0.29,
                  alignment: Alignment.center,
                  child: const Text('Boca', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),

                Container(
                  width: newWidth * 0.13,
                  alignment: Alignment.center,
                  child: const Text('Final', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),


            Expanded(
              child: ListView.builder(
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [   
                      if (index == 0) const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 0, bottom: 8, left: 10, right: 10),
                        alignment: Alignment.center,
                        child: Text(
                          multipleTaste.userMultipleTaste[index].nombre,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
              
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: newWidth * 0.29,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              // ratingCategory: formulas.puntosVistaFunction(multipleTaste.userMultipleTaste[index].ratingVista),
                              ratingCategory: formulas.puntosVistaFunction(wineTasteList[index].ratingVista),
                              itemSize: 16,
                            ),
                          ),

                          Container(
                            width: newWidth * 0.29,
                            alignment: Alignment.center,                         
                            child: RatingDetailsCategory(
                              ratingCategory: formulas.puntosVistaFunction(wineTasteList[index].ratingNariz),
                              itemSize: 16,
                            ),
                          ),

                          Container(
                            width: newWidth * 0.29,
                            alignment: Alignment.center,
                            child: RatingDetailsCategory(
                              ratingCategory: formulas.puntosVistaFunction(wineTasteList[index].ratingBoca),
                              itemSize: 16,
                            ),
                          ),

                          Container(
                            width: newWidth * 0.13,
                            alignment: Alignment.center,
                            child: Text(
                              wineTasteList[index].ratingPuntos.toInt().toString(), 
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(),
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  ...List<Widget>.generate(
                    multipleTaste.otherUsersTaste().length, 
                    (index) {
                      return FilterChip(
                        showCheckmark: false,
                        label: Text(multipleTaste.otherUsersTaste()[index]),
                        selected: multipleTaste.userView == multipleTaste.otherUsersTaste()[index],
                        onSelected: (value) => multipleTaste.userView = multipleTaste.otherUsersTaste()[index],
                      );
                    },
                  )
                ],
              ),
            ),

            const Spacer(),

            const SizedBox(height: 58),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Table(
            //     // border: TableBorder.all(width: 2),
            //     columnWidths: const {
            //       0: FlexColumnWidth(),
            //       1: FixedColumnWidth(75),
            //       2: FixedColumnWidth(75),
            //       3: FixedColumnWidth(75),
            //       4: FixedColumnWidth(35),
            //     },
            //     children: [
            //       const TableRow(
            //         children: [
            //           TableCell(
            //             child: Text('Vino', textAlign: TextAlign.center,)
            //           ),
            //           TableCell(
            //             child: Text('Vista', textAlign: TextAlign.center,)
            //           ),
            //           TableCell(
            //             child: Text('Nariz', textAlign: TextAlign.center,)
            //           ),
            //           TableCell(
            //             child: Text('Boca', textAlign: TextAlign.center,)
            //           ),
            //           TableCell(
            //             child: Text('Final', textAlign: TextAlign.center,)
            //           ),
            //         ]
            //       ),

            //       TableRow(
            //         children: [
            //           TableCell(
            //             child: Text('Vinooooooooooooooooooooooooooooooooooooooooooooooo', softWrap: false, textAlign: TextAlign.left, overflow: TextOverflow.visible, maxLines: 1, )
            //           ),
            //           TableCell(
            //             child: SizedBox()
            //           ),
            //           TableCell(
            //             child: SizedBox()
            //           ),
            //           TableCell(
            //             child: SizedBox()
            //           ),                      
            //           TableCell(
            //             child: SizedBox()
            //           ),
            //         ]
            //       ),

            //       ...List.generate(
            //         multipleTaste.winesMultipleTaste.length,
            //         (index) {
            //           return TableRow(
            //             children: [
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Text(multipleTaste.userMultipleTaste[index].nombre, textAlign: TextAlign.center,)
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: formulas.puntosVistaFunction(multipleTaste.userMultipleTaste[index].ratingVista))
            //                 ),
            //                 // child: Text(multipleTaste.winesTaste[index].ratingVista.toString(), textAlign: TextAlign.center,)
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: formulas.puntosNarizFunction(multipleTaste.userMultipleTaste[index].ratingNariz))
            //                 ),
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: formulas.puntosBocaFunction(multipleTaste.userMultipleTaste[index].ratingBoca)
            //                   ),
            //                 ),
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Text(multipleTaste.userMultipleTaste[index].ratingPuntos.toInt().toString(), textAlign: TextAlign.center),
            //               ),
            //             ]
            //           );
            //         },
            //       ),

            //       ...List.generate(
            //         multipleTaste.winesMultipleTaste.length,
            //         (index) {
            //           final String wineId = multipleTaste.userMultipleTaste[index].id;
            //           final AverageRatings averageRatings = multipleTaste.multipleTaste.averageRatings[wineId]!;
            //           return TableRow(
            //             children: [
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Text(multipleTaste.userMultipleTaste[index].nombre, textAlign: TextAlign.center,)
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: averageRatings.vista),
            //                 ),
            //                 // child: Text(multipleTaste.winesTaste[index].ratingVista.toString(), textAlign: TextAlign.center,)
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: averageRatings.nariz),
            //                 ),
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Center(
            //                   child: RatingDetailsCategory(ratingCategory: averageRatings.boca),
            //                 ),
            //               ),
            //               TableCell(
            //                 verticalAlignment: TableCellVerticalAlignment.middle,
            //                 child: Text(averageRatings.puntos.toString(), textAlign: TextAlign.center),
            //               ),
            //             ]
            //           );
            //         },
            //       ),

            //       // const TableRow(
            //       //   children: [
            //       //     TableCell(
            //       //       child: Text('Media', textAlign: TextAlign.center,)
            //       //     ),
            //       //     TableCell(
            //       //       child: Text('Vista', textAlign: TextAlign.center,)
            //       //     ),
            //       //     TableCell(
            //       //       child: Text('Nariz', textAlign: TextAlign.center,)
            //       //     ),
            //       //     TableCell(
            //       //       child: Text('Boca', textAlign: TextAlign.center,)
            //       //     ),
            //       //     TableCell(
            //       //       child: Text('Valoración', textAlign: TextAlign.center,)
            //       //     ),
            //       //   ]
            //       // ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(
        buttonText: multipleService.isMultipleTasted
          ? 'Salir'
          : 'Enviar Valoración',
        leading: SizedBox(
          height: 58,
          width: 58,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              int newPageIndex = screenProvider.multipleScreen - 1;
              screenProvider.multipleScreen = newPageIndex;
              pageController.animateToPage(
                newPageIndex, 
                duration: const Duration(milliseconds: 250), 
                curve: Curves.easeInOut,           
              );
            },
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 9,
                  child: Icon(Icons.arrow_back_ios_new_rounded)
                ),
            
                Positioned(
                  bottom: 7,
                  child: Text(
                    'Anterior', 
                    style: TextStyle(fontSize: 12)
                  ),
                ),
              ],
            ),
          ),
        ), 
        onPressed: onPressed,
      ),
    );
  }
}

class _MultipleFirstPage extends StatelessWidget {
  const _MultipleFirstPage({required this.pagecontroller, required this.onPressed});

  final PageController pagecontroller;
  final void Function()? onPressed;
  

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final authService = Provider.of<AuthService>(context);

    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);
    final styles = Theme.of(context).textTheme;

    String dateLimit() {
      if (multipleTaste.multipleTaste.dateLimit == null) {
        return 'Sin limite';
      }
      else {
        final DateTime dateLimit = CustomDatetime().toDateTime(multipleTaste.multipleTaste.dateLimit!);
        return '${dateLimit.day}-${dateLimit.month}-${dateLimit.year}';
      }          
    }

    return Scaffold(
      appBar: const _CustomMultipleAppBar(),
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
              dateLimit(),
            ),

            Text('Vinos a catar', textAlign: TextAlign.center, style: styles.titleMedium!.copyWith(fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: multipleTaste.winesMultipleTaste.length,
                itemBuilder: (context, index) {
                  return Text(multipleTaste.winesMultipleTaste[index].nombre);
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(
        buttonText: multipleService.isMultipleTasted
          ? 'Salir'
          : 'Enviar Valoración',
        trailing: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            int newPageIndex = screenProvider.multipleScreen + 1;
            screenProvider.multipleScreen = newPageIndex;
            pagecontroller.animateToPage(
              newPageIndex, 
              duration: const Duration(milliseconds: 250), 
              curve: Curves.easeInOut,           
            );
          },
          child: const SizedBox(
            height: 58,
            width: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 9,
                  child: Icon(Icons.arrow_forward_ios_rounded)
                ),
          
                Positioned(
                  bottom: 7,
                  child: Text(
                    'Siguiente', 
                    style: TextStyle(fontSize: 12)
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class _MultipleTacherScreen extends StatelessWidget {
  const _MultipleTacherScreen({
    required this.wine, 
    required this.index, 
    required this.pageController, 
    required this.onPressed,
  });

  final Wines wine;
  final int index;
  final PageController pageController;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final multipleService = Provider.of<MultipleService>(context);
    final authService = Provider.of<AuthService>(context);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    return TacherScreen(
      appBarTitle: wine.nombre,
      onPressedBackButon: () {
        Navigator.pop(context);
        multipleTaste.resetSettings();
      },
      bottomSheet: CustomBottomSheet(
        buttonText: multipleService.isMultipleTasted
          ? 'Salir'
          : 'Enviar Valoración',
        leading: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final int newPageIndex = screenProvider.multipleScreen - 1;
            screenProvider.multipleScreen = newPageIndex;
            pageController.animateToPage(
              newPageIndex, 
              duration: const Duration(milliseconds: 250), 
              curve: Curves.easeInOut,           
            );
          },
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
        trailing: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final int newPageIndex = screenProvider.multipleScreen + 1;
            screenProvider.multipleScreen = newPageIndex;
            pageController.animateToPage(
              newPageIndex, 
              duration: const Duration(milliseconds: 250), 
              curve: Curves.easeInOut,           
            );
          },
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
        onPressed: onPressed,
      ),
    );
  }
}

class _CustomMultipleAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomMultipleAppBar();

  @override
  Widget build(BuildContext context) {

    final multipleTaste = Provider.of<MultipleTasteProvider>(context);
    final size = MediaQuery.of(context).size;
    
    return AppBar(
      toolbarHeight: 48,
      automaticallyImplyLeading: false, 
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            multipleTaste.resetSettings();            
          },
          icon: const Icon(Icons.arrow_back_rounded)
        ),
          
        Container(
          height: 48,
          alignment: Alignment.center,
          width: size.width - 96,
          child: Text(
            multipleTaste.multipleTaste.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 20, height: 1.1)
          ),
        ),
    
        const SizedBox(width: 48),
      ]
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(48);
}