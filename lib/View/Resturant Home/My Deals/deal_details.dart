import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/Resturant%20Home/My%20Deals/my_deals_screen.dart';

class DealDetailsScreenResturant extends StatefulWidget {
  const DealDetailsScreenResturant(
      {super.key,
      required this.index,
      required this.imgUrl,
      required this.details,
      required this.extras,
      required this.name,
      required this.price,
      required this.rating});
  final int index;
  final String imgUrl;
  final String details;
  final String extras;
  final String name;
  final String price;
  final String rating;
  @override
  State<DealDetailsScreenResturant> createState() =>
      _DealDetailsScreenResturantState();
}

class _DealDetailsScreenResturantState
    extends State<DealDetailsScreenResturant> {
  int _selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: mq.height,
        width: mq.width,
        child: Stack(
          children: [
            BackgroundImg(
              mq: mq,
              widget: widget,
              img: widget.imgUrl,
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.05,
                left: 20,
                child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, FadeRoute(page: const MyResturantDeals())),
                    child:
                        const Icon(Icons.arrow_back_ios, color: Colors.white))),
            Positioned(
              bottom: 0,
              child: FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: Container(
                    height: mq.height * 0.65,
                    width: mq.width,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset: Offset(2, 2))
                        ]),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DetailsTxt(),
                            const SizedBox(
                              height: 20,
                            ),
                            const AboutFood(),
                            const SizedBox(
                              height: 10,
                            ),
                            FoodDetails(details: widget.details),
                            const SizedBox(
                              height: 5,
                            ),
                            const Divider(
                              color: Colors.black12,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RatingBar(
                              rating: widget.rating,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TitleTxt(title: 'Extras'),
                            Text(
                              widget.extras,
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TitleTxt(
                              title: 'Payment Method',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            paymentRadioTile('Cash on Delivery', 1),
                            const SizedBox(
                              height: 15,
                            ),
                            paymentRadioTile('Online Payment', 2),
                            const SizedBox(
                              height: 20,
                            ),
                          ]),
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              child: BottomPayBox(
                mq: mq,
                payment: '${widget.price}£',
                onTap: () {
                  Utils().toastMessage('This is demo page of your deal');
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container paymentRadioTile(String title, int value) {
    return Container(
      color: Colors.pink.shade50,
      child: RadioListTile(
        fillColor: WidgetStateProperty.all(Colors.pink),
        title: Text(title),
        value: value,
        groupValue: _selectedValue,
        onChanged: (value) {
          setState(() {
            _selectedValue = value as int;
            print(value.toString());
          });
        },
      ),
    );
  }
}

class TitleTxt extends StatelessWidget {
  const TitleTxt({
    super.key,
    required this.title,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
    );
  }
}

class DealLocation extends StatelessWidget {
  const DealLocation({super.key, required this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.pin_drop,
          color: Colors.grey,
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          location,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        // Default selected value
      ],
    );
  }
}

class FoodDetails extends StatelessWidget {
  const FoodDetails({
    super.key,
    required this.details,
  });
  final String details;
  @override
  Widget build(BuildContext context) {
    return Text(
      details,
      style: const TextStyle(
        fontSize: 12,
      ),
    );
  }
}

class AboutFood extends StatelessWidget {
  const AboutFood({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'About Food',
      style: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
    );
  }
}

class DetailsTxt extends StatelessWidget {
  const DetailsTxt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
        alignment: Alignment.center,
        child: Text(
          'Deal Details',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ));
  }
}

class BackgroundImg extends StatelessWidget {
  const BackgroundImg({
    super.key,
    required this.mq,
    required this.widget,
    required this.img,
  });

  final Size mq;
  final DealDetailsScreenResturant widget;
  final String img;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Container(
        height: mq.height * 0.5,
        width: mq.width,
        decoration: const BoxDecoration(),
        child: Hero(
          tag: widget.index.toString(),
          child: Image.network(
            img,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.rating,
  });
  final String rating;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Icon(
            i == 4 ? Icons.star_half_rounded : Icons.star_rate,
            color: Colors.red,
            size: 20,
          ),
        Text(
          rating,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
  }
}

class BottomPayBox extends StatelessWidget {
  const BottomPayBox({
    super.key,
    required this.mq,
    required this.payment,
    required this.onTap,
  });

  final Size mq;
  final String payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mq.width * 0.09),
      height: mq.height * 0.09,
      width: mq.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            payment,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(
                  Size(mq.width * 0.28, mq.height * 0.05)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )),
              backgroundColor: WidgetStateProperty.all(Colors.pink),
            ),
            onPressed: onTap,
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 16, // Specify the font size here
                color: Colors.white, // Specify the text color here
              ),
            ),
          ),
        ],
      ),
    );
  }
}
