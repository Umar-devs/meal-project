import 'package:flutter/material.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/View/Auth/Login%20Screen/login.dart';

class OnBoardingContainer extends StatelessWidget {
  const OnBoardingContainer(
      {super.key,
      required this.img,
      required this.title,
      required this.details,
      this.pageNum = 0});
  final String img;
  final String title;
  final String details;
  final double pageNum;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: mq.height * 0.035,
          bottom: mq.height * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: pageNum != 2
                ? TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: const LoginPage(),
                             ));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                : SizedBox(
                    height: mq.height * 0.05,
                    width: 0,
                  ),
          ),
          SizedBox(
            height: mq.height * 0.05,
          ),
          Center(
            child: Image.asset(
              img,
              height: mq.height * 0.4,
              width: mq.width * 0.7,
            ),
          ),
          SizedBox(
            height: mq.height * 0.06,
          ),
          Center(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          SizedBox(
            height: mq.height * 0.025,
          ),
          Text(
            textAlign: TextAlign.justify,
            details,
          ),
          const Spacer(),
          pageNum == 2
              ? Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          FadeRoute(
                              page: const LoginPage(),
                             ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      fixedSize: const Size(300, 50),
                    ),
                    child: const Text('Proceed',
                        style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                )
        ],
      ),
    );
  }
}
