import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/View/Widgets/on_boarding_container.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
  );
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          //      Positioned(
          //   top: mq.height*0.25,
          //   left: mq.width*0.2,
          //   child: Container(
          //     height: mq.height*0.3,
          //     width: mq.width*0.5,
          //     child: CustomPaint(painter:HeartPainter( Colors.red)),
          //   ),
          // ),
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal, // or Axis.vertical
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const OnBoardingContainer(
                  img: 'Assets/images/onBoard 1.png',
                  title: 'Quality Food',
                  details:
                      "Indulge in our quality cuisine, meticulously prepared with fresh, locally sourced ingredients. Experience culinary excellence with every bite at our establishment.",
                  // pageNum: 0
                ),
              ),
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const OnBoardingContainer(
                  img: 'Assets/images/onBoard 2.png',
                  title: 'Swift Delivery',
                  //  pageNum: _pageController.page!,
                  details:
                      "Efficient Delivery: With our dedicated team and streamlined processes, expect swift service that preserves the delectable flavors and ensures satisfaction with every bite.",
                ),
              ),
              FadeInDown(
                duration: const Duration(milliseconds: 500),
                child: const OnBoardingContainer(
                  img: 'Assets/images/OnBoard 3.png',
                  title: 'Simple Payment',
                  pageNum: 2,
                  details:
                      "Enjoy a seamless transaction experience with our user-friendly payment methods, designed for stress-free convenience, so you can focus on savoring your culinary delight.",
                ),
              ),
            ],
          ),

          Positioned(
            bottom: mq.height * 0.15,
            left: mq.width * 0.4,
            child: Center(
              child: SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  onDotClicked: (index) {
                    _pageController.jumpToPage(index);
                  },
                  effect: WormEffect(
                    activeDotColor: Colors.red,
                    dotColor: Colors.grey.shade400,
                    dotHeight: 14,
                    dotWidth: 14,
                    spacing: 20,
                  )),
            ),
          )
        ],
      ),
    );
  }
}

// class HeartPainter extends CustomPainter {
//   // Color of the heart
//   final Color color;

//   HeartPainter(this.color);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill; // Fill the shape

//     final path = Path();

//     // Define the heart shape using Path methods
//     path.moveTo(size.width * 0.5, size.height * 0.4);
//     path.cubicTo(
//         size.width * 0.2, size.height * 0.1,
//         -size.width * 0.25, size.height * 0.6,
//         size.width * 0.5, size.height);
//     path.moveTo(size.width * 0.5, size.height * 0.4);
//     path.cubicTo(
//         size.width * 0.8, size.height * 0.1,
//         size.width * 1.25, size.height * 0.6,
//         size.width * 0.5, size.height);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
// class MyPainter extends CustomPainter {
//   final Color bodyColor; // The color of the heart
//   final Color borderColor; // The color of the border of the heart
//   final double borderWidth; // The thickness of the border

//   MyPainter(this.bodyColor, this.borderColor, this.borderWidth);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint body = Paint()
//       ..color = bodyColor
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 0;

//     final Paint border = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = borderWidth;

//     final double width = size.width;
//     final double height = size.height;

//     final Path path = Path();
//     path.moveTo(0.5 * width, height * 0.4);
//     path.cubicTo(
//         0.2 * width, height * 0.1, -0.25 * width, height * 0.6, 0.5 * width, height);
//     path.moveTo(0.5 * width, height * 0.4);
//     path.cubicTo(
//         0.8 * width, height * 0.1, 1.25 * width, height * 0.6, 0.5 * width, height);

//     canvas.drawPath(path, body);
//     canvas.drawPath(path, border);
//   }
  
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     throw UnimplementedError();
//   }
// }
