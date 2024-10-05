// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';


class TacherScreen extends StatelessWidget {

  final textos = Textos();

  TacherScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context, listen: true);
    final Wines wine = wineForm.wine;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    return Stack(
      children: [
        const FullScreenBackground(image: 'assets/tacher-background.jpg', opacity: 0.3),

        Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: themeColor.isDarkMode 
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false, 
            actions: [
              IconButton(
                onPressed: () {
                  wineForm.clearNotas();
                  wineForm.clearNotas();
                  wineForm.setDefaultRatings();
                  wineForm.setDefaultCreateWine();
                  Navigator.pop(context);
                }, 
                icon: const Icon(Icons.arrow_back_rounded)
              ),
              
              const Spacer(),

              const Text('Valora tu vino catado', style: TextStyle(fontSize: 20)),

              const Spacer(),

              const SizedBox(width: 40),
            ]
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [          
                RatingBox(
                  textoTitulo: textos.vistaTitulo,
                  textoDescripcion: textos.vistaDescripcion,
                  initialRating: 5,
                  itemCount: 7,
                  minRating: 1,
                  name: 'vista',
                ),
          
                RatingBox(
                  textoTitulo: textos.narizTitulo,
                  textoDescripcion: textos.narizDescripcion,
                  initialRating: 7,
                  itemCount: 9,
                  minRating: 1,
                  name: 'nariz',
                ),
          
                RatingBox(
                  textoTitulo: textos.bocaTitulo,
                  textoDescripcion: textos.bocaDescripcion,
                  initialRating: 7,
                  itemCount: 9,
                  minRating: 1,
                  name: 'boca',
                ),
          
                RatingBox(
                  textoTitulo: textos.puntosTitulo,
                  textoDescripcion: textos.puntosDescripcion,
                  initialRating: 9,
                  itemCount: 11,
                  minRating: 1,
                  name: 'puntos',
                ),
          
                _NotesSendTacher(wine),
              ]
            ),
          ),
        ),
      ],
    );
  }
}

class _NotesSendTacher extends StatelessWidget {

  final Wines? wine;

  const _NotesSendTacher(this.wine);

  void showCustomDialog(BuildContext context, {required Widget child}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false, 
      pageBuilder: (context, animation, secondaryAnimation) {
        return PopScope(
          canPop: false,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: child
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: true);
    final winesService = Provider.of<WinesService>(context);
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Column(
          children: [
            NotesCommentsBox(titulo: 'Notas de Cata'),

            NotesCommentsBox(titulo: 'Comentarios')
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            alignment: Alignment.topRight,
            child: CustomElevatedButton(
              width: 150,
              height: 50,
              onPressed: () async {
                // Verifico si es cata oculta y fuerzo a añadir el vino
                if (wineForm.wine.nombre == '') {
                  if (!context.mounted) return;
                  showCustomDialog(context, child: const AddHiddenWine());     
                  // addWineToHiddenTaste(context);
                }
                else {
                  // Mando updates de los diferentes campos al wine
                  wineForm.addUpdatesToWine();
                  // Mando wine al servidor
                  if (wineForm.wine.id == '-1') {
                    await winesService.createWine(winesService.selectedWine!);
                    await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
                  }
                  else {
                    await winesService.updateWine(winesService.selectedWine!);
                    await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
                  }
                  // Mando wine a la confirmacion
                  if (!context.mounted) return;
                  showCustomDialog(context, child: PointsBox(wine: wineForm.wine, puntuacionFinal: wineForm.puntosFinal));
                  // confirmationDialog(context, points: wineForm.puntosFinal, wine: wineForm.wine);

                  // Elimino registros para poder valorar de nuevo
                  wineForm.clearNotas();
                  wineForm.clearNotas();
                  wineForm.setDefaultRatings();
                  wineForm.setDefaultCreateWine();
                }
              }, 
              child: const Text('Valorar Vino'),
            ),
            
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     fixedSize: const Size.fromWidth(160),
            //     elevation: 0,
            //     padding: const EdgeInsets.symmetric(vertical: 15),
            //     backgroundColor: const Color.fromARGB(255, 114, 47, 55),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            //   ),
            //   child: Text('Enviar valoración', style: TextStyle(fontSize: 14, color: colors.surface), textAlign: TextAlign.center),
            //   onPressed: () async {
            //     // Verifico si es cata oculta y fuerzo a añadir el vino
            //     if (wineForm.wine.nombre == '') {
            //       if (!context.mounted) return;
            //       addWineToHiddenTaste(context);
            //     }
            //     else {
            //       // Mando updates de los diferentes campos al wine
            //       wineForm.addUpdatesToWine();
            //       // Mando wine al servidor
            //       if (wineForm.wine.id == '-1') {
            //         await winesService.createWine(winesService.selectedWine!);
            //         await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
            //       }
            //       else {
            //         await winesService.updateWine(winesService.selectedWine!);
            //         await winesService.saveDeleteLatestTastedWine(wine:winesService.selectedWine!, email: authService.userEmail, displayName: authService.userDisplayName);
            //       }
            //       // Mando wine a la confirmacion
            //       if (!context.mounted) return;
            //       confirmationDialog(context, points: wineForm.puntosFinal, wine: wineForm.wine);

            //       // Elimino registros para poder valorar de nuevo
            //       wineForm.clearNotas();
            //       wineForm.clearNotas();
            //       wineForm.setDefaultRatings();
            //       wineForm.setDefaultCreateWine();
            //     }
            //   }
            // ),
          ),
        )
      ]
    );
  }
}
