import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
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
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    void onpressed() async {
      if (multipleTaste.isValidRating()) {
        multipleTaste.calculateValoration();
        multipleService.createUserMultipleTaste(multipleName: multipleTaste.multipleTaste.name, userMultipleTaste: multipleTaste.userMultipleTaste);
        await multipleService.loadMultiple();
        multipleTaste.updateMultipleTaste(multipleService.multipleTasteList.firstWhere((element) {
          return element.name == multipleTaste.multipleTaste.name;
        },));
        multipleTaste.calculateAverageRatings();
        multipleService.updateAverageRatings(multipleName: multipleTaste.multipleTaste.name, averageRatings: multipleTaste.multipleTaste.averageRatings);
      }
    }

    List<Widget> tastePages() {
      List<Widget> tastePages = [];

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
        // if (!multipleService.isMultipleTasted(multipleName: multipleTaste.multipleTaste.name, user: authService.userEmail)) ...tastePages,
        ...tastePages,
        
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
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);
    final Formulas formulas = Formulas();

    return Scaffold(
      appBar: const _CustomMultipleAppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Text(multipleTaste.multipleTaste.name),
            
            if (multipleTaste.multipleTaste.description != null) Text(multipleTaste.multipleTaste.description!),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                // border: TableBorder.all(width: 2),
                columnWidths: const {
                  0: FlexColumnWidth(),
                  1: FixedColumnWidth(75),
                  2: FixedColumnWidth(75),
                  3: FixedColumnWidth(75),
                  4: FixedColumnWidth(35),
                },
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
                        child: Text('Final', textAlign: TextAlign.center,)
                      ),
                    ]
                  ),

                  ...List.generate(
                    multipleTaste.winesMultipleTaste.length,
                    (index) {
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(multipleTaste.userMultipleTaste[index].nombre, textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: formulas.puntosVistaFunction(multipleTaste.userMultipleTaste[index].ratingVista))
                            ),
                            // child: Text(multipleTaste.winesTaste[index].ratingVista.toString(), textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: formulas.puntosNarizFunction(multipleTaste.userMultipleTaste[index].ratingNariz))
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: formulas.puntosBocaFunction(multipleTaste.userMultipleTaste[index].ratingBoca)
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(multipleTaste.userMultipleTaste[index].ratingPuntos.toInt().toString(), textAlign: TextAlign.center),
                          ),
                        ]
                      );
                    },
                  ),

                  ...List.generate(
                    multipleTaste.winesMultipleTaste.length,
                    (index) {
                      final String wineId = multipleTaste.userMultipleTaste[index].id;
                      final AverageRatings averageRatings = multipleTaste.multipleTaste.averageRatings[wineId]!;
                      return TableRow(
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(multipleTaste.userMultipleTaste[index].nombre, textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: averageRatings.vista),
                            ),
                            // child: Text(multipleTaste.winesTaste[index].ratingVista.toString(), textAlign: TextAlign.center,)
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: averageRatings.nariz),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Center(
                              child: RatingDetailsCategory(ratingCategory: averageRatings.boca),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Text(averageRatings.puntos.toString(), textAlign: TextAlign.center),
                          ),
                        ]
                      );
                    },
                  ),

                  // const TableRow(
                  //   children: [
                  //     TableCell(
                  //       child: Text('Media', textAlign: TextAlign.center,)
                  //     ),
                  //     TableCell(
                  //       child: Text('Vista', textAlign: TextAlign.center,)
                  //     ),
                  //     TableCell(
                  //       child: Text('Nariz', textAlign: TextAlign.center,)
                  //     ),
                  //     TableCell(
                  //       child: Text('Boca', textAlign: TextAlign.center,)
                  //     ),
                  //     TableCell(
                  //       child: Text('Valoración', textAlign: TextAlign.center,)
                  //     ),
                  //   ]
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: CustomBottomSheet(
        buttonText: 'Enviar valoración', 
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
        buttonText: 'Enviar valoración', 
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
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    return TacherScreen(
      appBarTitle: wine.nombre,
      onPressedBackButon: () {
        Navigator.pop(context);
        multipleTaste.resetSettings();
      },
      bottomSheet: CustomBottomSheet(
        buttonText: 'Enviar Valoración',
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