
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Utils{
   void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor:Colors.white,
        backgroundColor: const Color(0xff02348a),
        fontSize: 16.0
    );
  }
}