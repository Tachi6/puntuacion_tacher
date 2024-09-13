
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';


import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

void main(){
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {

    const List<String> precacheImages = [
      'assets/details-background.jpg',
      'assets/list-all-background.jpg',
      'assets/login-background.jpg',
      'assets/login-background.jpg',
      'assets/settings_background.jpg',
      'assets/tacher-background.jpg',
      'assets/taste-background.jpg',
      'assets/bottle_noimage.jpg',
      'assets/no_image.jpg',
      'assets/valenciso.jpg',
    ];

    for (var image in precacheImages) {
      precacheImage(AssetImage(image), context);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService()),
        ChangeNotifierProvider(create: ( _ ) => LoginProvider()),
        ChangeNotifierProvider(create: ( _ ) => WinesService()),
        ChangeNotifierProvider(create: ( _ ) => ScreensProvider()),
        ChangeNotifierProvider(create: ( _ ) => VisibleOptionsProvider()),
        ChangeNotifierProvider(create: ( _ ) => CreateEditWineFormProvider()),
        ChangeNotifierProvider(create: ( _ ) => ChangeThemeProvider()),

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
        theme: AppTheme().getTheme(context), 
        // theme: AppTheme.redWineTheme,
        // home: const LoginScreen(), 
        routes: {
          'checkingAuth':(context) => const CheckAuthScreen(),

          'login':(context) => const LoginScreen(),

          'home':(context) => const HomeScreen(),
        },
        initialRoute: 'checkingAuth',
      );
  }
}