// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:daily_journal_apps/components/alv_add_button.dart';
import 'package:daily_journal_apps/components/alv_textfield.dart';
import 'package:daily_journal_apps/database/firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UpdateDialogBox extends StatefulWidget {
  final String? activityID;
  const UpdateDialogBox({super.key, this.activityID});

  @override
  State<UpdateDialogBox> createState() => _UpdateDialogBoxState();
}

final currentUser = FirebaseAuth.instance.currentUser;

class _UpdateDialogBoxState extends State<UpdateDialogBox> {
  final FirestoreDatabase firestore = FirestoreDatabase();
  final activityController = TextEditingController();
  final descriptionController = TextEditingController();
  final instanceController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String defaultImageUrl = 'No Picture is Here';

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> updateFiles({String? activityID}) async {
    if (activityController.text == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Activity Name Required'),
            content: const Text('Please input the Activity Name'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (instanceController.text == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Instance Name Required'),
            content: const Text('Please input the Instance Name'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (descriptionController.text == "") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Description is Required'),
            content: const Text('Please input the Description Name'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (pickedFile != null) {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);

      try {
        // Show CircularProgressIndicator while uploading file
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Uploading file...'),
                ],
              ),
            );
          },
        );

        await uploadTask.whenComplete(() {});
        final urlDownload = await ref.getDownloadURL();

        defaultImageUrl = urlDownload;
        if (context.mounted) {
          Navigator.pop(context);
        }
        // Store the uploaded image URL
      } catch (error) {
        if (kDebugMode) {
          print("Error uploading file: $error");
        }
        // Handle the error during file upload
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error uploading file: $error'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

// Update Firestore, using the defaultImageUrl if no image was selected
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Uploading file...'),
              ],
            ),
          );
        },
      );

      await firestore.updateAct(
        activityID!,
        activityController.text,
        descriptionController.text,
        instanceController.text,
        defaultImageUrl, // Use the defaultImageUrl as the image URL
        user.email!,
      );

      if (context.mounted) {
        Navigator.pop(context); // Close the UpdateDialogBox
        Navigator.pop(context); // Close the UpdateDialogBox
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error updating with default image URL: $error");
      }
      // Handle the error during update with default image URL
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error updating with default image URL: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: SizedBox(
        width: 400,
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              MyTextField(
                hintText: "New Activity",
                obscureText: false,
                controller: activityController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Name Instance/Division",
                obscureText: false,
                controller: instanceController,
              ),
              const SizedBox(height: 10),
              MyDescriptionTextFIeld(
                hintText: "Description",
                obscureText: false,
                controller: descriptionController,
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                pickedFile != null
                    ? GestureDetector(
                        onTap: selectFile,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Image.file(
                                File(pickedFile!.path!),
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: selectFile,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              width: double.infinity,
                              height: 150,
                              child: const Center(
                                  child: Text("Click to Upload an Image")),
                            ),
                          ),
                        ),
                      ),
              ]),
            ],
          ),
        ),
      ),
      actions: [
        AddButton(
          text: "Update",
          onTap: () => updateFiles(activityID: widget.activityID),
        ),
        AddButton(
          text: "Cancel",
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
