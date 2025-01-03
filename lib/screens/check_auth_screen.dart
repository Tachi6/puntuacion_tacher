import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final winesService = Provider.of<WinesService>(context, listen: false);
    final multipleService = Provider.of<MultipleService>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    Future<void> loadData() async {
      await Future.wait([
        winesService.loadWines(),
        winesService.loadWinesTaste(),
        multipleService.loadMultiples()
      ]);
    }

    return Scaffold(
      body: Center(
         child: FutureBuilder<UserLoginStatus>(
          future: authService.isUserLoggedLoadData(loadData), 
          builder: (BuildContext context, AsyncSnapshot<UserLoginStatus> snapshot) {
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.registering) {
              Future.microtask(() async {
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => const UserSettingsScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.logged) {
              Future.microtask(() async {
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => const HomeScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.notLogged) {
              Future.microtask(() async {
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => const LoginScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
              });
            }
            return CircularProgressIndicator(
              color: colors.primary,
            );
          },
        )
      ),
    );
  }
}