import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/View/Resturant%20Home/My%20Deals/deal_details.dart';
import 'package:meal_project/View/Resturant%20Home/resturant_home_screen.dart';

class MyResturantDeals extends StatefulWidget {
  const MyResturantDeals({super.key});

  @override
  State<MyResturantDeals> createState() => _MyResturantDealsState();
}

Future<List<Map<String, dynamic>>> fetchMyDeals() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Resturants')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Deals')
      .get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}
Future<List<Map<String, dynamic>>> fetchMyTables() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('Resturants')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Tables')
      .get();
  return querySnapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}
class _MyResturantDealsState extends State<MyResturantDeals> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(context,FadeRoute(page: const ResturantHomePage()));
              },
            ),
            backgroundColor: Colors.pink.shade50,
            centerTitle: true,
            title: const Text(
              "My Offers",
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
          body: TabBarView(
            children: [
              FutureBuilder(
                  future: fetchMyDeals(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                          snapshot.data![index]['dealImg']),
                                    ),
                                  ),
                                  SizedBox(
                                    width: mq.width * 0.05,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index]['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(snapshot.data![index]['extras']),
                                      Text(
                                        'only ${snapshot.data![index]['price']} GBP',
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
                                            '${snapshot.data![index]['rating'] / snapshot.data![index]['totalRatings']}(${snapshot.data![index]['totalRatings']})',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: mq.width * 0.025,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            FadeRoute(
                                                page:
                                                    DealDetailsScreenResturant(
                                              index: index,
                                              imgUrl: snapshot.data![index]
                                                  ['dealImg'],
                                              details: snapshot.data![index]
                                                  ['details'],
                                              extras: snapshot.data![index]
                                                  ['extras'],
                                              name: snapshot.data![index]
                                                  ['name'],
                                              price: snapshot.data![index]
                                                  ['price'],
                                                  rating:'${snapshot.data![index]['rating'] / snapshot.data![index]['totalRatings']}(${snapshot.data![index]['totalRatings']})',
                                            )));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            bottom: mq.height * 0.02),
                                        height: mq.height * 0.04,
                                        width: mq.width * 0.15,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey.shade50)
                                          ],
                                          color: Colors.pinkAccent,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                        child: Text('No Deals Found'),
                      );
                    }
                  }),
              FutureBuilder(
                future: fetchMyTables(),
                builder: (context,snapshot) {
                 if(snapshot.connectionState == ConnectionState.waiting){
                   return const Center(
                     child: CircularProgressIndicator(),
                   );
                 }else if(!snapshot.hasData){
                   return const Center(
                     child: Text('No Tables Found'),
                   );}
                   else if(snapshot.hasData){
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Table Number: #${snapshot.data![index]['number']}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Payment Type: ${snapshot.data![index]['paymentType']}'),
                                  Text(
                                    'Price/hour:${snapshot.data![index]['price']}',
                                    style: const TextStyle(fontWeight: FontWeight.w400),
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
                                    ],
                                  )
                                ],
                              ),
                              
                            ],
                          ),
                        );
                      });
                
                   }
                   else{
                     return const Center(
                       child: Text('No Tables Found'),
                     );
                   }
                 }
              )
            ],
          )),
    );
  }
}
