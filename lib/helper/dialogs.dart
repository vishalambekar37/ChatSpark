// import 'dart:ffi';
// import 'dart:js';
//********this file for if internet is not work then it show check internet  */
import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Color.fromARGB(255, 64, 235, 248),
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}

//static mean which will call by any class.