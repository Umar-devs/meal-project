import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/Auth/Login%20Screen/login.dart';

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

  Future<void> _uploadImage(img) async {
    if (_image == null) return;

    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('deals/${DateTime.now().millisecondsSinceEpoch}');
      // Upload the file to Firebase Storage
      final uploadTask = storageRef.putFile(_image!);

      // Wait until the file is uploaded
      await uploadTask;

      // Get the download URL
      downloadUrl = await storageRef.getDownloadURL();

      // Save the download URL to Firestore

      if (kDebugMode) {
        print(
            'File uploaded successfully...............................................');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to upload file::::::::::::::::::::::::::::::::::::: $e');
      }
    }
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
            url: downloadUrl??'none',
            upload: _uploadImage(_image),
          ),
        ],
      ),
    );
  }

  void _showTableDialog(
    BuildContext context,
    formKey,
    selectedOption,
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
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Number:'),
                TxtField(
                    hint: 'Enter Number', controller: tableNumberController),
                const Text('Price:'),
                TxtField(
                  controller: tablePriceController,
                  hint: 'Enter Price',
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
                          if (kDebugMode) {
                            print('Form Submitted');
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
    required this.url,
    required this.upload,
  }) : _formKey = formKey;

  final File? selectedimg;
  final GlobalKey<FormState> _formKey;
  final TextEditingController nameController;
  final TextEditingController extrasController;
  final TextEditingController priceController;
  final TextEditingController detailsController;
  final String url;
  final Future<void> upload;

  @override
  Widget build(BuildContext context) {
    Future<void> addDeal(
        String name, String extras, String price, String details) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final ref = FirebaseFirestore.instance
            .collection('Resturants')
            .doc(currentUser.uid)
            .collection('Deals').doc(DateTime.now().toString());
        return ref.set({
          'name': name,
          'extras': extras,
          'price': price,
          'details': details,
          'dealImg': url
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
      // Call the user's CollectionReference to add a new user
    }

    return ElevatedButton(
      onPressed: () {
        if (selectedimg == null) {
          Utils().toastMessage('Select Image');
        } else {
          if (_formKey.currentState!.validate()) {
            upload.then((value) => addDeal(
                nameController.text,
                extrasController.text,
                priceController.text,
                detailsController.text));
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
