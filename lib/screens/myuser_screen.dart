import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MyUserScreen extends StatelessWidget {
   
  const MyUserScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: true);
    final winesService = Provider.of<WinesService>(context);
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: MyUserBody(
        size: size, 
        winesService: winesService, 
        email: authService.userEmail, 
        user: authService.userDisplayName == ''
          ? authService.userEmail
          : authService.userDisplayName // TODO ver si no peta porque wine puede recibir nulo???
      ),
    );
  }
}

class MyUserBody extends StatelessWidget {

  const MyUserBody({
    super.key,
    required this.size,
    required this.winesService,
    required this.email, 
    required this.user,
  });

  final Size size;
  final WinesService winesService;
  final String email;
  final String user;

  @override
  Widget build(BuildContext context) {

    final styles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final authService = Provider.of<AuthService>(context, listen: true);

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
                        child: Text(authService.userDisplayName[0].toUpperCase(), style: TextStyle(color: colors.surface, fontSize: 60)),
                      ),
                    ),
                  ),
                  
                  const SizedBox(
                    height: 10,
                  ),          
            
                  Text(user, style: styles.titleLarge),
                  
                  // const SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ListTile(
                minVerticalPadding: 6,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoadWineImage(
                      wine: winesService.userTastedWines(email)[index],
                      scale: 2/6,
                      imageWidth: 60,
                      source: 'email',
                    ),
                              
                    const SizedBox(width: 20),
                              
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            winesService.userTastedWines(email)[index].nombre, 
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                              
                          Text(
                            winesService.userTastedWines(email)[index].bodega, 
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                              
                          Text(
                            winesService.userTastedWines(email)[index].tipo, 
                            style: const TextStyle(fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                              
                          Text(
                            winesService.userTastedWines(email)[index].region, 
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
                            winesService.userTastedWines(email)[index].puntuaciones[winesService.userTastedWines(email)[index].usuarios.indexOf(email)].toString(), 
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
                  final routeDetails = MaterialPageRoute(
                    builder: (context) => DetailsScreen(wine: winesService.userTastedWines(email)[index], email: email, source: 'email'));
                  Navigator.push(context, routeDetails);
                },
              );
            },
            childCount: winesService.userTastedWines(email).length,
          )
        )
      ],
    );
  }
}

