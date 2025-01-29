import 'package:flutter/material.dart';
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

    final authService = Provider.of<AuthServices>(context);  
    final Size size = MediaQuery.of(context).size;
    final colors = Theme.of(context).colorScheme;
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);

    return PopScope(
      canPop: false,
      child: Stack(
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
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus(); // Quitar teclado
                    
                    if (authService.tempDisplayName == authService.userDisplayName) {
                      Navigator.pop(context);
                      return;
                    }

                    if (authService.tempDisplayName == '') {
                      NotificationServices.showSnackbar('NOMBRE DE USUARIO VACIO', context);
                      return;
                    }

                    if (authService.tempDisplayName.trim().length < 4) {
                      NotificationServices.showSnackbar('NOMBRE DE USUARIO MUY CORTO', context);
                      return;
                    }

                    if (await authService.isUniqueDisplayName(authService.tempDisplayName)) {
                      await authService.renameUser(authService.tempDisplayName);
                      if (context.mounted) NotificationServices.showSnackbar('NOMBRE DE USUARIO ACTUALIZADO', context);
                      if (context.mounted) Navigator.pop(context);
                      return;
                    }
                    if (!await authService.isUniqueDisplayName(authService.tempDisplayName)) {
                      if (context.mounted) NotificationServices.showSnackbar('NOMBRE DE USUARIO YA UTILIZADO', context);
                      return;
                    }
                  }, 
                  icon: const Icon(Icons.arrow_back_rounded),
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
      ),
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
  final AuthServices authService;

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
                      authService.userInitial,
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
              : colors.surfaceContainerHighest.withAlpha((255 * 0.6).toInt()),
            shadowColor: colors.shadow,
            elevation: 1,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: size.width * 0.85,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  SettingsOptions(
                    leading: Icons.alternate_email_rounded,
                    title: 'Correo electrónico',
                    content: Text(authService.userEmail, style: const TextStyle(fontSize: 14))
                  ),
                           
                  SettingsOptions(
                    leading: Icons.person_rounded, 
                    title: 'Nombre de usuario', 
                    content: TextFormField(
                      initialValue: authService.userDisplayName,
                      enableInteractiveSelection: false,
                      textAlign: TextAlign.center,
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
                    ),
                  ),
                           
                  SettingsOptions(
                    leading: Icons.image_rounded, 
                    title: 'Imagen de perfil', 
                    content: Row(
                      children: [
                        const SizedBox(width: 6),
              
                        Icon(Icons.upload_file_rounded, color: colors.outline), // TODO cambiar color al implementar
              
                        Expanded(
                          child: TextFormField(
                            initialValue: 'Función no disponible',
                            enabled: false,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            textAlign: TextAlign.center,
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
              
                        Icon(Icons.photo_camera_rounded, color: colors.outline), // TODO cambiar color al implementar
              
                        const SizedBox(width: 6),
                      ],
                    )
                  ),
                           
                  SettingsOptions(
                    leading: Icons.palette_rounded, 
                    title: 'Tema de color',
                    content: DropdownMenu(
                      width: 173,
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
                      leading: Icons.dark_mode_rounded, 
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

    final authService = Provider.of<AuthServices>(context, listen: false);
    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
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
        screenProvider.currentScreen = 0;
        screenProvider.multipleScreen = 0;
        themeColor.setDefaultTheme();
        Navigator.popAndPushNamed(context, 'login');
        authService.logout();
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