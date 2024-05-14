import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class MyUserScreen extends StatelessWidget {
   
  const MyUserScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: true);
    final winesService = Provider.of<WinesService>(context);

    final String user;
    authService.userDisplayName == ''
      ? user = authService.userEmail
      : user = authService.userDisplayName; // TODO ver si no peta porque wine puede recibir nulo

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user, style: const TextStyle(fontSize: 18, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              final routeDetails = MaterialPageRoute(
                builder: (context) => const UserSettingsScreen());
              Navigator.push(context, routeDetails);
            }, 
            icon: const Icon(Icons.settings, color: Colors.white)
          )
        ],
      ),
      body: MyUserBody(size: size, winesService: winesService, email: authService.userEmail)
    );
  }
}

class MyUserBody extends StatelessWidget {

  const MyUserBody({
    super.key,
    required this.size,
    required this.winesService,
    required this.email,
  });

  final Size size;
  final WinesService winesService;
  final String email;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
    
          CircleAvatar(
            backgroundColor: redColor(),
            radius: 50,
            child: const Icon(Icons.person, color: Colors.white, size: 60),
            // Text(initials, style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
    
          const SizedBox(
            height: 10,
          ),
    
          const Text('Vinos catados por puntuación', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    
          const SizedBox(
            height: 10,
          ),
    
          Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              width: size.width * 0.9,
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    tileColor: Colors.transparent,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LoadWineImage(
                          wine: winesService.userTastedWines(email)[index],
                          heightReducer: 0.08,
                          widthReducer: 0.08,
                          borderRadius: 5,
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
                                style: const TextStyle(fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              Text(
                                winesService.userTastedWines(email)[index].bodega, 
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
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade700)
                              ),
                            
                            Text(
                              'Puntos', 
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700)
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
                separatorBuilder: (context, index) => Divider(color: redColor()),
                itemCount: winesService.userTastedWines(email).length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}