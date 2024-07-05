
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/search/search_delegate.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ListScreen extends StatelessWidget {
  
  const ListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WinesService>(context, listen: false);

    if (winesService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado Tacher', style: TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  winesService.loadWines();
                  
                  showSearch(context: context, delegate: WineSearch(winesService.winesByIndex));
                },
                icon: const Icon(Icons.search, color: Colors.white)
              );
            }
          )
        ],
      ),

      body: SingleChildScrollView(        
        child: Column(
          children: [
            Container(
              height: 48,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 11),
              child: const Text('Top 10', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            ListTop10(
              wines: winesService.winesByRate,
            ),

            Container(
              height: 48,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(left: 11, top: 5),
              child: GestureDetector(
                onTap: () {
                  final routeList = MaterialPageRoute(
                    builder: (context) => ListAllScreen(winesService.winesByRate)
                  );
                  Navigator.push(context, routeList);
                },
                child: const Text('Todo el listado >    ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
              )
            ),

            ListBestScreen(
              category: 'Mejores Tintos Reserva', 
              wines: winesService.winesBestCategory('Tinto, Reserva'),
            ),

            const SizedBox(height: 16),

            ListBestScreen(
              category: 'Mejores Tintos Crianza', 
              wines: winesService.winesBestCategory('Tinto, Crianza')
            ),

            const SizedBox(height: 16),

            ListBestScreen(
              category: 'Mejores Tintos con Crianza', 
              wines: winesService.winesBestCategory('Tinto, con Crianza')
            ),
            
            const SizedBox(height: 16),

            ListBestScreen(
              category: 'Mejores Tintos Gran Reserva', 
              wines: winesService.winesBestCategory('Tinto, Gran Reserva')
            ),
            
            const SizedBox(height: 16), 

            ListBestScreen(
              category: 'Mejores Tintos Roble', 
              wines: winesService.winesBestCategory('Tinto, Roble')
            ),

            const SizedBox(height: 16),

            ListBestScreen(
              category: 'Mejores Tintos Jovenes', 
              wines: winesService.winesBestCategory('Tinto, Joven')
            ),

            const SizedBox(height: 16),            

            ]
          ),
      ),
    );
  }
}