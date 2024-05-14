// Image of https://unsplash.com/es/@ikredenets
// Link https://unsplash.com/es/fotos/copa-de-vino-transparente-con-vino-tinto-Y4PJ5F_Oskw

import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/search/search_delegate.dart';


class ListAllScreen extends StatelessWidget {

  final List<Wines> wines;

  const ListAllScreen(this.wines, {super.key});

  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          opacity: 0.3,
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/list-all-background.jpg'),
        ), 
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Listado completo Tacher', style: TextStyle(fontSize: 18, color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () => showSearch(
                context: context, 
                delegate: WineSearch(wines)
              ), 
              icon: const Icon(Icons.search, color: Colors.white)
            )
          ],
        ),
    
        body: SizedBox(
          width: double.infinity,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(color: redColor()),
            itemCount: wines.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                minLeadingWidth: 20,
                tileColor: Colors.transparent,
                titleAlignment: ListTileTitleAlignment.center,
                leading: Text(
                  (index + 1).toString(), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                title: Text(
                  '${wines[index].vino} ${wines[index].anada}. ${wines[index].bodega}, ${wines[index].region}', 
                  style: const TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                      wines[index].tipo.toString(), 
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      wines[index].puntuacionFinal.toString(), 
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                    ),
                    Text(
                      'Puntos', 
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                    ),
                  ],
                ),
                onTap: () {
                  final routeDetails = MaterialPageRoute(
                      builder: (context) => DetailsScreen(wine: wines[index], source: 'list',));
                  Navigator.push(context, routeDetails);
                },
              );
            }, 
          ),
        ),
      ),
    );
  }
}