import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meal_project/Core/utils.dart';

class CreateDealScreen extends StatefulWidget {
  const CreateDealScreen({super.key});

  @override
  State<CreateDealScreen> createState() => _CreateDealScreenState();
}

class _CreateDealScreenState extends State<CreateDealScreen> {
  final nameController = TextEditingController();
  final extrasController = TextEditingController();
  final priceController = TextEditingController();
  final detailsController = TextEditingController();
  final tableNumberController = TextEditingController();
  final tablePriceController = TextEditingController();
  final tablePositionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKeyTable = GlobalKey<FormState>();
  List<String> options = [
    'Advance',
    'On Spot',
  ];
  String? downloadUrl;
  File? _image;
  Future _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      if (kDebugMode) {
        print('Selected image: ${_image!}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? selectedOption;
    final mq = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.symmetric(
            horizontal: mq.width * 0.05, vertical: mq.height * 0.02),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(
                flex: 3,
              ),
              const Text(
                'Create Deal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _showTableDialog(
                    context,
                    _formKeyTable,
                    selectedOption,
                    tableNumberController,
                    tablePriceController,
                    tablePositionController,
                  );
                },
                child: const Text('Create Table',
                    style: TextStyle(color: Colors.black, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 15.0),
          const TitleTxt(
            title: 'Deal Name',
          ),
          const Spacing(),
          TxtField(
            hint: "Enter Name",
            controller: nameController,
          ),
          const SizedBox(height: 15.0),
          const TitleTxt(
            title: 'Extras',
          ),
          const Spacing(),
          TxtField(
            hint: "Like cold drink, if none type 'none'",
            controller: extrasController,
          ),
          const SizedBox(height: 15.0),
          const TitleTxt(
            title: 'Deal Price',
          ),
          const Spacing(),
          TxtField(
            hint: "Enter Price",
            controller: priceController,
          ),
          const SizedBox(height: 15.0),
          const TitleTxt(
            title: 'Enter Details',
          ),
          const Spacing(),
          DetailsField(
            mq: mq,
            detailsController: detailsController,
          ),
          const SizedBox(height: 30.0),
          ImagePickerRow(
            mq: mq,
            selectedimg: _image,
            onPressed: () {
              _pickImage();
            },
          ),
          const SizedBox(height: 30.0),
          SubmitBtn(
            selectedimg: _image,
            formKey: _formKey,
            nameController: nameController,
            extrasController: extrasController,
            priceController: priceController,
            detailsController: detailsController,
          ),
        ],
      ),
    );
  }

  void _showTableDialog(
    BuildContext context,
    formKey,
    selectedOption,
    TextEditingController tableNumberController,
    TextEditingController tablePriceController,
    TextEditingController tablePositionController,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Enter Credentials',
            style: TextStyle(fontSize: 18),
          )),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Number:'),
                  TxtField(
                      hint: 'Enter Number', controller: tableNumberController),
                  const Text('Price/hour:'),
                  TxtField(
                    controller: tablePriceController,
                    hint: 'Enter Price',
                  ),
                  const Text('Position:'),
                  TxtField(
                    controller: tablePositionController,
                    hint: 'Enter Position',
                  ),
                  const Text('Select Payment:'),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment:',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        DropdownButton<String>(
                          value: selectedOption, // Currently selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue;
                              if (kDebugMode) {
                                print(newValue.toString());
                              }
                            });
                          },
                          items: options
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(selectedOption ?? value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        if (selectedOption == null) {
                          Utils().toastMessage('Select Payment');
                        } else {
                          if (formKey.currentState!.validate()) {
                            final currentUser =
                                FirebaseAuth.instance.currentUser;
                            if (currentUser != null) {
                              String formatDateTime(DateTime dateTime) {
                                final dateFormatter = DateFormat('dd-MM-yyyy');
                                final timeFormatter = DateFormat('h:mm a');

                                String formattedDate =
                                    dateFormatter.format(dateTime);
                                String formattedTime =
                                    timeFormatter.format(dateTime);

                                return '$formattedDate At $formattedTime';
                              }
                              var dateTime=DateTime.now();
                              final ref = FirebaseFirestore.instance
                                  .collection('Resturants')
                                  .doc(currentUser.uid)
                                  .collection('Tables')
                                  .doc(formatDateTime(DateTime.parse(dateTime.toString())));
                              ref.set({
                                'number': tableNumberController.text,
                                'price': tablePriceController.text,
                                'position': tablePositionController.text,
                                'paymentType': 'Advance',
                                'status': 'available',
                                'bookedBy': '',
                                'time': formatDateTime(DateTime.parse(dateTime.toString())),
                              }).then((value) {
                                if (kDebugMode) {
                                  print("Deal Added:${currentUser.uid}");
                                }
                                Utils().toastMessage('success');
                              }).catchError((error) {
                                if (kDebugMode) {
                                  print("Failed to add Deal: $error");
                                }
                              });
                            }
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    super.key,
    required this.selectedimg,
    required GlobalKey<FormState> formKey,
    required this.nameController,
    required this.extrasController,
    required this.priceController,
    required this.detailsController,
  }) : _formKey = formKey;

  final File? selectedimg;
  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController extrasController;
  final TextEditingController priceController;
  final TextEditingController detailsController;

  @override
  Widget build(BuildContext context) {
    Future<void> uploadDeal(
        img, String name, String extras, String price, String details) async {
      if (selectedimg == null) return;

      try {
        String? downloadUrl;
        // Create a reference to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('deals/${DateTime.now().millisecondsSinceEpoch}');
        // Upload the file to Firebase Storage
        final uploadTask = storageRef.putFile(selectedimg!);

        // Wait until the file is uploaded
        await uploadTask;

        // Get the download URL
        downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to Firestore

        if (kDebugMode) {
          print('File uploaded successfully..............$downloadUrl');
        }
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          final ref = FirebaseFirestore.instance
              .collection('Resturants')
              .doc(currentUser.uid)
              .collection('Deals')
              .doc(DateTime.now().toString());
          return ref.set({
            'name': name,
            'extras': extras,
            'price': price,
            'details': details,
            'dealImg': downloadUrl,
            'rating': 0,
            'totalRatings': 0,
          }).then((value) {
            if (kDebugMode) {
              print("Deal Added:${currentUser.uid}");
            }
            Utils().toastMessage('success');
          }).catchError((error) {
            if (kDebugMode) {
              print("Failed to add Deal: $error");
            }
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to upload file:::::::::::$e');
        }
      }
    }

    return ElevatedButton(
      onPressed: () {
        if (selectedimg == null) {
          Utils().toastMessage('Select Image');
        } else {
          if (_formKey.currentState!.validate()) {
            uploadDeal(selectedimg, nameController.text, extrasController.text,
                priceController.text, detailsController.text);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),

        backgroundColor: Colors.pink, // Set width and height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set border radius
        ), // Set button color
      ),
      child: const Text(
        "Submit",
        style: TextStyle(
          color: Colors.white, // Set text color (contrast with background)
        ),
      ),
    );
  }
}

class CreateTable extends StatelessWidget {
  const CreateTable({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        // maximumSize: Size(mq.width * 0.08, 40),
        backgroundColor: Colors.pink, // Set width and height
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set border radius
        ), // Set button color
      ),
      child: const Text(
        "Crate Table",
        style: TextStyle(
          color: Colors.white, // Set text color (contrast with background)
        ),
      ),
    );
  }
}

