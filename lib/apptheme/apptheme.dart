
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';

final List<DropdownMenuEntry<Color>> themes = [
  customDropDownEntry(color: const Color.fromRGBO(69, 1, 42, 1), label: 'Violáceo'),
  customDropDownEntry(color: const Color.fromRGBO(87, 12, 53, 1), label: 'Púrpura'),
  customDropDownEntry(color: const Color.fromRGBO(114, 0, 33, 1), label: 'Carmesí'),
  customDropDownEntry(color: const Color.fromRGBO(149, 4, 43, 1), label: 'Cereza'),
  customDropDownEntry(color: const Color.fromRGBO(137, 43, 44, 1), label: 'Teja'),
  customDropDownEntry(color: const Color.fromRGBO(226, 166, 168, 1), label: 'Rosa Frambuesa'),
  customDropDownEntry(color: const Color.fromRGBO(230, 187, 170, 1), label: 'Rosa Franco'),
  customDropDownEntry(color: const Color.fromRGBO(251, 215, 199, 1), label: 'Salmón'),
  customDropDownEntry(color: const Color.fromRGBO(251, 214, 206, 1), label: 'Rosa Claro'),
  customDropDownEntry(color: const Color.fromRGBO(255, 240, 227, 1), label: 'Piel de Cebolla'),
  customDropDownEntry(color: const Color.fromRGBO(232, 206, 132, 1), label: 'Ambar'),
  customDropDownEntry(color: const Color.fromRGBO(245, 226, 158, 1), label: 'Dorado'),
  customDropDownEntry(color: const Color.fromRGBO(255, 249, 223, 1), label: 'Claro'),
  customDropDownEntry(color: const Color.fromRGBO(254, 253, 232, 1), label: 'Pálido'),
  customDropDownEntry(color: const Color.fromRGBO(245, 247, 234, 1), label: 'Verdoso'),
];

DropdownMenuEntry<Color> customDropDownEntry({required Color color, required String label}) {

  // final colors = Theme.of(context).colorScheme;

  return DropdownMenuEntry(
    value: color,
    labelWidget: SizedBox(
      width: 170,
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                width: 0.5,
              )
            )
          ),

          const SizedBox(width: 10),

          Text(label),
        ],
      )),
    label: '',
    leadingIcon: const SizedBox(),
    trailingIcon: const SizedBox(),
  );
}

class ChangeThemeProvider extends ChangeNotifier {

  Color _themeColor = const Color.fromRGBO(149, 4, 43, 1);
  bool _isDarkMode = false;

  Map<Color, String> themeColors = {
    const Color.fromRGBO(69, 1, 42, 1): 'Violáceo',
    const Color.fromRGBO(87, 12, 53, 1): 'Púrpura',
    const Color.fromRGBO(114, 0, 33, 1): 'Carmesí',
    const Color.fromRGBO(149, 4, 43, 1): 'Cereza',
    const Color.fromRGBO(137, 43, 44, 1): 'Teja',
    const Color.fromRGBO(226, 166, 168, 1): 'Rosa Frambuesa',
    const Color.fromRGBO(230, 187, 170, 1): 'Rosa Franco',
    const Color.fromRGBO(251, 215, 199, 1): 'Salmón',
    const Color.fromRGBO(251, 214, 206, 1): 'Rosa Claro',
    const Color.fromRGBO(255, 240, 227, 1): 'Piel de Cebolla',
    const Color.fromRGBO(232, 206, 132, 1): 'Ambar',
    const Color.fromRGBO(245, 226, 158, 1): 'Dorado',
    const Color.fromRGBO(255, 249, 223, 1): 'Claro',
    const Color.fromRGBO(254, 253, 232, 1): 'Pálido',
    const Color.fromRGBO(245, 247, 234, 1): 'Verdoso',
  };

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

    return ThemeData(
      colorSchemeSeed: themeColor.themeColor,
      brightness: themeColor.isDarkMode
        ? Brightness.dark
        : Brightness.light,
      appBarTheme: const AppBarTheme(
        toolbarHeight: 0,
        centerTitle: true,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(15)),
        elevation: 2,
      ),      // iconTheme: IconThemeData(color: )
    );
  }

  static Color primaryRed = redColor();
  static Color primaryWhite = whiteColor();
  static Color primaryRose = roseColor();

  static final ThemeData redWineTheme = ThemeData.light().copyWith(

    // color primario
    primaryColor: primaryRed,

    // appbar theme
    appBarTheme: AppBarTheme(
      backgroundColor: primaryRed,
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 56,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primaryRed,
      selectionColor: redColor().shade100,
      selectionHandleColor: primaryRed,
    ),

    scaffoldBackgroundColor: Colors.white,

    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryRed,
      contentTextStyle: const TextStyle(color: Colors.white),
    )

    // TODO rehacer tema

    // TextFormFields
    //   inputDecorationTheme: const InputDecorationTheme(
    //     floatingLabelStyle: TextStyle(color: primaryRed),
    //     enabledBorder: UnderlineInputBorder(
    //       borderSide: BorderSide(color: primaryRed),
    //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
    //     ),
    //     focusedBorder: UnderlineInputBorder(
    //       borderSide: BorderSide(color: primaryRed),
    //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
    //     ),
    //     border: UnderlineInputBorder(
    //       borderSide: BorderSide(color: primaryRed),
    //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
    //     ),
    //   )
    // );

    // searchBarTheme: SearchBarThemeData(
    //   backgroundColor: MaterialStateProperty.all(redColor())
    // ),

    // searchViewTheme: SearchViewThemeData(
    //   backgroundColor: redColor(),
    // )



        // textbutton theme
  //     textButtonTheme: TextButtonThemeData(
  //       style: TextButton.styleFrom( foregroundColor: primaryRed)
  //     ),

  //       //floatingactionbutton theme
  //     floatingActionButtonTheme: const FloatingActionButtonThemeData(
  //       backgroundColor: primaryRed
  //     ),

  //       // elevatedbuttons
  //     elevatedButtonTheme: ElevatedButtonThemeData(
  //       style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.indigo,
  //           shape: const StadiumBorder(),
  //           elevation: 0
  //         ),
  //     ),

  //     // TextFormFileds
  //     inputDecorationTheme: const InputDecorationTheme(
  //       floatingLabelStyle: TextStyle(color: primaryRed),
  //       enabledBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: primaryRed),
  //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //       ),
  //       focusedBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: primaryRed),
  //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //       ),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), topRight: Radius.circular(10)),
  //       ),
  //     )



  );
}
