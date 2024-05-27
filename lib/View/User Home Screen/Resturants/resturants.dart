import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/View/User%20Home%20Screen/Resturants/deals_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ResturantHome extends StatefulWidget {
  const ResturantHome({super.key});

  @override
  State<ResturantHome> createState() => _ResturantHomeState();
}

class _ResturantHomeState extends State<ResturantHome> {
  final List<String> categories = [
    'All',
    'Fast Food',
    'Desi Food',
    'Bakery',
    'Snacks',
  ];
  final List assetNames = [
    'Assets/images/all.png',
    'Assets/images/fast food (2).png',
    'Assets/images/desi_food.png',
    'Assets/images/bakery.png',
    'Assets/images/snacks.png',
  ];
  Future<Map<String, dynamic>?> fetchUserData() async {
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

  Position? position;
  Future<void> getMyLocation() async {
    Geolocator.checkPermission();
    Geolocator.requestPermission();
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (kDebugMode) {
      print('position: $position');
    }
    // Use latitude and longitude for geocoding
  }

  Future<Placemark?> getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        // Build the address string from relevant components
        if (kDebugMode) {
          print("Country:${placemark.country}");
        }
        return placemark;
      } else {
        return null; // No address found
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching address: $e');
      }
      return null; // Handle exceptions gracefully
    }
  }

  Placemark? _placemark;

  @override
  void initState() {
    super.initState();
    getMyLocation().then((value) {
      getAddressFromLatLng().then((value) {
        setState(() {
          _placemark = value!;
        });
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchResturants() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Resturants').get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
            right: -30,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(painter: CurvePainter()),
            )),
        FutureBuilder(
            future: fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return ListView(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  children: [
                    //Top Row
                    UserProfileTopRow(
                      name: snapshot.data!['name'],
                      loc: '${_placemark?.locality}, ${_placemark?.country}',
                    ),
                    //search box
                    SearchBar(mq: mq),

                    //Categories text row
                    CategoriesTxtRow(mq: mq),
                    // Categories Circles
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: SizedBox(
                        height: mq.height * 0.135,
                        width: mq.width,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () => setState(() {
                                  selectedIndex = index;
                                }),
                                child: Column(
                                  children: [
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: selectedIndex == index
                                          ? MediaQuery.of(context).size.width *
                                              0.2
                                          : MediaQuery.of(context).size.width *
                                              0.19,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 245, 163, 190),
                                        border: Border.all(
                                            color: selectedIndex == index
                                                ? Colors.red
                                                : Colors.transparent,
                                            width: 2),
                                        image: DecorationImage(
                                            image:
                                                AssetImage(assetNames[index]),
                                            fit: BoxFit.cover),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      categories[index],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              selectedIndex == index ? 13 : 12,
                                          fontWeight: selectedIndex == index
                                              ? FontWeight.bold
                                              : FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                width: 15,
                              );
                            },
                            itemCount: categories.length),
                      ),
                    ),

                    //Resturants text row
                    ResturantsRow(mq: mq),
                    // Resturants Boxes
                    StreamBuilder(
                        stream: selectedIndex == 0
                            ? FirebaseFirestore.instance
                                .collection('Resturants')
                                .snapshots()
                            : FirebaseFirestore.instance
                                .collection('Resturants')
                                .where('category',
                                    isEqualTo: categories[selectedIndex])
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            var resturants = snapshot.data!.docs;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 5, right: 5),
                              child: SizedBox(
                                  height: mq.height * 0.5,
                                  width: mq.width,
                                  child: GridView.count(
                                    physics: const BouncingScrollPhysics(),
                                    crossAxisCount: 2,
                                    children: List.generate(resturants.length,
                                        (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DealsScreen(
                                                          resturantId:
                                                              resturants[index]
                                                                  .id,
                                                          location: resturants[
                                                                  index]
                                                              ['address'])));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(2, 2),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                )
                                              ]),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 10),
                                          child: LayoutBuilder(
                                              builder: (context, constraints) {
                                            var resturant = resturants[index];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    height:
                                                        constraints.maxHeight *
                                                            0.75,
                                                    width: constraints.maxWidth,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                resturant[
                                                                    'img']),
                                                            fit:
                                                                BoxFit.cover))),
                                                Text(
                                                  resturant['name'],
                                                  style: const TextStyle(
                                                      fontSize: 15),
                                                ),
                                                SizedBox(
                                                  height:
                                                      constraints.maxHeight *
                                                          0.001,
                                                )
                                              ],
                                            );
                                          }),
                                        ),
                                      );
                                    }),
                                  )),
                            );
                          }else if(!snapshot.hasData){
                            return const Center(
                              child: Text('No Resturants'),
                            );
                          } else {
                            return const Center(
                              child: Text('Error'),
                            );
                          }
                        })
                  ],
                );
              } else {
                return const Center(
                  child: Text('Error'),
                );
              }
            }),
      ],
    );
  }
}

class ResturantsRow extends StatelessWidget {
  const ResturantsRow({
    super.key,
    required this.mq,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Resturants',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            fixedSize: Size(mq.width * 0.225, 10),
            elevation: 5,
          ),
          child: Center(
            child: Text(
              'See All',
              style:
                  TextStyle(color: Colors.white, fontSize: mq.width * 0.0325),
            ),
          ),
        )
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    required this.mq,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: mq.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 1),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: mq.width * 0.6,
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for Food',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                ),
              )),
          const Icon(Icons.search),
        ],
      ),
    );
  }
}

class UserProfileTopRow extends StatelessWidget {
  const UserProfileTopRow({
    super.key,
    required this.name,
    required this.loc,
  });
  final String name;
  final String loc;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(Icons.menu),
        Text('🌍 $loc'),
        GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            backgroundColor: Colors.red.shade300,
            child: Center(
              child: Text(name[0].toUpperCase()),
            ),
          ),
        )
      ],
    );
  }
}

class CategoriesTxtRow extends StatelessWidget {
  const CategoriesTxtRow({
    super.key,
    required this.mq,
  });

  final Size mq;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            fixedSize: Size(mq.width * 0.225, 10),
            elevation: 5,
          ),
          child: Center(
            child: Text(
              'See All',
              style:
                  TextStyle(color: Colors.white, fontSize: mq.width * 0.0325),
            ),
          ),
        )
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.pink.shade50;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width / 1.1, size.height * 1.1,
        size.width / 1.38, size.height / 1.07);
    path.quadraticBezierTo(
        size.width / 4, size.height / 1.8, size.width / 1.8, 0);
    path.lineTo(size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
