import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_project/View/User%20Home%20Screen/Resturants/order_success.dart';
import 'package:meal_project/services/stripe_payment.dart';

class DealDetailsScreen extends StatefulWidget {
  DealDetailsScreen(
      {super.key,
      required this.index,
      required this.imgUrl,
      required this.details,
      required this.name,
      required this.price,
      required this.id,
      required this.location,
      required this.rating,
      required this.totalRatings});
  final int index;
  final String imgUrl;
  final String details;
  final String name;
  final String price;
  final String id;
  final String location;
  var rating;
  var totalRatings;
  @override
  State<DealDetailsScreen> createState() => _DealDetailsScreenState();
}

class _DealDetailsScreenState extends State<DealDetailsScreen> {
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
                    onTap: () => Navigator.pop(context),
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
                              rating: widget.rating.toStringAsFixed(1),
                              totalRatings: widget.totalRatings.toString(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            DealLocation(
                              location: widget.location,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const PaymentMethodTxt(),
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
                payment: '${widget.price} GBP',
                onTap: () {
                  _selectedValue == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSuccessScreen(
                                    price: widget.price,
                                    name: widget.name,
                                    time: DateTime.now().toString(),
                                    id: widget.id,
                                  ))) // Close current screen by default
                      : PaymentController().makePayment(
                          '${widget.price}00',
                          widget.name,
                          DateTime.now().toString(),
                          widget.id,
                          FirebaseAuth.instance.currentUser!.uid,
                          false,
                          context);
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

class PaymentMethodTxt extends StatelessWidget {
  const PaymentMethodTxt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Payment Method',
      style: TextStyle(
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
        const Text(
          'Located at: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          location,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
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
  final DealDetailsScreen widget;
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
    required this.totalRatings,
  });
  final String rating;
  final String totalRatings;
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          " ($totalRatings)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
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
