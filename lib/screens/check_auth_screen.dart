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
                final routeDetails = PageRouteBuilder(
                  transitionDuration: Duration.zero,
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
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
                // Para mandarlo directo sin animacion, solo quiero que cargue el usuario en esta screen
                final routeDetails = PageRouteBuilder(
                  transitionDuration: Duration.zero,
                  pageBuilder: (_, __, ___) => loginForm.isRegister ? const UserSettingsScreen() : const HomeScreen(),
                );

                if (context.mounted) Navigator.pushReplacement(context, routeDetails);
              });
            }
            return const SizedBox();
          },
        )
      ),
    );
  }
}