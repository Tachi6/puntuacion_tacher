// https://www.freepik.es/foto-gratis/sacacorchos-primer-plano-cabeza-botella-vino_6447659.htm#fromView=search&page=1&position=14&uuid=ede5f260-0fd2-4307-9659-1b5053819678

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class EnterDisplayNameScreen extends StatelessWidget {
  const EnterDisplayNameScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return DisplayNameBackground(
      widget: const ChangeDisplayNameBox(), 
      backgroundColor: colors.surface,
    ); 
  }
}

class ChangeDisplayNameBox extends StatelessWidget {
  const ChangeDisplayNameBox({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),

      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 70),
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
          width: size.width * 0.85,
          // height: 240,
          decoration: BoxDecoration(
            color: colors.onPrimaryFixedVariant.withAlpha((255 * 0.8).toInt()),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comienza a catar vinos', 
                textAlign: TextAlign.center, 
                style: TextStyle(
                  color: colors.surface, 
                  fontSize: 20, 
                  fontWeight: FontWeight.bold
                ),
              ),
              
              const SizedBox(height: 20),

              const DisplayNameTextFormField(),

              const SizedBox(height: 40),

              CustomElevatedButton(
                width: 150,
                child: Text('Comenzar', style: TextStyle(color: colors.primary, fontSize: 16)),
                onPressed: () async { 
                  // TODO actualizar base de datos de nombres de usuario
                  FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado

                  if (authService.tempDisplayName == '') {
                    NotificationsService.showSnackbar('NOMBRE DE USUARIO VACIO', context);
                    return;
                  }

                  if (authService.tempDisplayName.trim().length < 4) {
                    NotificationsService.showSnackbar('NOMBRE DE USUARIO MUY CORTO', context);
                    return;
                  }

                  if (await authService.isUniqueDisplayName(authService.tempDisplayName)) {
                    await authService.renameUser(authService.tempDisplayName);
                    
                    final newRoute = CupertinoPageRoute(
                      builder: (context) => authService.userDisplayName == '' ? const EnterDisplayNameScreen() : const HomeScreen()
                    );
                    if (context.mounted) Navigator.pushReplacement(context, newRoute);
                    return;
                  }
                  if (!await authService.isUniqueDisplayName(authService.tempDisplayName)) {
                    if (context.mounted) NotificationsService.showSnackbar('NOMBRE DE USUARIO YA UTILIZADO', context);
                    return;
                  }
                },
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class DisplayNameTextFormField extends StatelessWidget {
  const DisplayNameTextFormField({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final colors = Theme.of(context).colorScheme;

    return Theme(
      data: AppTheme().getTheme(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: colors.onPrimaryFixedVariant,
        )
      ),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        child: TextFormField(
          cursorErrorColor: colors.onErrorContainer,
          cursorColor: colors.surface,
          style: TextStyle(color: colors.surface),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colors.surface
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colors.surface,
                width: 2
              )
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colors.onPrimaryFixed,
              )
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: colors.onPrimaryFixed,
                width: 2,
              )
            ),
            hintText: 'Antonio Gonzalez',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            labelText: 'Nombre de usuario',
            labelStyle: TextStyle(
              color: colors.surface
            ),
            prefixIcon: Icon(Icons.person_rounded, color: colors.surface, size: 18),
            errorStyle: TextStyle(color: colors.onErrorContainer),
          ),
          onChanged: (value) {
            authService.tempDisplayName = value;
          },
          // validator: (value) {
          //   if (value == null || value == '') {
          //     return 'Nombre de usuario vacio';
          //   }
          //   if (value.trim().length < 4) {
          //     return 'Nombre de usuario muy corto';
          //   }
          //   return null;
          // },
        ),
      ),
    );
  }
}