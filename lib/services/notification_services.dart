import 'package:flutter/material.dart';

import 'package:another_flushbar/flushbar.dart';

class NotificationServices {

  static showSnackbar(String message, BuildContext context) {
    final snackBar = SnackBar(
      padding: const EdgeInsets.symmetric(vertical: 19),
      duration: const Duration(milliseconds: 2500),
      elevation: 1,
      content: Text(
        message.toUpperCase(), 
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showFlushBar(String message, BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final styles = Theme.of(context).textTheme;

    return Material(
      elevation: 1,
      child: Flushbar(
        padding: const EdgeInsets.symmetric(vertical: 19),
        duration:  const Duration(milliseconds: 2500),
        backgroundColor: colors.inverseSurface,
        messageText: Text(
          message.toUpperCase(), 
          textAlign: TextAlign.center,
          style: styles.bodyMedium!.copyWith(color: colors.onInverseSurface),
        ),
      )..show(context),
    );
  }
}