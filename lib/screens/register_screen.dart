
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
   
  const RegisterScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const LoginBackground(RegisterForm());
  }
}

class RegisterForm extends StatelessWidget {
  const RegisterForm({
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
                child: const CustomRegisterForm(),
              )
            ),
          ),
        ),
      )
    );
  }
}

class CustomRegisterForm extends StatelessWidget {
  const CustomRegisterForm({
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

          _UserFieldForm(),

          const SizedBox(height: 20),
              
          _MailFieldForm(),
              
          const SizedBox(height: 20),
              
          _PassFieldForm(),
              
          const SizedBox(height: 30),
              
          _ValidateUserButton(),

          TextButton(
            style: const ButtonStyle(
              overlayColor: MaterialStatePropertyAll(Colors.white10),
            ),
            onPressed: () {
              final newRoute = MaterialPageRoute(
                builder: (context) => const LoginScreen());
              Navigator.pushReplacement(context, newRoute);
            },
            child: const Text('¿Ya tienes una cuenta?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
            
        ],
      )
    );
  }
}

class _UserFieldForm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return TextFormField(
      autocorrect: false,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.text,
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
        hintText: 'Antonio Gonzalez',
        hintStyle: TextStyle(color: Colors.white60),
        labelText: 'Nombre de usuario',
        labelStyle: TextStyle(
          color: Colors.white
        ),
        prefixIcon: Icon(Icons.person_outline_outlined, color: Colors.white, size: 18),
        
        
      ),
      onChanged: (value) => authService.tempDisplayName = value,
      validator: (value) {
        if (value!.length < 4) {
          return 'El nombre de usuario requiere un mínimo de 3 letras';
        }
        else {
          return null;
        } 
      },
    );
  }
}

class _MailFieldForm extends StatelessWidget {

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

class _PassFieldForm extends StatelessWidget {

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

class _ValidateUserButton extends StatelessWidget {

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

        final String? errorMessage = await authService.createUser(loginForm.email, loginForm.password);

        if (errorMessage == null) {
          await authService.updateUser(authService.tempDisplayName);
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
          ? 'Registrando'
          : 'Registrarse',
          style: TextStyle(color: redColor(), fontSize: 16)
        ),
      ),
    );
  }
}
