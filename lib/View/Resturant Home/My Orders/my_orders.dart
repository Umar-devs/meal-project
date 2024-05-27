import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/utils.dart';

class ResturantOrderScreen extends StatefulWidget {
  const ResturantOrderScreen({super.key});

  @override
  State<ResturantOrderScreen> createState() => _ResturantOrderScreenState();
}

class _ResturantOrderScreenState extends State<ResturantOrderScreen> {
  final List<String> _status = ['active', 'completed', 'delivered'];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
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
                ]),
          ),
          body: TabBarView(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Orders')
                      .where('resId',
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
                                      _showStatusDialog(
                                          context, order['status'], order.id);
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
                                          'update',
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
                      .where('resId',
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
                                      _showStatusDialog(
                                          context, order['status'], order.id);
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
                                          'update',
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
                      .where('resId',
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
                                      _showStatusDialog(
                                          context, order['status'], order.id);
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
                                          'update',
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
            ],
          ),
        ));
  }

  void _showStatusDialog(
    BuildContext context,
    String status,
    String index,
  ) {
    String? selectedOption;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Update Status',
            style: TextStyle(fontSize: 18),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Current Status:'),
                  const Spacer(),
                  Text("'$status'"),
                ],
              ),
              Row(
                children: [
                  const Text('Select Status:'),
                  const Spacer(),
                  DropdownButton<String>(
                    value: selectedOption, // Currently selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedOption = newValue;
                        if (kDebugMode) {
                          print(newValue.toString());
                        }
                      });
                    },
                    items:
                        _status.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(selectedOption ?? value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    try {
                      FirebaseFirestore.instance
                          .collection('Orders')
                          .doc(index)
                          .update({'status': selectedOption});
                      Navigator.pop(context);
                    } catch (e) {
                      Utils().toastMessage(e.toString());
                    }
                  },
                  child: const Text('Submit'),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
