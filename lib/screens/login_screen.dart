import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

// TODO arreglar colores

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

    final loginForm = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // backgroundColor: Colors.transparent,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            layoutBuilder: (currentChild, previousChildren) {
              return currentChild!;
            },
            child: loginForm.isRegister 
              ? const ContainerLoginForm(key: ValueKey<String>('register'))
              : const ContainerLoginForm(key: ValueKey<String>('login')), 
          ),
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
        color: colors.onPrimaryFixedVariant.withOpacity(0.8),
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

    final loginForm = Provider.of<LoginProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final colors = Theme.of(context).colorScheme;

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          loginForm.isRegister 
            ? LoginTextFormField(
              obscureText: false,
              textInputType: TextInputType.text,
              hintText: 'Antonio Gonzalez',
              labelText: 'Nombre de usuario',
              icon: Icons.person_outline_outlined,
              onChanged: (value) => authService.tempDisplayName = value,
              validator: (value) {
                if (value!.length < 4) {
                  return 'El nombre de usuario requiere un mínimo de 3 letras';
                }
                else {
                  return null;
                } 
              },
            ) 
            : const SizedBox(),
    
          loginForm.isRegister 
            ? const SizedBox(height: 20)
            : const SizedBox(),
              
          LoginTextFormField(
            obscureText: false,
            textInputType: TextInputType.emailAddress,
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
                color: Colors.white, size: 18 // TODO style
              ),
            ),
            onChanged: (value) => loginForm.password = value,
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
   
          const ValidateUserButton(),
    
          const SizedBox(height: 10),
    
          TextButton(
            onPressed: () => loginForm.isRegister = !loginForm.isRegister,
            child: Text(
              loginForm.isRegister 
                ? '¿Ya tienes una cuenta?'
                : 'Crear una nueva cuenta', 
              style: TextStyle(color: colors.surface, fontWeight: FontWeight.bold)
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
    required this.hintText, 
    required this.labelText,
    required this.icon,
    this.suffixIcon, 
    this.onChanged, 
    this.validator
  });

  final bool obscureText;
  final TextInputType? textInputType;
  final String hintText;
  final String labelText;
  final IconData icon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Theme(
      data: AppTheme().getTheme(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: colors.onPrimaryFixedVariant, // TODO set color
        )
      ),
      child: TextFormField(
        autocorrect: false,
        enableSuggestions: false,
        obscureText: obscureText,
        cursorErrorColor: colors.onErrorContainer,//setSurfaceColor(context),
        cursorColor: colors.surface,
        style: TextStyle(color: colors.surface),
        keyboardType: textInputType,
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
      ),
    );
  }
}

class ValidateUserButton extends StatelessWidget {
  const ValidateUserButton({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      child: CustomElevatedButton(
        width: 150,
        onPressed: loginForm.isLoading ? null : () async {
      
          FocusScope.of(context).unfocus(); // quitar teclado
      
          final authService = Provider.of<AuthService>(context, listen: false);
      
          if ( !loginForm.isValidForm() ) return;
      
          loginForm.isLoading = true;
      
          final String? errorMessage = await authService.loginUser(loginForm.email, loginForm.password);
      
          if (errorMessage == null) {
            if (!context.mounted) return;
              final newRoute = MaterialPageRoute(
                builder: (context) => const HomeScreen()
              );
              Navigator.pushReplacement(context, newRoute);
              // FOR NOT VIEW 'ingresar' MESSAGE IF THERE ARE A LOGOUT
              Future.delayed(const Duration(seconds: 3), () => loginForm.isLoading = false);
          }
          else {
            if (!context.mounted) return;
            NotificationsService.showSnackbar(errorMessage, context);
            loginForm.isLoading = false;
          }
        },      
        child: Text(
          loginForm.isRegister 
          ? loginForm.isLoading
            ? 'Registrando'
            : 'Registrar'
          : loginForm.isLoading
            ? 'Ingresando'
            : 'Ingresar',
          style: TextStyle(color: colors.primary, fontSize: 16)
        )
      ),
    );
  }
}
