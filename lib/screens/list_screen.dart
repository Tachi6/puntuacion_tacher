import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ListScreen extends StatefulWidget {
  
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final winesService = Provider.of<WineServices>(context, listen: false);
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;

    if (winesService.isLoading) return const LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 48,
            collapsedHeight: 48,
            floating: true,
            actions: [
              IconButton(
                onPressed: () async {
                    if (context.mounted) {
                    // Limpio el selected WineTaste
                    if (otherTasteProvider.selectedWineTaste != null) {
                      otherTasteProvider.selectedWineTaste = null;
                    }

                    final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));
                    final routeDetails = MaterialPageRoute(
                      builder: (context) => DetailsScreen(wine:wineSearched, source: 'search')
                    );
                    if (wineSearched != null && context.mounted) Navigator.push(context, routeDetails);
                  }
                },
                // onPressed: () {
                //   winesService.loadWines();
                  
                //   showSearch(context: context, delegate: WineSearch(winesService.winesByIndex));
                // },
                icon: const Icon(Icons.search)
              ),

              // TODO select best views
              // IconButton(
              //   onPressed: () {
              //   },
              //   icon: const Icon(Icons.tune_rounded)
              // ),
              
              const Spacer(),
              
              TextButton(
                onPressed: () {
                  final routeList = MaterialPageRoute(
                    builder: (context) => ListAllScreen(winesService.winesByRate)
                  );
                  Navigator.push(context, routeList);
                }, 
                child: Text('Todo el listado >', style: TextStyle(fontSize: 16, color: colors.onSurface))
              )
            ],
              
          ),
    
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Column(
                  children: [          
                    Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Text('Top 10', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                
                    ListTop10(
                      wines: winesService.winesByRate,
                    ),
                
                    const SizedBox(height: 16),
                
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
                );
              },
              childCount: 1,
            )
          )
        ],      
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}