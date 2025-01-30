import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context, listen: false);
    final winesService = Provider.of<WineServices>(context, listen: false);
    final multipleService = Provider.of<MultipleServices>(context, listen: false);
    final userService = Provider.of<UserServices>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    Future<void> loadData() async {
      await Future.wait([
        userService.loadUsers(),
        winesService.loadWines(),
        winesService.loadWinesTaste(),
        multipleService.loadMultiples(),
      ]);
    }

    return Scaffold(
      body: Center(
         child: FutureBuilder<UserLoginStatus>(
          future: authService.isUserLoggedLoadData(loadData), 
          builder: (BuildContext context, AsyncSnapshot<UserLoginStatus> snapshot) {
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.registering) {
              Future.microtask(() async {
                if (context.mounted) Navigator.popAndPushNamed(context, 'displayName');
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.logged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.popAndPushNamed(context, 'home');
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.notLogged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.popAndPushNamed(context, 'login');
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