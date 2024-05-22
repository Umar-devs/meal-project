import 'package:flutter/material.dart';
import 'package:meal_project/View/User%20Home%20Screen/Orders%20Screen/orders_screen.dart';
import 'package:meal_project/View/User%20Home%20Screen/Profile/profile_screen.dart';
import 'package:meal_project/View/User%20Home%20Screen/Resturants/resturants.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;
  final List<Widget> _widgetOptions = [
    const OrderScreen(),
    const ResturantHome(),
    const ProfileScreen(),
  ];



  @override
  Widget build(BuildContext context) {
    
    return SafeArea(
      child: Scaffold(
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
                    label: 'Home',
                    icon: Icon(
                      index == 1 ? Icons.home : Icons.home_outlined,
                      color: index == 1 ? Colors.red : Colors.black,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Profile',
                    icon: Icon(
                      index == 2 ? Icons.person : Icons.person_2_outlined,
                      color: index == 2 ? Colors.red : Colors.black,
                    ),
                  ),
                ]),
          ),
          body: _widgetOptions.elementAt(index)),
    );
  }
}
