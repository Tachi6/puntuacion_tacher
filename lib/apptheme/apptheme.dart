import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:puntuacion_tacher/apptheme/theme_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeThemeProvider extends ChangeNotifier {

  Color _themeColor = const Color.fromRGBO(149, 4, 43, 1);
  bool _isDarkMode = false;

  List<DropdownMenuEntry<Color>> dropDownThemeEntries() {
    final List<DropdownMenuEntry<Color>> dropDownEntries = [];

    themeColors.forEach((key, value) {
      dropDownEntries.add(DropdownMenuEntry(
        value: key, 
        labelWidget: SizedBox(
          width: 170,
          child: Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: key,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 0.5,
                  )
                )
              ),

              const SizedBox(width: 10),

              Text(value),
            ],
          )),
        label: '',
        leadingIcon: const SizedBox(),
        trailingIcon: const SizedBox(),
      ));
    });

    return dropDownEntries;
  }  

  ChangeThemeProvider() {
    obtainUserTheme();
  }

  setDefaultTheme() {
    _themeColor = const Color.fromRGBO(149, 4, 43, 1);
    _isDarkMode = false;
    notifyListeners();
  }

  obtainUserTheme() async {
    final SharedPreferences themePrefs = await SharedPreferences.getInstance();

    final String? userThemeColor = themePrefs.getString('themeColor');
    final bool? userDarkMode = themePrefs.getBool('darkMode');

    if (userThemeColor != null) {
      final color = themeColors.entries.firstWhere((element) => element.value == userThemeColor).key;

      _themeColor = color;
      notifyListeners();
    }

    if (userDarkMode != null) {
      _isDarkMode = userDarkMode;
      notifyListeners();
    }
  }

  String? getColorName() {
    return themeColors[_themeColor];
  }

  bool get isDarkMode => _isDarkMode;

  setIsDarkMode() async {
    final SharedPreferences themePrefs = await SharedPreferences.getInstance();
    await themePrefs.setBool('darkMode', !_isDarkMode);

    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Color get themeColor => _themeColor;

  setThemeColor(Color color) async {
    final SharedPreferences themePrefs = await SharedPreferences.getInstance();
    final colorName = themeColors[color];

    await themePrefs.setString('themeColor', colorName!);

    _themeColor = color;
    notifyListeners();
  }
}

class AppTheme {

  ThemeData getTheme(BuildContext context) {

    final themeColor = Provider.of<ChangeThemeProvider>(context, listen: true);
    final colors = Theme.of(context).colorScheme;

    return ThemeData(
      colorSchemeSeed: themeColor.themeColor,
      brightness: themeColor.isDarkMode
        ? Brightness.dark
        : Brightness.light,
      appBarTheme: AppBarTheme(
        toolbarHeight: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: themeColor.isDarkMode ? colors.onInverseSurface : colors.onSurface),
        actionsIconTheme: IconThemeData(color: themeColor.isDarkMode ? colors.onInverseSurface : colors.onSurface),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(15)),
        elevation: 2,
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 58,
      ),      // iconTheme: IconThemeData(color: )
    );
  }
}
