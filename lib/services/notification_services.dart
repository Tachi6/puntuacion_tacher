import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

class NotificationServices {

  static showSnackbar(String message, BuildContext context) {
    
    final colors = Theme.of(context).colorScheme;
    
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 19),
      duration: const Duration(milliseconds: 1500),
      elevation: 1,
      backgroundColor: colors.onErrorContainer,
      content: Text(
        message.toUpperCase(), 
        textAlign: TextAlign.center,
        style: TextStyle(color: colors.onError),
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showFlushBar(String message, BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    return Material(
      elevation: 1,
      child: Flushbar(
        padding: const EdgeInsets.symmetric(vertical: 19),
        duration:  const Duration(milliseconds: 1500),
        backgroundColor: colors.onErrorContainer,
        messageText: Text(
          message.toUpperCase(), 
          textAlign: TextAlign.center,
          style: TextStyle(color: colors.onError),
        ),
      )..show(context),
    );
  }
}