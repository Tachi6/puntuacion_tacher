import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/presentation/providers/providers.dart';
import 'package:puntuacion_tacher/router/transitions_route.dart';

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
                if (context.mounted) Navigator.pushAndRemoveUntil(context, fadeTransistionRoute(context, const EnterDisplayNameScreen()), (route) => false);
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.logged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.pushAndRemoveUntil(context, fadeTransistionRoute(context, const HomeScreen()), (route) => false);
              });
            }
            if (snapshot.hasData && snapshot.data! == UserLoginStatus.notLogged) {
              Future.microtask(() async {
                if (context.mounted) Navigator.pushAndRemoveUntil(context, fadeTransistionRoute(context, const LoginScreen()), (route) => false);
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