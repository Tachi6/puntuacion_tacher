import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/providers/providers.dart';
import 'package:puntuacion_tacher/apptheme/apptheme.dart';
import 'package:puntuacion_tacher/services/services.dart';
import 'package:puntuacion_tacher/widgets/widgets.dart';

class UserSettingsScreen extends StatelessWidget {

  const UserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);   
    final Size size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    return Stack(
      children: [
        const FullScreenBackground(image: 'assets/settings_background.jpg', opacity: 0.54),

        Scaffold(
          appBar: AppBar(
            toolbarHeight: 48,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: themeColor.isDarkMode 
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
            automaticallyImplyLeading: false, 
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                icon: const Icon(Icons.arrow_back_rounded)
              ),
              
              const Spacer(),
              
              IconButton(
                onPressed: () => themeColor.setDefaultTheme(),
                icon: const Icon(Icons.settings_backup_restore_rounded)
              ),
            ]
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: _UserSettingsBody(
              colors: colors, 
              size: size, 
              authService: authService
            )
          ),
        ),
      ],
    );
  }
}

class _UserSettingsBody extends StatelessWidget {
  const _UserSettingsBody({
    required this.colors,
    required this.size,
    required this.authService,
  });

  final ColorScheme colors;
  final Size size;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {

    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
    
    return Container(
      alignment: Alignment.topCenter,
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 48),
          
              Hero(
                tag: 'image_profile',
                child: Material(
                  type: MaterialType.transparency,
                  child: CircleAvatar(
                    backgroundColor: colors.onPrimaryFixedVariant,
                    radius: 80,
                    child: Text(
                      authService.userDisplayName == ''
                        ? authService.userEmail[0].toUpperCase()
                        : authService.userDisplayName[0].toUpperCase(),
                      style: TextStyle(color: colors.surface, fontSize: 100)
                    ),
                  ),
                ),
              ),

              // TODO to change imageprofile???
              const SizedBox(width: 48),
              // IconButton(
              //   onPressed: () {
              //     // TODO change user photo
              //   }, 
              //   icon: const Icon(Icons.edit_rounded))
            ],
          ),
       
          const SizedBox(height: 60),
       
          Material(
            color: themeColor.isDarkMode
              ? colors.surfaceContainerHighest
              : colors.surfaceContainerHighest.withOpacity(0.6),
            shadowColor: colors.shadow,
            elevation: 1,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: size.width * 0.85,
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
                      content: Row(
                        children: [
                          const SizedBox(width: 48),
    
                          Expanded(
                            child: TextFormField(
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
                                authService.isSavingUser = true;
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
                            ),
                          ),
    
                          AnimatedOpacity(
                            opacity: authService.isSavingUser ? 1 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: 
                                authService.isSavingUser  
                                ? () {
                                  if (authService.tempDisplayName.length < 4) {
                                    String error = 'NOMBRE DE USUARIO MUY CORTO';
                                    NotificationsService.showSnackbar(error, context);
                                  }
                                  else if (authService.isValidForm()) {
                                    authService.renameUser(authService.tempDisplayName);
                                    authService.isSavingUser = false;
                                  }
                                } 
                                : null,
                              icon: const Icon(Icons.check_rounded),
                            ),
                          ),
                        ],
                      )
                    ),
                             
                    SettingsOptions(
                      leading: Icons.image_outlined, 
                      title: 'Imagen de perfil', 
                      content: Row(
                        children: [
                          const SizedBox(width: 6),
                
                          Icon(Icons.upload_file_outlined, color: colors.outline), // TODO cambiar color al implementar
                
                          Expanded(
                            child: TextFormField(
                              initialValue: 'Función no disponible',
                              enabled: false,
                              readOnly: true,
                              enableInteractiveSelection: false,
                              textAlign: TextAlign.center,
                              autocorrect: false,
                              enableSuggestions: false,
                              style: TextStyle(fontSize: 14, color: colors.outline),
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
                
                          Icon(Icons.photo_camera_outlined, color: colors.outline), // TODO cambiar color al implementar
                
                          const SizedBox(width: 6),
                        ],
                      )
                    ),
                             
                    SettingsOptions(
                      leading: Icons.palette_outlined, 
                      title: 'Tema de color',
                      content: DropdownMenu(
                        width: 170,
                        label: Center(
                          child: Transform.translate(
                            offset: const Offset(4, 0), 
                            child: Text(themeColor.getColorName()!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14))
                          ),
                        ),
                        initialSelection: themeColor.themeColor,
                        enableSearch: false,
                        enableFilter: false,
                        leadingIcon: const SizedBox(width: 32,), //48
                        textStyle: const TextStyle(fontSize: 14),
                        trailingIcon: const SizedBox(), // 32
                        expandedInsets: const EdgeInsets.all(0),
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(0),
                          isDense: true,
                          isCollapsed: false,
                        ),
                        dropdownMenuEntries: themeColor.dropDownThemeEntries(),
                        menuStyle: MenuStyle(
                          alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, 0.17)
                        ),
                        onSelected: (color) => themeColor.setThemeColor(color!),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => themeColor.setIsDarkMode(),
                      child: SettingsOptions(
                        leading: Icons.dark_mode, 
                        title: 'Modo oscuro',
                        content: Text(
                          themeColor.isDarkMode
                            ? 'Activado'
                            : 'Desactivado', 
                          style: const TextStyle(fontSize: 14)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    
          const SizedBox(height: 20),
    
          const SettingsEndButtons(),
        ],
       ),
    );
  }
}

class SettingsEndButtons extends StatelessWidget {

  const SettingsEndButtons({super.key});

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: false);
    final screenProvider = Provider.of<ScreensProvider>(context, listen: true);

    return CustomElevatedButton(
      width: 135,
      height: 30,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.logout_outlined),
          Text('Logout', style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
        authService.logout();
        screenProvider.currentScreen = 0;
        themeColor.setDefaultTheme();
        final initialRoute = CupertinoPageRoute(
          builder: (context) => const LoginScreen()
        );
        Navigator.push(context, initialRoute);
      },
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

    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(leading),
      
            const SizedBox(width: 8),
            
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
    
        const SizedBox(height: 5),
    
        Material(
          color: colors.surface,
          elevation: 1,
          shadowColor: colors.shadow,
          borderRadius: BorderRadius.circular(9),
          child: Container(
            alignment: Alignment.center,
            width: 300,
            height: 30,
            child: content,
          ),
        ),

        const SizedBox(height: 10),
      ],
    );
  }
}