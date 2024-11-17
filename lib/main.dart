
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        ChangeNotifierProvider(create: ( _ ) => MultipleService()),
        ChangeNotifierProvider(create: ( _ ) => ScreensProvider()),
        ChangeNotifierProvider(create: ( _ ) => VisibleOptionsProvider()),
        ChangeNotifierProvider(create: ( _ ) => CreateEditWineFormProvider()),
        ChangeNotifierProvider(create: ( _ ) => ChangeThemeProvider()),
        ChangeNotifierProvider(create: ( _ ) => MultipleTasteProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // TODO ver si es eficiente este refresh del user
    final authService = Provider.of<AuthService>(context, listen: false);

    // void refreshUser() async {
    //   while (true) {
    //     await Future.delayed(const Duration(seconds: 3300), () => authService.refreshUser());
    //   }
    // }

    authService.refreshUser();

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),
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