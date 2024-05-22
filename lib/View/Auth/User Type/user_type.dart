import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_project/Core/page_transition.dart';
import 'package:meal_project/Core/utils.dart';
import 'package:meal_project/View/Auth/Login%20Screen/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserType extends StatefulWidget {
  const UserType({super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();

  final addressController = TextEditingController();

  final phoneController = TextEditingController();

  final resturantNameController = TextEditingController();

  final resturantAddressController = TextEditingController();
  String? downloadUrl;
  final resturantCategoryController = TextEditingController();
  List<String> options = ['Fast Food', 'Desi Food', 'Bakery', 'Snacks'];
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
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
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
    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Text('Select User Type',
                  style: TextStyle(
                      fontSize: 22.5,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 248, 124, 115)))),
          Lottie.asset(
            'Assets/animations/user type.json',
          ),
          _buildListTile('Customer', 'Register user', Icons.favorite,
              Icons.person, context),
          _buildListTile('Resturant', 'Register resturant', Icons.favorite,
              Icons.place, context),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, IconData icon,
      IconData leadingIcon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: Colors.pink.shade50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: CircleAvatar(
          child: Icon(leadingIcon),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(icon),
        onTap: () {
          title == 'Customer'
              ? _showCustomerDialog(
                  context,
                  formKey,
                  nameController,
                  addressController,
                  phoneController,
                )
              : _showResturantDialog(context, formKey, resturantNameController,
                  resturantAddressController, resturantCategoryController);
        },
      ),
    );
  }

  void _showCustomerDialog(
    BuildContext context,
    formKey,
    nameController,
    addressController,
    phoneController,
  ) {
    Future<void> addUser(String name, String address, String phone) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final docRef =
            FirebaseFirestore.instance.collection('Users').doc(currentUser.uid);
        return docRef.set(
            {'name': name, 'address': address, 'phone': phone}).then((value) {
          if (kDebugMode) {
            print("User Added:${currentUser.uid}");
          }
          Navigator.pushReplacement(
              context, FadeRoute(page: const LoginPage()));
        }).catchError((error) {
          if (kDebugMode) {
            print("Failed to add user: $error");
          }
        });
      }
      // Call the user's CollectionReference to add a new user
    }

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
                const Text('Name:'),
                UserField(
                  controller: nameController,
                  type: 'Name',
                ),
                const Text('Address:'),
                UserField(
                  controller: addressController,
                  type: 'Address',
                ),
                const Text('Phone:'),
                UserField(
                  controller: phoneController,
                  type: 'Phone',
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addUser(nameController.text, addressController.text,
                            phoneController.text);
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

  void _showResturantDialog(BuildContext context, formKey, nameController,
      addressController, categoryController) {
    String? selectedOption; // Initial selected option
    Future<void> addResturant(
        String name, String address, String category) async {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final docRef = FirebaseFirestore.instance
            .collection('Resturants')
            .doc(currentUser.uid);
        return docRef.set({
          'name': name,
          'address': address,
          'category': category,
          'img': downloadUrl
        }).then((value) {
          if (kDebugMode) {
            print("Resturant Added:${currentUser.uid}");
          }
          Navigator.pushReplacement(
              context, FadeRoute(page: const LoginPage()));
        }).catchError((error) {
          if (kDebugMode) {
            print("Failed to add user: $error");
          }
        });
      }
      // Call the user's CollectionReference to add a new user
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        var mq = MediaQuery.of(context).size;

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
                  const Text('Name:'),
                  UserField(
                    controller: nameController,
                    type: 'Name',
                  ),
                  const Text('Address:'),
                  UserField(
                    controller: addressController,
                    type: 'Address',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Category*:'),
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
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: mq.height * 0.01,
                        horizontal: mq.width * 0.05),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius
                      color: Colors.white, // Set background color
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Image',
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _pickImage();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(mq.width * 0.08, 40),
                            backgroundColor:
                                Colors.pink, // Set width and height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Set border radius
                            ), // Set button color
                          ),
                          child: const Text(
                            "add",
                            style: TextStyle(
                              color: Colors
                                  .white, // Set text color (contrast with background)
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        if (selectedOption == null) {
                          Utils().toastMessage('Select Category First');
                        }
                        if (formKey.currentState!.validate() &&
                            selectedOption != null) {
                          _uploadImage(_image).then((value) {
                            addResturant(nameController.text,
                                addressController.text, selectedOption!);
                          });
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

class UserField extends StatelessWidget {
  const UserField({
    super.key,
    required this.controller,
    required this.type,
  });
  final TextEditingController controller;
  final String type;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          hintText: "Enter $type",
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
            return "Please enter your $type";
          }
          return null;
        },
      ),
    );
  }
}
