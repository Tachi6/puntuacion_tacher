import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/domain/entities/entities.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MyUserScreen extends StatefulWidget {
   
  const MyUserScreen({super.key});

  @override
  State<MyUserScreen> createState() => _MyUserScreenState();
}

class _MyUserScreenState extends State<MyUserScreen> with AutomaticKeepAliveClientMixin {
  
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: const MyUserBody(),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}

class MyUserBody extends StatelessWidget {

  const MyUserBody({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final winesService = Provider.of<WineServices>(context);
    final otherTasteProvider = Provider.of<OtherTasteProvider>(context);
    final styles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          toolbarHeight: 200,
          floating: true,
          automaticallyImplyLeading: false,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 48,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        final routeDetails = MaterialPageRoute(
                          builder: (context) => const UserSettingsScreen());
                        Navigator.push(context, routeDetails);
                      }, 
                      icon: Icon(Icons.settings, color: colors.onSurface)
                    ),
                  ),

                  Hero(
                    tag: 'image_profile',
                    child: Material(
                      type: MaterialType.transparency,
                      child: CircleAvatar(
                        backgroundColor: colors.onPrimaryFixedVariant,
                        radius: 48,
                        child: Text(authService.userInitial, style: TextStyle(color: colors.surface, fontSize: 60)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(
                    height: 10,
                  ),
            
                  Text(authService.userDisplayName, style: styles.titleLarge),
                ],
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {

              final WineTaste wineTaste = winesService.userWineTaste(authService.userUuid)[index];
              final wine = winesService.obtainWine(wineTaste.id);
              final size = MediaQuery.of(context).size;

              return ListTile(
                minVerticalPadding: 6,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadWineImage(
                      wine: wine,
                      scale: 2/6,
                      imageWidth: size.width * 0.12,
                      source: 'email-$index',
                    ),
                              
                    const SizedBox(width: 20),
                              
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wine.nombre, 
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                              
                          Text(
                            wine.bodega, 
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                              
                          Text(
                            wine.region, 
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          Text(
                            wine.tipo, 
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                              
                    const SizedBox(width: 20),
                              
                    Column(
                      children: [
                        Text(
                            wineTaste.puntosFinal.toString(),
                            style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: colors.outline)
                          ),
                        
                        Text(
                          'Puntos', 
                          style: TextStyle(fontSize: 14, color: colors.outline)
                        ),
                      ],
                    )
                  ],
                ),
                onTap: () {
                  // Asigno el selected WineTaste
                  otherTasteProvider.selectedWineTaste = wineTaste;
                  // Permito ordenar los otherTaste
                  otherTasteProvider.isChangingSelectedWineTaste = false;

                  final routeDetails = MaterialPageRoute(
                    builder: (context) => DetailsScreen(wine: wine.copy(), email: authService.userUuid, source: 'email-$index'));
                  Navigator.push(context, routeDetails);
                },
              );
            },
            childCount: winesService.userWineTaste(authService.userUuid).length,
          )
        )
      ],
    );
  }
}

