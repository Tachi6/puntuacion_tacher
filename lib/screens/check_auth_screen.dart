import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final winesService = Provider.of<WinesService>(context, listen: false);
    final multipleService = Provider.of<MultipleService>(context, listen: false);
    final loginForm = Provider.of<LoginProvider>(context);
    final colors = Theme.of(context).colorScheme;

    Future<void> loadData() async {
      await winesService.loadWines();
      await winesService.loadWinesTaste();
      await multipleService.loadMultiples();
    }

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.isUserLoggedLoadData(loadData), 
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData && snapshot.data!) {
              Future.microtask(() async {
                if (authService.userDisplayName == '') {
                  authService.isDisplayNameGenerated = false;
                  loginForm.isRegister = true;
                }
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => loginForm.isRegister ? const UserSettingsScreen() : const HomeScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
              });
            }
            if (snapshot.hasData && !snapshot.data!) {
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