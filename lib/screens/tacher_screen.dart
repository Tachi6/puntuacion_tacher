// Image of https://unsplash.com/es/@edge2edgemedia
// Link https://unsplash.com/es/fotos/IhOamKjNWwI

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';


class TacherScreen extends StatelessWidget {

  final textos = Textos();

  TacherScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final statusBarHeight = View.of(context).padding.top / View.of(context).devicePixelRatio;
    final wineForm = Provider.of<CreateEditWineFormProvider>(context);
    final Wines wine = wineForm.wine;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          opacity: 0.3,
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/tacher-background.jpg'), 
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(
                height: statusBarHeight
              ),

              const SizedBox(
                height: 5
              ),

              RatingBox(
                textoTitulo: textos.generalTitulo,
                textoDescripcion: textos.generalDescripcion,
              ),

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
    );
  }
}

class _NotesSendTacher extends StatelessWidget {

  final Wines? wine;

  const _NotesSendTacher(this.wine);

  void confirmationDialog(BuildContext context,{required int points, required Wines wine}) {

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return PointsBox(wine: wine, puntuacionFinal: points);
      }
    );
  }

  void addWineToHiddenTaste(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (BuildContext context) {
        return const AddHiddenWine();
      }
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
          padding: const EdgeInsets.all(5),
          child: Container(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(160),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: const Color.fromARGB(255, 114, 47, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Enviar valoración', style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center),
              onPressed: () async {
                // Verifico si es cata oculta y fuerzo a añadir el vino
                if (wineForm.wine.nombre == '') {
                  if (!context.mounted) return;
                  addWineToHiddenTaste(context);
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
                  confirmationDialog(context, points: wineForm.puntosFinal, wine: wineForm.wine);

                  // Elimino registros para poder valorar de nuevo
                  wineForm.clearNotas();
                  wineForm.clearNotas();
                  wineForm.setDefaultRatings();
                  wineForm.setDefaultCreateWine();
                }
              }
            ),
          ),
        )
      ]
    );
  }
}
