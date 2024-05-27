import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart ';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:meal_project/View/User%20Home%20Screen/home_screen.dart';
import 'package:intl/intl.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen(
      {super.key,
      required this.price,
      required this.name,
      required this.time,
      required this.id});
  final String price;
  final String name;
  final String time;
  final String id;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  @override
  void initState() {
    String formatDateTime(DateTime dateTime) {
      final dateFormatter = DateFormat('dd-MM-yyyy');
      final timeFormatter = DateFormat('h:mm a');

      String formattedDate = dateFormatter.format(dateTime);
      String formattedTime = timeFormatter.format(dateTime);

      return '$formattedDate At $formattedTime';
    }

    FirebaseFirestore.instance.collection('Orders').doc(formatDateTime(DateTime.parse(widget.time))).set({
      'price': widget.price,
      'name': widget.name,
      'time': formatDateTime(DateTime.parse(widget.time)),
      'resId': widget.id,
      'userId': FirebaseAuth.instance.currentUser!.uid.toString(),
      'status': 'active',
      'rating': 0,
    });

    super.initState();
  }

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
