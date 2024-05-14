
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';


import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

void main(){
  runApp(const AppState());
}

// TODO falta configurar las imagenes splashscreen de IOS
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => WinesService()),
        ChangeNotifierProvider(create: ( _ ) => ScreensProvider()),
        ChangeNotifierProvider(create: ( _ ) => VisibleOptionsProvider()),
        ChangeNotifierProvider(create: ( _ ) => CreateEditWineFormProvider()),

      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.redWineTheme,
        // home: const LoginScreen(), 
        routes: {
          'checkingAuth':(context) => const CheckAuthScreen(),

          'login':(context) => const LoginScreen(),
          'register':(context) => const RegisterScreen(),

          'home':(context) => const HomeScreen(),
        },
        initialRoute: 'checkingAuth',
        // scaffoldMessengerKey: NotificationsService.messengerKey, // TODO creo que no es necesario un global key
      );
  }
}