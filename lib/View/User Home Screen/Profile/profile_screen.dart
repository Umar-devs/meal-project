import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/View/Auth/Login%20Screen/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<Map<String, dynamic>?> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final db = FirebaseFirestore.instance;
      final docRef = db.collection('Users').doc(currentUser.uid);
      final snapshot = await docRef.get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null; // Handle the case where no data is found for the user
      }
    } else {
      return null; // Handle the case where there's no current user logged in
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Profile Screen',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.pink.shade400,
                    child: Center(
                      child: Text(
                        snapshot.data!['name'][0].toString().toUpperCase(),
                        style:
                            const TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                  ),
                  const Text('Name Avatar'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!['name'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!['phone'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!['address'],
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) =>
                          Navigator.pushReplacement(
                              context, FadeRoute(page: const LoginPage())));
                    },
                    style: ButtonStyle(
                      fixedSize:
                          MaterialStateProperty.all<Size>(const Size(100, 45)),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.pink),
                    ),
                    child: const Center(
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        });
  }
}
