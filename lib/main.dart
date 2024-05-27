import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:meal_project/View/OnBoardingScreen/on_boarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDgcUBrA39JfY6KAk1xLrdRtZIpudCZVAA",
      appId: "1:924580058622:android:23db70bd73d31b8b725caf",
      messagingSenderId: '924580058622',
      storageBucket: 'meal-project-30c6e.appspot.com',
      projectId: 'meal-project-30c6e', 
    ),
  );
  Stripe.publishableKey =
      'pk_test_51PD3Ed01S11KKkLetrm1jca4q47fZwYDDHTm1VCTFL9zzKqpjHgBIvfxz0himBsfJV1CA5w0Vpd7K1obp4LJYis800d32AM3AR';
  await dotenv.load(fileName: 'Assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // home: UserType()
        home: OnBoardingScreen(),
        // home: HomePage(),
        // HomePage(),
        );
  }
}
