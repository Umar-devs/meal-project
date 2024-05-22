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
    'Fast Food',
    'Desi Food',
    'Bakery',
    'Snacks',
  ];
  final List assetNames = [
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
                    CategoriesCirclesWithTitles(
                        mq: mq,
                        assetNames: assetNames,
                        categories: categories,
                        ind: selectedIndex),

                    //Resturants text row
                    ResturantsRow(mq: mq),
                    // Resturants Boxes
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 5, right: 5),
                      child: SizedBox(
                          height: mq.height * 0.5,
                          width: mq.width,
                          child: GridView.count(
                            physics: const BouncingScrollPhysics(),
                            crossAxisCount: 2,
                            children: List.generate(10, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const DealsScreen()));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
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
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            height:
                                                constraints.maxHeight * 0.75,
                                            width: constraints.maxWidth,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'Assets/images/resturant logo.jpg'),
                                                    fit: BoxFit.fill))),
                                        const Text('Resturant Name'),
                                        SizedBox(
                                          height: constraints.maxHeight * 0.001,
                                        )
                                      ],
                                    );
                                  }),
                                ),
                              );
                            }),
                          )),
                    ),
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

class CategoriesCirclesWithTitles extends StatefulWidget {
  CategoriesCirclesWithTitles({
    super.key,
    required this.mq,
    required this.assetNames,
    required this.categories,
    required this.ind,
  });

  final Size mq;
  final List assetNames;
  final List<String> categories;
  int ind;

  @override
  State<CategoriesCirclesWithTitles> createState() =>
      _CategoriesCirclesWithTitlesState();
}

class _CategoriesCirclesWithTitlesState
    extends State<CategoriesCirclesWithTitles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        height: widget.mq.height * 0.135,
        width: widget.mq.width,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => setState(() {
                  widget.ind = index;
                }),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: widget.ind == index
                          ? MediaQuery.of(context).size.width * 0.2
                          : MediaQuery.of(context).size.width * 0.19,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 163, 190),
                        border: Border.all(
                            color: widget.ind == index
                                ? Colors.red
                                : Colors.transparent,
                            width: 2),
                        image: DecorationImage(
                            image: AssetImage(widget.assetNames[index])),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.categories[index],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: widget.ind == index ? 13 : 12,
                          fontWeight: widget.ind == index
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
            itemCount: widget.categories.length),
      ),
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
