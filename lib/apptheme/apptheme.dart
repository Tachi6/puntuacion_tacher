
import 'package:flutter/material.dart';

import 'package:puntuacion_tacher/apptheme/colors.dart';

class AppTheme {

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