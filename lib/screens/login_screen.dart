
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const LoginBackground(LoginForm());
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
 
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.only(bottom: 30),
        alignment: Alignment.bottomCenter,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
              width: size.width * 0.85,
              // height: 320,
              color: redColor().withOpacity(0.8),
              child: ChangeNotifierProvider(
                create: ( _ ) => LoginProvider(),
                child: const CustomLoginForm(),
              )
            ),
          ),
        ),
      )
    );
  }
}

class CustomLoginForm extends StatelessWidget {
  const CustomLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);

    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
              
          const TextFieldForm(),
              
          const SizedBox(height: 20),
              
          const PassFieldForm(),
              
          const SizedBox(height: 30),
              
          const ValidateUserButton(),

          // const SizedBox(height: 10),

          TextButton(
            style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.white10),
            ),
            onPressed: () {
              final newRoute = MaterialPageRoute(
                builder: (context) => const RegisterScreen());
              Navigator.pushReplacement(context, newRoute);
            },
            child: const Text('Crear una nueva cuenta', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
            
        ],
      )
    );
  }
}

class TextFieldForm extends StatelessWidget {
  const TextFieldForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);

    return TextFormField(
      autocorrect: false,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          )
        ),
        hintText: 'tacher@tacher.com',
        hintStyle: TextStyle(color: Colors.white60),
        labelText: 'Correo electrónico',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        prefixIcon: Icon(Icons.alternate_email_outlined, color: Colors.white, size: 18),
        
        
      ),
      onChanged: (value) {
        loginForm.email = value;
      },
      validator: (value) {
        String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp  = RegExp(pattern);

        return regExp.hasMatch(value ?? '')
          ? null
          : 'Formato de correo electrónico no válido';
      },
    );
  }
}

class PassFieldForm extends StatelessWidget {
  const PassFieldForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);

    return TextFormField(
      autocorrect: false,
      obscureText: loginForm.passwordObscure,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
            width: 2,
          )
        ),
        hintText: '******',
        hintStyle: const TextStyle(color: Colors.white60),
        labelText: 'Contraseña',
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white, size: 18),
        suffixIcon: IconButton(
          onPressed: () {
            loginForm.passwordObscure = !loginForm.passwordObscure;
          }, 
          icon: Icon(loginForm.passwordObscure
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
            color: Colors.white, size: 18
          ),
        ),
        
        
      ),
      onChanged: (value) {
        loginForm.password = value;
      },
      validator: (value) {
        if (value != null && value.length >= 6) {
          return null;
        }
        else {
          return 'La contraseña debe tener al menos 6 caracteres';
        }
      },
    );
  }
}

class ValidateUserButton extends StatelessWidget {
  const ValidateUserButton({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginProvider>(context);

    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      disabledColor: Colors.grey,
      elevation: 0,
      color: Colors.white,
      onPressed: loginForm.isLoading ? null : () async {

        FocusScope.of(context).unfocus(); // quitar teclado

        final authService = Provider.of<AuthService>(context, listen: false);

        if ( !loginForm.isValidForm() ) return;

        loginForm.isLoading = true;

        final String? errorMessage = await authService.loginUser(loginForm.email, loginForm.password);

        if (errorMessage == null) {
          if (!context.mounted) return;
            final newRoute = MaterialPageRoute(
                builder: (context) => const HomeScreen());
              Navigator.pushReplacement(context, newRoute);
        }
        else {
          if (!context.mounted) return;
          NotificationsService.showSnackbar(errorMessage, context);
          loginForm.isLoading = false;
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 160,
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Text(
          loginForm.isLoading
          ? 'Ingresando'
          : 'Ingresar',
          style: TextStyle(color: redColor(), fontSize: 16)
        ),
      ),
    );
  }
}
