import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/View/Auth/Signup%20Screen/sign_up.dart';
import 'package:meal_project/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
 final _emailController=TextEditingController();
 final _passwordController=TextEditingController();

  // Simulate a login function (replace with your authentication logic)


  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff2f1f2),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: mq.height * 0.08,
              left: mq.width * 0.05,
              right: mq.width * 0.05),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: mq.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 88, 77)),
              ),
              SizedBox(
                height: mq.height * 0.025,
              ),
              Lottie.asset('Assets/animations/Animation - 1714117890772.json',
                  width: mq.width * 0.8, height: mq.height * 0.3),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "example@gmail.com",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none, // Remove the border completely
                    // OR (for a cleaner visual effect)
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent, // Make the border invisible
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.red, // Make the border invisible
                      ),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email address";
                  }
                  return null;
                },
              
              ),
              const SizedBox(height: 20.0),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "**********",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none, // Remove the border completely
                    // OR (for a cleaner visual effect)
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent, // Make the border invisible
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.red, // Make the border invisible
                      ),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50.0),
              ElevatedButton(
                onPressed: () {
                 if(_formKey.currentState!.validate()){
                  AuthController().login(_emailController.text, _passwordController.text, context);
                 }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 255, 88, 77), // Use the same app bar color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  fixedSize: Size(mq.width * 0.8, 50),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              SizedBox(height: mq.height * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                    onPressed: () {
                       Navigator.push(
                          context,
                          FadeRoute(
                              page: const SignupPage(),
                            ));
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text("Sign Up"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
