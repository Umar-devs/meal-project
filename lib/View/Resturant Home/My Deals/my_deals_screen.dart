import 'package:flutter/material.dart';

class MyResturantDeals extends StatefulWidget {
  const MyResturantDeals({super.key});

  @override
  State<MyResturantDeals> createState() => _MyResturantDealsState();
}

class _MyResturantDealsState extends State<MyResturantDeals> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
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
              ListView.builder(
                  itemCount: 1,
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
                              backgroundImage:
                                  AssetImage('Assets/images/pizza.jpg'),
                            ),
                          ),
                          SizedBox(
                            width: mq.width * 0.05,
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Neapolitan pizza',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('1 regular Drink'),
                              Text(
                                'only 30\$',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "4.9",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin:
                                    EdgeInsets.only(bottom: mq.height * 0.02),
                                height: mq.height * 0.04,
                                width: mq.width * 0.15,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.shade50)
                                  ],
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.pink.shade50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'View',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
              ListView.builder(
                  itemCount: 1,
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
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#1234',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Advance Payment'),
                              Text(
                                'only 30\$',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Status:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  Text(
                                    "Available",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin:
                                    EdgeInsets.only(bottom: mq.height * 0.02),
                                height: mq.height * 0.04,
                                width: mq.width * 0.15,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.shade50)
                                  ],
                                  color: Colors.pinkAccent,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.pink.shade50),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ],
          )),
    );
  }
}
