import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart ';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meal_project/View/User%20Home%20Screen/home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white, // Set background color
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: mq.height * 0.17,
          ),

          // Lottie animation positioned on top (replace 'assets/lottie.json' with your Lottie file path)
          Lottie.asset('Assets/animations/Animation - 1714903019308.json'),
          SizedBox(height: mq.height * 0.025),
          // Column to stack text and button vertically
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              textAlign: TextAlign.justify,
              'Order confirmed! Your items are on their way. Sit tight and relax knowing that your purchase is in progress.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: mq.height * 0.025),
// Add spacing between text and button
          // Pink button with fixed size and centered text
          const Text(
            'Rate the deal:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: mq.height * 0.01),

          // Pink button with fixed size and centered text

          RatingBar.builder(
            initialRating: 4.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.pink,
              size: 15,
            ),
            onRatingUpdate: (rating) {
              if (kDebugMode) {
                print(rating);
              }
            },
          ),
          SizedBox(
            height: mq.height * 0.05,
          ),
          ElevatedButton(
            onPressed: () {
              // Handle button press action (e.g., navigate to home screen)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const HomePage())); // Close current screen by default
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(200, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              elevation: 3,
              backgroundColor: Colors.pink, // Set button color to pink
            ),
            child: const Text(
              'Back to Home',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
