// Photo by <a href="/photographer/muddy-31912">muddy</a> on <a href="/">Freeimages.com</a>

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {

  final Wines wine;
  final String? email;
  final String source;

  const DetailsScreen({super.key, required this.wine, this.email, required this.source});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          opacity: 0.4,
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
          image: AssetImage('assets/details-background.jpg'),
        ), 
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            _CustomAppBar(wine: wine, user: email, source: source),
            SliverList(
              delegate: SliverChildListDelegate([

                _WinePoster(wine: wine, user: email, source: source)
              
              ])           
            )
          ],
        )
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  final Wines wine;
  final String? user;
  final String source;
  // TODO poner tachi cato y valoro???

  const _CustomAppBar({required this.wine, this.user, required this.source});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          padding: const EdgeInsetsDirectional.all(0),
          width: double.infinity,
          color: Colors.black38,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Container(
                height: 61,
                alignment: Alignment.bottomRight,
                child: IconButton(
                  tooltip: 'Editar logo de la bodega',
                  iconSize: 16,
                  splashRadius: 16,
                  color: Colors.white,
                  onPressed: () {}, 
                  icon: const Icon(Icons.edit)
                ),
              ),
             
              Container(
                height: 91,
                alignment: Alignment.bottomCenter,
                child: user == null 
                  ?
                  const Text('Ficha técnica global', style: TextStyle(fontSize: 16))
                  :
                    source == 'latest' 
                      ?
                      const Text('Valoración de la cata', style: TextStyle(fontSize: 16))
                      :
                      const Text('Valoración de mi cata', style: TextStyle(fontSize: 16))
              ),
              
            ],
          ) 
          
        ),
        // TODO ingresar imagen de bodega
        background: (wine.bodega == 'Valenciso') 
          ?
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: FadeInImage(
              placeholder: AssetImage('assets/no_image.jpg'), 
              image: AssetImage('assets/valenciso.jpg'),
              fit: BoxFit.fitWidth,
            ),
          )
          : 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: AutoSizeText(
                wine.bodega,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold, 
                  color: redColor()
                ),
              )
            ),
          ),
      ),
    );
  }
}

class _WinePoster extends StatelessWidget {

  // TODO refactorizar mas limpio

  final Wines wine;
  final String? user;
  final String source;
  final double circularRadius = 20;

  const _WinePoster({required this.wine, this.user, required this.source});

  @override
  Widget build(BuildContext context) {

    Widget detectEmptyText(String dato) {
      if (dato != "" ) {
        return Text(dato, style: const TextStyle(fontSize: 14));
      }
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top:20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadWineImage(
            wine: wine, 
            heightReducer: 0.4, 
            widthReducer: 0.3,
            borderRadius: circularRadius,
            source: source,
          ),

          const SizedBox(
            width: 20,
          ),

          SizedBox(
            width: 210,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(wine.vino, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2),
                Text(wine.anada.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                detectEmptyText(wine.tipo),
                detectEmptyText(wine.bodega),
                detectEmptyText(wine.region),
                detectEmptyText(wine.variedades),
                wine.graduacion != '' ? Text('${wine.graduacion}%', style: const TextStyle(fontSize: 14)) : const SizedBox(),
                detectEmptyText(wine.descripcion),

                user == null
                  ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${wine.puntuacionFinal} puntos Tacher', style: const TextStyle(fontSize: 14)),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionVista)
                        ],
                      ),
                      detectEmptyText(wine.notaVista),
                      
                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionNariz)
                        ],
                      ),
                      detectEmptyText(wine.notaNariz),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionBoca)
                        ],
                      ),
                      detectEmptyText(wine.notaBoca),
                    ]
                  )
                  :
                  user == 'latest'
                  ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${wine.puntuaciones.last} puntos Tacher', style: const TextStyle(fontSize: 14)),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesVista.last),
                        ],
                      ),
                      detectEmptyText(wine.notasVista.last),
                      
                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz.last),
                        ],
                      ),
                      detectEmptyText(wine.notasNariz.last),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca.last),
                        ],
                      ),
                      detectEmptyText(wine.notasBoca.last),

                      Text(wine.comentarios.last, style: const TextStyle(fontSize: 14)),
                    ]
                  )
                  :
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${wine.puntuaciones[wine.usuarios.indexOf(user!)]} puntos Tacher', style: const TextStyle(fontSize: 14)),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Vista', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesVista[wine.usuarios.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasVista[wine.usuarios.indexOf(user!)]),
                      
                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Nariz', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesNariz[wine.usuarios.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasNariz[wine.usuarios.indexOf(user!)]),

                      Row(
                        children: [
                          const SizedBox(width: 44 ,child: Text('Boca', style: TextStyle(fontSize: 14),)),
                          RatingDetailsCategory(ratingCategory: wine.puntuacionesBoca[wine.usuarios.indexOf(user!)]),
                        ],
                      ),
                      detectEmptyText(wine.notasBoca[wine.usuarios.indexOf(user!)]),

                      Text(wine.comentarios[wine.usuarios.indexOf(user!)], style: const TextStyle(fontSize: 14)),
                    ]
                  )
              ],
            ),
          ),
        ],
      )
    );
  }
}

