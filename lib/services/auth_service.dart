import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/Auth/User%20Type/user_type.dart';
import 'package:meal_project/View/Resturant%20Home/resturant_home_screen.dart';
import 'package:meal_project/View/User%20Home%20Screen/home_screen.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(email, password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await Future.delayed(const Duration(seconds: 2));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, FadeRoute(page: const UserType()));
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  void login(String email, String password, BuildContext context) {
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
     if(email.contains('.res')) {
       Navigator.pushReplacement(context, FadeRoute(page: const ResturantHomePage()));}
       else {
          Navigator.pushReplacement(context, FadeRoute(page: const HomePage()));
       }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
  }
}
