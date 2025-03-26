// https://www.freepik.es/foto-gratis/sacacorchos-primer-plano-cabeza-botella-vino_6447659.htm#fromView=search&page=1&position=14&uuid=ede5f260-0fd2-4307-9659-1b5053819678

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class EnterDisplayNameScreen extends StatelessWidget {
  const EnterDisplayNameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DisplayNameBackground(
      widget: ChangeDisplayName(), 
    ); 
  }
}

class ChangeDisplayName extends StatelessWidget {
  const ChangeDisplayName({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final double bottomPadding = context.read<ScreenElementsSizeProvider>().bottomElementHeight;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            bottom: (size.width * 0.15) / 2 + bottomPadding,
            right: (size.width * 0.15) / 2,
            child: const ChangeDisplayNameBody()
          ),
        ],
      ),
    );
  }
}

class ChangeDisplayNameBody extends StatelessWidget {
  const ChangeDisplayNameBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final userService = Provider.of<UserServices>(context);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.85,
      height: 240,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
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
          
          const SizedBox(height: 15),
        
          const DisplayNameTextFormField(),
        
          const SizedBox(height: 10),
        
          CustomElevatedButton(
            width: 150,
            label: 'Comenzar',
            isSendingLabel: 'Comenzando',
            style: TextStyle(color: colors.primary, fontSize: 16),
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado
        
              if (authService.tempDisplayName == '') {
                NotificationServices.showSnackbar('NOMBRE DE USUARIO VACIO', context);
                return;
              }
        
              if (authService.tempDisplayName.trim().length < 4) {
                NotificationServices.showSnackbar('NOMBRE DE USUARIO MUY CORTO', context);
                return;
              }
        
              if (authService.tempDisplayName.contains('%')) {
                NotificationServices.showSnackbar('% NO ES UN CARACTER PERMITIDO', context);
                return;
              }
        
              if (await userService.isUniqueDisplayName(authService.tempDisplayName)) {
                await authService.changeDisplayName(authService.tempDisplayName);
                await userService.updateUuidDisplayName(authService.tempDisplayName);
                
                final newRoute = MaterialPageRoute(
                  builder: (context) => const CheckAuthScreen()
                );
                if (context.mounted) Navigator.pushReplacement(context, newRoute);
                return;
              }
              else {
                if (context.mounted) NotificationServices.showSnackbar('NOMBRE DE USUARIO YA UTILIZADO', context);
                return;
              }
            },
          ),
        ]
      ),
    );
  }
}

class DisplayNameTextFormField extends StatelessWidget {
  const DisplayNameTextFormField({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final colors = Theme.of(context).colorScheme;

    return Theme(
      data: AppTheme().getTheme(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: colors.onPrimaryFixedVariant,
        )
      ),
      child: Container(
        height: 80,
        alignment: Alignment.topCenter,
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
          ),
        ),
      ),
    );
  }
}