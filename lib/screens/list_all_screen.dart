// Image of https://unsplash.com/es/@ikredenets
// Link https://unsplash.com/es/fotos/copa-de-vino-transparente-con-vino-tinto-Y4PJ5F_Oskw

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/models/models.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/search/search.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class ListAllScreen extends StatelessWidget {

  final List<Wines> wines;

  const ListAllScreen(this.wines, {super.key});

  
  @override
  Widget build(BuildContext context) {

    final winesService = Provider.of<WineServices>(context);
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final styles = Theme.of(context).textTheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    return Stack(
      children: [
        const FullScreenBackground(image: 'assets/list-all-background.jpg', opacity: 0.3),
    
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            toolbarHeight: 48,
            systemOverlayStyle: themeColor.isDarkMode 
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
    
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
          
              const Spacer(
                flex: 1,
              ),
          
              Text('Listado de vinos', style: styles.titleLarge),
          
              const Spacer(
                flex: 1,
              ),
          
              IconButton(
                onPressed: () async {
                  // Limpio el selected WineTaste
                  if (otherTasteProvider.selectedWineTaste != null) {
                    otherTasteProvider.selectedWineTaste = null;
                  }
                  if (context.mounted) {
                    final wineSearched = await showSearch(context: context, delegate: SearchDelegateWines(winesList: winesService.winesByName));
                    final routeDetails = MaterialPageRoute(
                      builder: (context) => DetailsScreen(wine:wineSearched.copy(), source: 'search')
                    );
                    
                    if (wineSearched != null && context.mounted) Navigator.push(context, routeDetails);
                  }
                },
                icon: const Icon(Icons.search)
              ),
            ],
          ),
          body: _ListAllBody(wines: wines)
        ),
      ],
    );
  }
}

class _ListAllBody extends StatelessWidget {
  const _ListAllBody({
    required this.wines
  });

  final List<Wines> wines;

  @override
  Widget build(BuildContext context) {

    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: wines.length,
      itemBuilder: (context, index) {
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
                style: const TextStyle(fontSize: 14),
              ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                wines[index].puntuacionFinal.toString(), 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.outline),
              ),
              Text(
                'Puntos', 
                style: TextStyle(fontSize: 14, color: colors.outline),
              ),
            ],
          ),
          onTap: () {
            // Limpio el selected WineTaste
            if (otherTasteProvider.selectedWineTaste != null) {
              otherTasteProvider.selectedWineTaste = null;
            }

            final routeDetails = MaterialPageRoute(
              builder: (context) => DetailsScreen(wine: wines[index].copy(), source: 'list'));
            Navigator.push(context, routeDetails);
          },
        );
      },
    );
  }
}