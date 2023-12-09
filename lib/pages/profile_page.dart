import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_journal_apps/components/alv_add_button.dart';
import 'package:daily_journal_apps/components/alv_back_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          autofocus: true,
          maxLength: 20,
          maxLines: 1,
          decoration: InputDecoration(hintText: "Enter new $field"),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          AddButton(
            text: "Save",
            onTap: () {
              setState(() {
                Navigator.of(context).pop(newValue);
              });
            },
          ),
          AddButton(
            text: "Cancel",
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser!.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          //shows loading screen
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // if error
          else if (snapshot.hasError) {
            return Text("Error:${snapshot.hasError}");
          }

          // if data received
          else if (snapshot.hasData) {
            Map<String, dynamic>? user = snapshot.data!.data();

            return Column(
              children: [
                const Row(
                  children: [MyBackButton()],
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(
                    Icons.person,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user!['username'],
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  user['email'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Row(
                    children: [
                      Text(
                        "Details",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Username",
                            style: TextStyle(fontSize: 17),
                          ),
                          IconButton(
                              onPressed: () => editField('username'),
                              icon: const Icon(Icons.settings))
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user['username'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          // if data not found or no data
          else {
            return const Text("No data found");
          }
        },
      ),
    );
  }
}
