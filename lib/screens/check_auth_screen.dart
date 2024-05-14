
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    const storage = FlutterSecureStorage();

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: authService.readIdToken(), 
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            
            if (!snapshot.hasData) {
              return CircularProgressIndicator(
                color: redColor(),
              );
            }

            if (snapshot.data == '') {
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _ , __ , ___ ) => const LoginScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ));
              });
            }
            else {
              Future.microtask(() async {
                final String? email = await storage.read(key: 'email');
                final String? password = await storage.read(key: 'password');
                await authService.loginUser(email!, password!);
                
                if (!context.mounted) return;
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _ , __ , ___ ) => const HomeScreen(),
                  transitionDuration: const Duration(seconds: 0),
                ));
              });
            }

            return const SizedBox();
            
          },
        )
      ),
    );
  }
}