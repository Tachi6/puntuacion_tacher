
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/providers/providers.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final loginForm = Provider.of<LoginProvider>(context);
    const storage = FlutterSecureStorage();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readIdToken(), 
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: colors.primary,
              );
            }
            if (snapshot.data == '') {
              Future.microtask(() async {
                if (!context.mounted) return;
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => const LoginScreen()
                );
                Navigator.pushReplacement(context, routeDetails);

                // Navigator.pushReplacement(context, PageRouteBuilder(
                //   pageBuilder: ( _ , __ , ___ ) => const LoginScreen(),
                //   transitionDuration: const Duration(seconds: 0),
                // ));
              });
            }
            else {
              Future.microtask(() async {
                final String? email = await storage.read(key: 'email');
                final String? password = await storage.read(key: 'password');
                await authService.loginUser(email!, password!);

                if (authService.userDisplayName == '') {
                  authService.isDisplayNameGenerated = false;
                  loginForm.isRegister = true;
                }
                
                if (!context.mounted) return;
                final routeDetails = CupertinoPageRoute(
                  builder: (context) => loginForm.isRegister ? const UserSettingsScreen() : const HomeScreen(),
                );
                Navigator.pushReplacement(context, routeDetails);

                // Navigator.pushReplacement(context, PageRouteBuilder(
                //   pageBuilder: ( _ , __ , ___ ) => loginForm.isRegister ? const UserSettingsScreen() : const HomeScreen(),
                //   transitionDuration: const Duration(seconds: 0),
                // ));
              });
            }
            return const SizedBox();
          },
        )
      ),
    );
  }
}