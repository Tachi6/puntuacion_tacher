import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';

class RatingBox extends StatelessWidget {

  final String textoTitulo;
  final String textoDescripcion;
  final double? initialRating;
  final double? minRating;
  final int? itemCount;
  final String? name;


  const RatingBox({
    super.key, 
    required this.textoTitulo, 
    required this.textoDescripcion,
    this.initialRating, 
    this.minRating, 
    this.itemCount, 
    this.name
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: const Color.fromARGB(64, 114, 47, 55),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(textoTitulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),

              const SizedBox(height:5),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(textoDescripcion, style: const TextStyle(fontSize: 12), textAlign: TextAlign.justify)),

              const SizedBox(height: 5),

              if (name != null) _RatingCustomWidget(
                initialRating: initialRating!, 
                minRating: minRating!, 
                itemCount: itemCount!, 
                name: name!
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingCustomWidget extends StatelessWidget{
  
  final double initialRating;
  final double minRating;
  final int itemCount;
  final String name;

  const _RatingCustomWidget({
    required this.initialRating, 
    required this.minRating, 
    required this.itemCount, 
    required this.name
  });

  @override
  Widget build(BuildContext context) {

    final wineForm = Provider.of<CreateEditWineFormProvider>(context);

    return RatingBar.builder(
      initialRating: initialRating,
      minRating: minRating,
      itemCount: itemCount,
      direction: Axis.horizontal,
      allowHalfRating: false,
      tapOnlyMode: true,
      glow: false,
      unratedColor: Colors.white,
      itemSize: 32,
      itemPadding: const EdgeInsets.symmetric(horizontal: 0),
      itemBuilder: (context, index ) {
        if (name == 'puntos') {
          return _IconNumber(index); 
        } 
        else {
          return _IconWine();        }
      },
      onRatingUpdate: (value) {
        if (name == 'vista') {
          wineForm.editRatingVista(value);
        }
        if (name == 'nariz') {
          wineForm.editRatingNariz(value);
        }
        if (name == 'boca') {
          wineForm.editRatingBoca(value);
        }
        if (name == 'puntos') {
          wineForm.editRatingPuntos(value);
        }
      },
    );
  }
}

class _IconNumber extends StatelessWidget {

  final int index;

  TextStyle numberStyle() => const TextStyle(color:  Color.fromARGB(255, 114, 47, 55), fontWeight: FontWeight.bold);

  const _IconNumber(this.index);

  @override
  Widget build(BuildContext context) {
        switch (index) {
          case 0:
            return Text(
              '0', style: numberStyle(),
            );
          case 1:
            return Text(
              '1', style: numberStyle(),
            );
          case 2:
            return Text(
              '2', style: numberStyle(),
            );
          case 3:
            return Text(
              '3', style: numberStyle(),
            );
          case 4:
            return Text(
              '4', style: numberStyle(),
            );
          case 5:
            return Text(
              '5', style: numberStyle(),
            );
          case 6:
            return Text(
              '6', style: numberStyle(),
            );
          case 7:
            return Text(
              '7', style: numberStyle(),
            );
          case 8:
            return Text(
              '8', style: numberStyle(),
            );
          case 9:
            return Text(
              '9', style: numberStyle(),
            );
          case 10:
            return Text(
              '10', style: numberStyle(),
            );
          default:
            return const SizedBox();
        }
      }
}

class _IconWine extends StatelessWidget{

  @override
  Widget build(Object context) {
    return const Icon(
          Icons.wine_bar,
          color: Color.fromARGB(255, 114, 47, 55),
        );
  }
}
