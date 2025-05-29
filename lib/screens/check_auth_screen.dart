import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';

import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class CheckAuthScreen extends StatelessWidget {
   
  const CheckAuthScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    final authService = context.read<AuthServices>();
    final colors = Theme.of(context).colorScheme;

    Future<void> loadData() async {
      await Future.wait([
        context.read<UserServices>().loadUsers(),
        context.read<WineServices>().loadWines(),
        context.read<WineServices>().loadWinesTaste(),
        context.read<MultipleListProvider>().loadMultiple(),
      ]);
    }

    Route createRoute(Widget newPage) {
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) {
          return newPage;
        },
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (_, animation, __, child) {
          final curvedAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark
        ),
      ),
      body: Center(
         child: FutureBuilder<UserLoginStatus>(
          future: authService.isUserLoggedLoadData(loadData), 
          builder: (BuildContext context, AsyncSnapshot<UserLoginStatus> snapshot) {
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.registering) {
              Future.microtask(() async {
                if (context.mounted) Navigator.pushAndRemoveUntil(context, createRoute(const EnterDisplayNameScreen()), (route) => false);
                // if (context.mounted) Navigator.popAndPushNamed(context, 'displayName');
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.logged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.pushAndRemoveUntil(context, createRoute(const HomeScreen()), (route) => false);
                // if (context.mounted) Navigator.popAndPushNamed(context, 'home');
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.notLogged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.pushAndRemoveUntil(context, createRoute(const LoginScreen()), (route) => false);
                // if (context.mounted) Navigator.popAndPushNamed(context, 'login');
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