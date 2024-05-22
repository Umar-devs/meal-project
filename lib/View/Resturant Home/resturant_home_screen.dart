import 'package:flutter/material.dart';
import 'package:meal_project/View/Resturant%20Home/Create%20Deal/create_deal.dart';
import 'package:meal_project/View/Resturant%20Home/My%20Deals/my_deals_screen.dart';
import 'package:meal_project/View/User%20Home%20Screen/Orders%20Screen/orders_screen.dart';
import 'package:meal_project/View/User%20Home%20Screen/Profile/profile_screen.dart';

class ResturantHomePage extends StatefulWidget {
  const ResturantHomePage({super.key});

  @override
  State<ResturantHomePage> createState() => _ResturantHomePageState();
}

class _ResturantHomePageState extends State<ResturantHomePage> {
  int index = 1;
  final List<Widget> _widgetOptions = [
    const OrderScreen(),
    const CreateDealScreen(),
    const MyResturantDeals(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor:  const Color(0xfff2f1f2),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: BottomNavigationBar(
                onTap: (value) => {
                      setState(() {
                        index = value;
                      })
                    },
                elevation: 1,
                backgroundColor: Colors.pink.shade50,
                items: [
                  BottomNavigationBarItem(
                    label: 'Orders',
                    icon: Icon(
                      index == 0
                          ? Icons.menu_book_outlined
                          : Icons.menu_book_rounded,
                      color: index == 0 ? Colors.red : Colors.black87,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Create New',
                    icon: Icon(
                      index == 1
                          ? Icons.plus_one_sharp
                          : Icons.plus_one_outlined,
                      color: index == 1 ? Colors.red : Colors.black,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Deals',
                    icon: Icon(
                      index == 2
                          ? Icons.data_object
                          : Icons.data_object_outlined,
                      color: index == 2 ? Colors.red : Colors.black,
                    ),
                  ),
                ]),
          ),
          body: _widgetOptions.elementAt(index)),
    );
  }
}
