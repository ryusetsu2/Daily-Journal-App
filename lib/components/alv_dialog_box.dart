import 'dart:io';

import 'package:daily_journal_apps/components/alv_add_button.dart';
import 'package:daily_journal_apps/components/alv_textfield.dart';
import 'package:daily_journal_apps/database/firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  const DialogBox({super.key, required this.onCancel});
  final VoidCallback onCancel;

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  final FirestoreDatabase firestore = FirestoreDatabase();
  final activityController = TextEditingController();
  final descriptionController = TextEditingController();
  final instanceController = TextEditingController();
  final FirestoreDatabase _firestoreService = FirestoreDatabase();
  String defaultImage = 'No Picture is Here';

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> uploadFiles() async {
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
                  Text('Creating Data...'),
                ],
              ),
            );
          },
        );

        await uploadTask.whenComplete(() {});
        final snapshot = await ref.getDownloadURL();
        final urlDownload = snapshot.toString();

        // Determine content type based on file extension
        String contentType = 'application/octet-stream'; // Default content type

        // Get the file extension
        String extension = pickedFile!.name.split('.').last.toLowerCase();

        // Update content type based on file extension
        if (extension == 'jpg' || extension == 'jpeg') {
          contentType = 'image/jpeg';
        } else if (extension == 'png') {
          contentType = 'image/png';
        } // Add more conditions for other file formats if needed

        // Set custom metadata for the uploaded file to make it publicly accessible
        SettableMetadata metadata = SettableMetadata(
            contentType: contentType,
            customMetadata: {'visibility': 'public'} // Set custom metadata
            );
        await ref.updateMetadata(metadata);

        defaultImage = urlDownload;

        // Use the service to add the post to Firestore
        await _firestoreService.addPost(
          activityController.text,
          descriptionController.text,
          instanceController.text,
          urlDownload,
        );
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (error) {
        if (kDebugMode) {
          print("Error uploading file: $error");
        }
        // Handle the error, e.g., show an error message to the user
        // ignore: use_build_context_synchronously
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
    } else {
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
                Text('Creating Data...'),
              ],
            ),
          );
        },
      );
      try {
        await _firestoreService.addPost(
          activityController.text,
          descriptionController.text,
          instanceController.text,
          defaultImage,
        );

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error uploading file: $e");
        }
        // Handle the error, e.g., show an error message to the user
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('Error uploading file: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      // ignore: sized_box_for_whitespace
      content: Container(
        width: 400,
        height: MediaQuery.of(context).size.height / 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // an Activity text field
              const SizedBox(height: 30),
              MyTextField(
                hintText: "New Activity",
                obscureText: false,
                controller: activityController,
              ),

              // an Activity text field
              const SizedBox(height: 10),
              MyTextField(
                hintText: "Name Instance/Division",
                obscureText: false,
                controller: instanceController,
              ),

              // an instance text field
              const SizedBox(height: 10),
              MyDescriptionTextFIeld(
                hintText: "Description",
                obscureText: false,
                controller: descriptionController,
              ),
              // to Import Image
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
          text: "Save",
          onTap: uploadFiles,
        ),

        // cancel button
        AddButton(
          text: "Cancel",
          onTap: widget.onCancel,
        ),
      ],
    );
  }
}
