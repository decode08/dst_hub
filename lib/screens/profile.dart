import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  String downloadUrl = "";

  pickImage(ImageSource source) async {
    final imagePicker = await ImagePicker().pickImage(source: source);
    if (imagePicker != null) {
      return await imagePicker.readAsBytes();
    }
    log("No Image Selected");
  }

  void selectImageCam(ImageSource src) async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  Future saved() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance.ref().child("profilePic.png");
    await ref.putFile(_image! as File);
    downloadUrl = await ref.getDownloadURL();
    log(downloadUrl);

    await firebaseFirestore.collection("profilePic").add({
      'name': nameController.text,
      'designation': designationController.text,
      'id': idController.text
    });
  }

  void selectImageGal(ImageSource src) async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveData() {
    if (_formKey.currentState!.validate()) {
      log("Saved Data");
      saved();
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController idController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                          )
                        : CircleAvatar(
                            radius: 65,
                            backgroundImage: NetworkImage(
                                'https://cdn.vectorstock.com/i/1000x1000/53/42/user-member-avatar-face-profile-icon-vector-22965342.webp'),
                          ),
                    Positioned(
                        child: IconButton(
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => Center(
                                      child: Container(
                                        height: 250,
                                        child: AlertDialog(
                                          title: Text("Upload from"),
                                          content: Column(
                                            children: [
                                              GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Camera",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                onTap: () {
                                                  selectImageCam(
                                                      ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              GestureDetector(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    "Gallery",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                onTap: () {
                                                  selectImageGal(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        left: 80)
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: "Name:"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: designationController,
                        decoration: InputDecoration(labelText: "Designation:"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your designation';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: idController,
                        decoration: InputDecoration(labelText: "id:"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your employee id';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton(onPressed: () {}, child: Text("Save"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
