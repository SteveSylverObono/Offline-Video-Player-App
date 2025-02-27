import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../database/user_db/user_service.dart';
import '../../utility/edit_item.dart';
import '../../utility/uploadImage.dart';

@RoutePage(name: "EditProfileRoute")
class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  late UserServices database;
  String? email;
  String? gender;
  String? userId;
  ImageEditor imageEditor = ImageEditor();
  File? uploadedImage;
  bool isDataLoaded = false;
  String? profile;
  @override
  void initState() {
    super.initState();
    database = UserServices();
    initData();
  }

  Future<void> initData() async {
    email = 'test@example';
    gender = 'Male'; // Default value until fetched
    userId = "user_id"; // Default value until fetched

    setState(() {
      isDataLoaded = true;
    });
  }

  Future<void> uploadImage() async {
    File? imageFile = await imageEditor.uploadImage();
    if (imageFile != null) {
      setState(() {
        uploadedImage = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataLoaded) {
      // Show loading indicator until data is loaded
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.navigate_next),
        ),
        leadingWidth: 80,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                 database.updateUser(
                    profile: uploadedImage, userId: userId.toString());
              },
              style: IconButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                fixedSize: const Size(60, 50),
                elevation: 3,
              ),
              icon: const Icon(Icons.check, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Photo",
                widget: Column(
                  children: [
                    if (uploadedImage != null)
                      ClipOval(
                        child: Image.file(
                          uploadedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (uploadedImage == null)
                      ClipOval(
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: profile == null || profile!.isEmpty
                              ? Icon(Icons.person)
                              : CachedNetworkImage(
                                  imageUrl: profile!,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    TextButton(
                      onPressed: uploadImage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.lightBlueAccent,
                      ),
                      child: const Text("Upload Image"),
                    )
                  ],
                ),
              ),
              EditItem(
                title: "Name",
                widget: const TextField(),
              ),
              const SizedBox(height: 40),
              EditItem(
                title: "Gender",
                widget: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "Male";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "Male"
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: const Icon(
                        Icons.male,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gender = "Female";
                        });
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: gender == "Female"
                            ? Colors.deepPurple
                            : Colors.grey.shade200,
                        fixedSize: const Size(50, 50),
                      ),
                      icon: const Icon(
                        Icons.female,
                        color: Colors.white,
                        size: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const EditItem(
                widget: TextField(),
                title: "Age",
              ),
              const SizedBox(height: 40),
              EditItem(title: "Email", widget: Text(email.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
