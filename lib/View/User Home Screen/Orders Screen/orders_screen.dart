import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final CollectionReference restaurants =
      FirebaseFirestore.instance.collection('Resturants');
  Future<List<QueryDocumentSnapshot>> _fetchTableOffers() async {
    QuerySnapshot restaurantSnapshot = await restaurants.get();
    List<QueryDocumentSnapshot> restaurantsWithTableOffers = [];

    for (var restaurant in restaurantSnapshot.docs) {
      CollectionReference tables = restaurant.reference.collection('Tables');
      QuerySnapshot tablesOfferSnapshot = await tables.get();
      if (tablesOfferSnapshot.docs.isNotEmpty &&
          restaurant['bookedBy'] == FirebaseAuth.instance.currentUser!.uid) {
        restaurantsWithTableOffers.add(restaurant);
      }
    }

    return restaurantsWithTableOffers;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(
            backgroundColor: Colors.pink.shade50,
            centerTitle: true,
            title: const Text('My Orders'),
            bottom: const TabBar(
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    child: Text('Active'),
                  ),
                  Tab(
                    child: Text('Completed'),
                  ),
                  Tab(
                    child: Text('Delivered'),
                  ),
                  Tab(
                    child: Text('Table'),
                  ),
                ]),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('status', isEqualTo: 'active')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      var orders = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            var order = orders[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Row(
                                    children: [
                                      Text(
                                        order['name'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '(£${order['price']})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    order['time'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _showStatusDialog(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: const Center(
                                        child: Text(
                                          'view',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Orders'),
                      );
                    }
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('status', isEqualTo: 'completed')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      var orders = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            var order = orders[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Row(
                                    children: [
                                      Text(
                                        order['name'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '(£${order['price']})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    order['time'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _showStatusDialog(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: const Center(
                                        child: Text(
                                          'view',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Orders'),
                      );
                    }
                  }),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .where('status', isEqualTo: 'delivered')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      var orders = snapshot.data!.docs;
                      return ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            var order = orders[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Row(
                                    children: [
                                      Text(
                                        order['name'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '(£${order['price']})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    order['time'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _showRatingDialog(
                                        context,
                                        order['resId'],
                                        order['name'],
                                        order['time'],
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: const Center(
                                        child: Text(
                                          'Rate',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text('No Orders'),
                      );
                    }
                  }),
              FutureBuilder(
                  future: _fetchTableOffers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var table = data[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Card(
                                elevation: 2,
                                color: Colors.white,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  title: Row(
                                    children: [
                                      Text(
                                        table['number'],
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                      Text(
                                        '(£${table['price']})',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    table['position'],
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: 35,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          color: Colors.pink,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      child: const Center(
                                        child: Text(
                                          'booked',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ),
                            );
                          });
                    } else {
                      return Center(
                        child: Text(
                            'No Orders:${FirebaseAuth.instance.currentUser!.uid}'),
                      );
                    }
                  }),
            ],
          ),
        ));
  }

  void _showStatusDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Center(
              child: Text(
            'Welcome!',
            style: TextStyle(fontSize: 18),
          )),
          content: Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0),
            child: Text(
              'Your order status will be updated in real-time. Please check back for updates.',
              textAlign: TextAlign.justify,
            ),
          ),
        );
      },
    );
  }

  void _showRatingDialog(
    BuildContext context,
    String resId,
    String dealName,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var mq = MediaQuery.of(context).size;
        var ratings;
        return AlertDialog(
          content: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9.0),
              child: SizedBox(
                height: mq.height * 0.15,
                child: Column(
                  children: [
                    SizedBox(height: mq.height * 0.025),
                    // Add spacing between text and button
                    // Pink button with fixed size and centered text
                    const Text(
                      'Rate the deal:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.pink,
                              size: 15,
                            ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            ratings = rating;
                          });
                        }),
                    TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('Resturants')
                              .get()
                              .then(
                            (value) {
                              FirebaseFirestore.instance
                                  .collection('Resturants')
                                  .doc(resId)
                                  .collection('Deals')
                                  .where('name', isEqualTo: dealName)
                                  .get()
                                  .then(
                                (value) {
                                  FirebaseFirestore.instance
                                      .collection('Resturants')
                                      .doc(resId)
                                      .collection('Deals')
                                      .doc(value.docs[0].id)
                                      .update({
                                    'rating': value.docs[0]['rating'] + ratings,
                                    'totalRatings':
                                        value.docs[0]['totalRatings'] + 1,
                                    'id': id
                                  });
                                },
                              );
                            },
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Submit'))
                  ],
                ),
              )),
        );
      },
    );
  }
}
