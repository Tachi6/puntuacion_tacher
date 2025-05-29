import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/constants/environment.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

Future<void> main() async {
  await Environment.initEnvironment();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {

    const List<String> precacheImages = [
      'assets/bottle_noimage.jpg',
      'assets/details-background.jpg',
      'assets/enter_display_name_background.jpg',
      'assets/initial-multiple-background.jpg',
      'assets/list-all-background.jpg',
      'assets/login-background.jpg',
      'assets/settings_background.jpg',
      'assets/tacher-background.jpg',
      'assets/taste-background.jpg',
    ];

    for (var image in precacheImages) {
      precacheImage(AssetImage(image), context);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthServices()),
        ChangeNotifierProvider(create: ( _ ) => LoginProvider()),
        ChangeNotifierProvider(create: ( _ ) => WineServices()),
        ChangeNotifierProvider(create: ( _ ) => UserServices()),
        ChangeNotifierProvider(create: ( _ ) => QuizServices()),
        ChangeNotifierProvider(create: ( _ ) => ScreensProvider()),
        ChangeNotifierProvider(create: ( _ ) => TasteOptionsProvider()),
        ChangeNotifierProvider(create: ( _ ) => CreateEditWineFormProvider()),
        ChangeNotifierProvider(create: ( _ ) => ChangeThemeProvider()),
        ChangeNotifierProvider(create: ( _ ) => OtherTasteProvider()),
        ChangeNotifierProvider(create: ( _ ) => MultipleListProvider()),
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
      routes: {
        'checkingAuth':(context) => const CheckAuthScreen(),
        'login':(context) => MediaQuery.withNoTextScaling(child: const LoginScreen()),
        'displayName':(context) => MediaQuery.withNoTextScaling(child: const EnterDisplayNameScreen()),
      },
      initialRoute: 'checkingAuth',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
            boldText: false, 
          ),
          child: child!,
        );
      },
    );
  }
}