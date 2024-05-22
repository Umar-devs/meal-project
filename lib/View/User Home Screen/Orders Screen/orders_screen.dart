import 'package:flutter/material.dart';
import 'package:meal_project/View/User%20Home%20Screen/Orders%20Screen/active_orders.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
      body: const TabBarView(
        children: [
          ActiveOrders(),
          Center(child: Text('Completed Orders')),
          Center(child: Text('Delivered Orders')),
        ],
      ),
   
    ) );
  }
}