class ImagePickerRow extends StatelessWidget {
  const ImagePickerRow({
    super.key,
    required this.mq,
    required this.selectedimg,
    required this.onPressed,
  });

  final Size mq;
  final File? selectedimg;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Set border radius
        color: Colors.white, // Set background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          selectedimg == null
              ? CircleAvatar(
                  radius: mq.width * 0.07,
                  child: const Center(
                    child: Text(
                      'Empty',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: mq.width * 0.07,
                  backgroundImage: FileImage(selectedimg!),
                ),
          TitleTxt(
            title: selectedimg == null ? 'Set Deal Image' : 'Selected',
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(mq.width * 0.08, 40),
              backgroundColor: Colors.pink, // Set width and height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Set border radius
              ), // Set button color
            ),
            child: const Text(
              "add",
              style: TextStyle(
                color:
                    Colors.white, // Set text color (contrast with background)
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DetailsField extends StatelessWidget {
  const DetailsField({
    super.key,
    required this.mq,
    required this.detailsController,
  });

  final Size mq;
  final TextEditingController detailsController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: mq.height * 0.15,
      width: mq.width,
      child: TextFormField(
        controller: detailsController,
        expands: true,
        maxLines: null,
        minLines: null,
        keyboardType: TextInputType.emailAddress,
        // style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true, fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none, // Remove the border completely
          // OR (for a cleaner visual effect)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.transparent, // Make the border invisible
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.red, // Make the border invisible
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "This Detail Can't Be Empty";
          }
          return null;
        },
      ),
    );
  }
}

class Spacing extends StatelessWidget {
  const Spacing({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 10,
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
    return Text(title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600));
  }
}

class TxtField extends StatelessWidget {
  const TxtField({
    super.key,
    required this.hint,
    required this.controller,
  });
  final String hint;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      // style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        border: InputBorder.none, // Remove the border completely
        // OR (for a cleaner visual effect)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.transparent, // Make the border invisible
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.red, // Make the border invisible
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This Field Can't Be Empty";
        }
        return null;
      },
    );
  }
}
