import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/User%20Home%20Screen/Resturants/deal_details_screen.dart';
import 'package:meal_project/services/stripe_payment.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({
    super.key,
    required this.resturantId,
    required this.location,
  });
  final String resturantId;
  final String location;
  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  Future<List<Map<String, dynamic>>> fetchMyTables() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Resturants')
        .doc(widget.resturantId)
        .collection('Tables')
        .where('status', isEqualTo: 'available')
        .get();
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  final bool table = true;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    if (kDebugMode) {
      print(widget.resturantId);
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.pink.shade50,
            centerTitle: true,
            title: const Text(
              "Today's Offers",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            bottom: const TabBar(
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    child: Text('Deals'),
                  ),
                  Tab(
                    child: Text('Tables'),
                  ),
                ]),
          ),
          body: TabBarView(children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Resturants')
                    .doc(widget.resturantId)
                    .collection('Deals')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    var deals = snapshot.data!.docs;

                    return ListView.builder(
                        itemCount: deals.length,
                        itemBuilder: (context, index) {
                          var deal = deals[index];
                          var rating = deal['rating'] / deal['totalRatings'];
                          rating = rating.toStringAsFixed(1);
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 30, right: 30),
                            height: mq.height * 0.15,
                            width: mq.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      color: Colors.black12)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: index.toString(),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      deal['dealImg'],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: mq.width * 0.05,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      deal['name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(deal['extras']),
                                    Text(
                                      deal['price'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          '$rating(${deal['totalRatings']})',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DealDetailsScreen(
                                                  index: index,
                                                  imgUrl: deal['dealImg'],
                                                  name: deal['name'],
                                                  details: deal['details'],
                                                  price: deal['price'],
                                                  id: widget.resturantId,
                                                  location: widget.location,
                                                  rating: deal['rating'] /
                                                      deal['totalRatings'],
                                                  totalRatings:
                                                      deal['totalRatings'],
                                                ))),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: mq.height * 0.02),
                                      height: mq.height * 0.04,
                                      width: mq.width * 0.15,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(color: Colors.grey.shade50)
                                        ],
                                        color: Colors.pinkAccent,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.pink.shade50),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text("No Deals Available"),
                    );
                  }
                }),
            FutureBuilder(
                future: fetchMyTables(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: Text('No Tables Found'),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 30, right: 30),
                            height: mq.height * 0.15,
                            width: mq.width * 0.9,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(2, 2),
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                      color: Colors.black12)
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Hero(
                                  tag: index.toString(),
                                  child: const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage(
                                        'Assets/images/restaurant-dining.webp'),
                                  ),
                                ),
                                SizedBox(
                                  width: mq.width * 0.05,
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Table Number: #${snapshot.data![index]['number']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        'Payment Type: ${snapshot.data![index]['paymentType']}'),
                                    Text(
                                      'Price/hour:${snapshot.data![index]['price']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Status:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12),
                                        ),
                                        Text(
                                          snapshot.data![index]['status'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: mq.width * 0.05,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            PaymentController().makePayment(
                                                '${snapshot.data![index]['price']}00',
                                                snapshot.data![index]['number'],
                                                snapshot.data![index]['time'],
                                                widget.resturantId,
                                                FirebaseAuth.instance.currentUser!.uid,
                                                table,
                                                context);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.pinkAccent,
                                                borderRadius:
                                                    BorderRadius.circular(7)),
                                            child: const Text(
                                              'Reserve',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: Text('No Tables Found'),
                    );
                  }
                })
          ])),
    );
  }
}
