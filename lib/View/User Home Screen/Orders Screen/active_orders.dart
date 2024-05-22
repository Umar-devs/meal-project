import 'package:flutter/material.dart';
import 'package:meal_project/View/Widgets/order_tile.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context,index){
      return const OrderTile();
    });
  }
}
