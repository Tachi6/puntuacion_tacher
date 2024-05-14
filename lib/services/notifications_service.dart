
import 'package:flutter/material.dart';

class NotificationsService {

  // static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, BuildContext context) {

    final snackBar = SnackBar(
      content: Text(
        message.toUpperCase(), 
        textAlign: TextAlign.center,
      )    
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // messengerKey.currentState!.showSnackBar(snackBar);
  }

}