import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';
import 'package:puntuacion_tacher/screens/screens.dart';
import 'package:puntuacion_tacher/services/services.dart';

class UserSettingsScreen extends StatelessWidget {

  const UserSettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);   
    final Size size = MediaQuery.of(context).size;

    return Container(      
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          opacity: 0.54,
          fit: BoxFit.fitHeight,
          alignment: Alignment.topCenter,
          image: AssetImage('assets/settings_background.jpg'), 
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          alignment: Alignment.bottomCenter,
           child: SingleChildScrollView(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
             
                CircleAvatar(
                backgroundColor: redColor(),
                radius: 80,
                child: const Icon(Icons.person, color: Colors.white, size: 96),
                ),
             
                const SizedBox(height: 50),
             
                Container(
                  // TODO poner style del login
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: redColor()
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: authService.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        SettingsOptions(
                          leading: Icons.alternate_email_outlined,
                          title: 'Correo electrónico',
                          content: Text(authService.userEmail, style: const TextStyle(fontSize: 14))
                        ),
                                 
                        SettingsOptions(
                          leading: Icons.person, 
                          title: 'Nombre de usuario', 
                          content: TextFormField(
                            initialValue: authService.userDisplayName,
                            enableInteractiveSelection: false,
                            textAlign: TextAlign.center,
                            autocorrect: false,
                            enableSuggestions: false,
                            style: const TextStyle(fontSize: 14),
                            decoration: const InputDecoration(
                              isCollapsed: true,
                              border: UnderlineInputBorder(borderSide: BorderSide.none),
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              alignLabelWithHint: true,
                              errorStyle: TextStyle(fontSize: 0),
                            ),
                            onChanged: (value) {
                              authService.tempDisplayName = value;
                            },
                            validator: (value) {
                              if (value == null) {
                                return '';
                              }
                              if (value.length < 3) {
                                return '';
                              }
                              return null;
                            },
                          )
                        ),
                                 
                        SettingsOptions(
                          leading: Icons.image_outlined, 
                          title: 'Imagen de perfil', 
                          content: Row(
                            children: [
                              const SizedBox(width: 6),
                    
                              const Icon(Icons.upload_file_outlined, color: Colors.grey), // TODO cambiar color al implementar
                    
                              Expanded(
                                child: TextFormField(
                                  initialValue: 'Función no disponible',
                                  enabled: false,
                                  readOnly: true,
                                  enableInteractiveSelection: false,
                                  textAlign: TextAlign.center,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    isCollapsed: true,
                                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    alignLabelWithHint: true,
                                  ),
                                  onChanged: (value) {
                                    
                                  },
                                ),
                              ),
                    
                              const Icon(Icons.photo_camera_outlined, color: Colors.grey), // TODO cambiar color al implementar
                    
                              const SizedBox(width: 6),
                            ],
                          )
                        ),
                                 
                        const SettingsOptions(
                          leading: Icons.palette_outlined, 
                          title: 'Tema',
                          content: Text('Red Wine', style: TextStyle(fontSize: 14, color: Colors.grey)), // TODO cambiar color al implementar
                        ),
                    
                        const SettingsEndButtons(),
                      ],
                    ),
                  ),
                ),
              
                SizedBox(height: size.height * 0.04)             
              ],
             ),
           ),
        ),
      ),
    );
  }
}

class SettingsEndButtons extends StatelessWidget {

  const SettingsEndButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    String? error;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(100),
            elevation: 10,
            padding: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: const Color.fromARGB(255, 114, 47, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.save_outlined, color: Colors.white),
              Text('Guardar', style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () {
            if (authService.isValidForm()) {
              authService.updateUser(authService.tempDisplayName);
              Navigator.of(context).pop();
            }
            else {
              if (authService.tempDisplayName.length < 4) {
                error = 'NOMBRE DE USUARIO MUY CORTO';
              }
              
              NotificationsService.showSnackbar(error ?? 'ERROR', context);
            }
          },
        ),
    
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size.fromWidth(100),
            elevation: 10,
            padding: const EdgeInsets.symmetric(vertical: 8),
            backgroundColor: const Color.fromARGB(255, 114, 47, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.logout_outlined, color: Colors.white),
              Text('Logout', style: TextStyle(fontSize: 14, color: Colors.white), textAlign: TextAlign.center),
            ],
          ),
          onPressed: () {
            Navigator.pop(context);
            authService.logout();
            final initialRoute = MaterialPageRoute(
              builder: (context) => const LoginScreen()
            );
            Navigator.push(context, initialRoute);
          },
        ),
      ],
    );
  }
}

class SettingsOptions extends StatelessWidget {

  final IconData leading;
  final String title;
  final Widget content;
  
  const SettingsOptions({
    super.key, 
    required this.leading, 
    required this.title,
    required this.content, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(leading, color: Colors.white),
      
            const SizedBox( width: 8),
            
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
    
        const SizedBox(height: 5),
    
        Container(
          alignment: Alignment.center,
          width: 300,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade500),
            borderRadius: BorderRadius.circular(10), 
            color: Colors.grey.shade50
          ),
          child: content,
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}