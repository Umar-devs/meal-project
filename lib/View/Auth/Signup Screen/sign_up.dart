import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_project/services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  

  // Simulate a signup function (replace with your authentication logic)

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xfff2f1f2),
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.pink,
                ))),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: mq.width * 0.05,
                  right: mq.width * 0.05,
                ),
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Create your Account",
                        style: TextStyle(
                          fontSize: mq.width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 88, 77),
                        ),
                      ),
                      SizedBox(height: mq.height * 0.02),
                      Lottie.asset(
                        'Assets/animations/Animation - 1714119369012.json',
                        width: mq.width * 0.8,
                        height: mq.height * 0.3,
                      ),
                      const SizedBox(height: 15.0),
                      const SizedBox(height: 15.0),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "example@gmail.com",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border:
                              InputBorder.none, // Remove the border completely
                          // OR (for a cleaner visual effect)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors
                                  .transparent, // Make the border invisible
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.red, // Make the border invisible
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your email";
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
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "***********",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border:
                              InputBorder.none, // Remove the border completely
                          // OR (for a cleaner visual effect)
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors
                                  .transparent, // Make the border invisible
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Colors.red, // Make the border invisible
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      
                      ),
                      SizedBox(height: mq.height * 0.05),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthController().signUp(emailController.text, passwordController.text, context);
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
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ]))));
  }
}
