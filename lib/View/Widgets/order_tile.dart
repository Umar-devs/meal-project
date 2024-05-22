import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 2,
          color: Colors.white,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            title: const Row(
              children: [
                Text(
                  'Deal Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  '(Price)',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            subtitle: const Text(
              '04/09/2022',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
            trailing: Container(
              height: 35,
              width: 80,
              decoration: BoxDecoration(
                  color: Colors.pink, borderRadius: BorderRadius.circular(7)),
              child: const Center(
                child: Text(
                  'Details',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
              ),
            ),
            onTap: () {},
          ),
        ),
      );
  }
}