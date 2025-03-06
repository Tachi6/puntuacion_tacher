import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return LoginBackground(
      widget: const LoginForm(),
      backgroundColor: colors.surface,
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.only(bottom: bottomPadding + 30),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        height: double.infinity,
        child: const SingleChildScrollView(
          child: ContainerLoginForm(),
        ),
      )
    );
  }
}

class ContainerLoginForm extends StatelessWidget {
  const ContainerLoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      width: size.width * 0.85,
      decoration: BoxDecoration(
        color: colors.onPrimaryFixedVariant.withAlpha((255 * 0.8).toInt()),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const LoginRegisterForm(),
    );
  }
}

class LoginRegisterForm extends StatelessWidget {
  const LoginRegisterForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthServices>(context);
    final loginForm = Provider.of<LoginProvider>(context);
    final colors = Theme.of(context).colorScheme;

    Future<void> sendLoginForm() async {
      FocusManager.instance.primaryFocus?.unfocus(); // quitar teclado

      if ( !loginForm.isValidForm() ) return;

      final String? errorMessage;

      loginForm.isRegister
        ? errorMessage = await authService.createUser(loginForm.email, loginForm.password)
        : errorMessage = await authService.loginUser(loginForm.email, loginForm.password);

      if (errorMessage == null) {
        if (context.mounted) Navigator.popAndPushNamed(context, 'checkingAuth');
        // FOR NOT VIEW 'ingresar' MESSAGE IF THERE ARE A LOGOUT
        await Future.delayed(const Duration(milliseconds: 250), () {
          loginForm.isRegister = false;
        });
      }
      else {
        if (context.mounted) NotificationServices.showSnackbar(errorMessage, context);
      }
    }

    return Form(
      key: loginForm.loginFormKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LoginTextFormField(
            obscureText: false,
            textInputType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            hintText: 'tacher@tacher.com',
            labelText: 'Correo electrónico',
            icon: Icons.alternate_email_outlined,
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp  = RegExp(pattern);

              return regExp.hasMatch(value!)
                ? null
                : 'Formato de correo electrónico no válido';
            },
          ),

          const SizedBox(height: 20),

          LoginTextFormField(
            obscureText: loginForm.passwordObscure,
            textInputType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            hintText: '******',
            labelText: 'Contraseña',
            icon: Icons.lock_outline,
            suffixIcon: IconButton(
              onPressed: () {
                loginForm.passwordObscure = !loginForm.passwordObscure;
              },
              icon: Icon(loginForm.passwordObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
                color: colors.surface, size: 18
              ),
            ),
            onChanged: (value) => loginForm.password = value,
            onFieldSubmitted: (_) => sendLoginForm(),
            validator: (value) {
              if (value != null && value.length >= 6) {
                return null;
              }
              else {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
            },
          ),

          const SizedBox(height: 40),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1250),
            layoutBuilder: (currentChild, previousChildren) {
              return currentChild!;
            },
            child: loginForm.isRegister
              ? SendLoginForm(key: const ValueKey('register_button'), onPressed: () async => sendLoginForm())
              : SendLoginForm(key: const ValueKey('login_button'), onPressed: () async => sendLoginForm()),
          ),

          const SizedBox(height: 10),

          TextButton(
            onPressed: () => loginForm.isRegister = !loginForm.isRegister,
            child:
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 1250),
              layoutBuilder: (currentChild, previousChildren) {
                return currentChild!;
              },
              child: loginForm.isRegister
                ? Text(
                  key: const ValueKey('old_account_text'),
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(color: colors.surface, fontWeight: FontWeight.bold)
                  )
                : Text(
                  key: const ValueKey('new_account_text'),
                  'Crear una nueva cuenta',
                  style: TextStyle(color: colors.surface, fontWeight: FontWeight.bold)
                  ),
            ),
          ),
        ],
      )
    );
  }
}

class LoginTextFormField extends StatelessWidget {
  const LoginTextFormField({
    super.key,
    required this.obscureText,
    this.textInputType,
    this.textInputAction,
    required this.hintText,
    required this.labelText,
    required this.icon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
  });

  final bool obscureText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final String hintText;
  final String labelText;
  final IconData icon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Theme(
      data: AppTheme().getTheme(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: colors.onPrimaryFixedVariant,
        )
      ),
      child: TextFormField(
        obscureText: obscureText,
        cursorErrorColor: colors.onErrorContainer,
        cursorColor: colors.surface,
        style: TextStyle(color: colors.surface),
        keyboardType: textInputType,
        textInputAction: textInputAction,
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
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          labelText: labelText,
          labelStyle: TextStyle(
            color: colors.surface
          ),
          prefixIcon: Icon(icon, color: colors.surface, size: 18),
          errorStyle: TextStyle(color: colors.onErrorContainer),
          suffixIcon: suffixIcon,
        ),
        onChanged: onChanged,
        validator: validator,
        onFieldSubmitted: onFieldSubmitted,
      ),
    );
  }
}

class SendLoginForm extends StatelessWidget {
  const SendLoginForm({super.key, this.onPressed});

  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      child: CustomElevatedButton(
        width: 150,
        onPressed: onPressed,
        label: loginForm.isRegister ? 'Registrar' : 'Ingresar',
        isSendingLabel: loginForm.isRegister ? 'Registrando' : 'Ingresando',
        style: TextStyle(color: colors.primary, fontSize: 16),
      ),
    );
  }
}
