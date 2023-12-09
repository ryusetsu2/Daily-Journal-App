import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_journal_apps/components/alv_add_button.dart';
import 'package:daily_journal_apps/components/alv_back_button.dart';
import 'package:daily_journal_apps/components/alv_floating_button.dart';
import 'package:daily_journal_apps/components/alv_update_dialog_box.dart';
import 'package:daily_journal_apps/database/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/alv_list_tile.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({Key? key}) : super(key: key);

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final FirestoreDatabase firestore = FirestoreDatabase();
  final activityController = TextEditingController();
  final descriptionController = TextEditingController();
  final instanceController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  void deleteAlert(String activityID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        // ignore: sized_box_for_whitespace
        content: Container(
          width: 400,
          height: MediaQuery.of(context).size.height / 5,
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                      child: Text(
                    "Are you sure you want to delete?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )),
                ),
              ]),
        ),
        actions: [
          AddButton(
            text: "Delete",
            onTap: () {
              firestore.deleteAct(activityID);
              Navigator.pop(context);
            },
          ),
          AddButton(
            text: "Cancel",
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void updateTask({String? activityID}) {
    showDialog(
      context: context,
      builder: (context) {
        return UpdateDialogBox(activityID: activityID);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const MyFloatingActionButton(),
      body: Column(
        children: [
          const Row(
            children: [MyBackButton()],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestore.getPostsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final posts = snapshot.data!.docs;

                if (snapshot.data == null || posts.isEmpty) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text("No posts. Post something."),
                        ),
                      ),
                    ],
                  );
                }

                List<Widget> listWidgets = [];

                DateTime? previousDate;

                for (int i = 0; i < posts.length; i++) {
                  DocumentSnapshot post = posts[i];
                  String activityID = post.id;
                  Map<String, dynamic> data =
                      (post.data() as Map<String, dynamic>?) ?? {};

                  DateTime timestamp =
                      (data['Timestamp'] as Timestamp?)?.toDate() ??
                          DateTime.now();

                  bool showHeader = i == 0 ||
                      timestamp.year != previousDate!.year ||
                      timestamp.month != previousDate.month ||
                      timestamp.day != previousDate.day;

                  previousDate = timestamp;

                  if (showHeader) {
                    listWidgets.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          DateFormat('dd MMM yyyy').format(timestamp),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }

                  listWidgets.add(
                    GestureDetector(
                      onTap: () {
                        updateTask(activityID: activityID);
                      },
                      child: MyListTile(
                        activityName: data['ActivityName'] ?? '',
                        instance: data['InstanceName'] ?? '',
                        userEmail: data['userEmail'] ?? '',
                        timeStamp: DateFormat('hh:mm:ss a').format(timestamp),
                        description: data['ActivityDescription'] ?? '',
                        image: data['embbedUrl'] == "No Picture is Here"
                            ? "https://www.shutterstock.com/image-vector/no-camera-sign-dont-take-600nw-1274471212.jpg"
                            : data['embbedUrl'],
                        onPressed: () => deleteAlert(activityID),
                      ),
                    ),
                  );
                }

                return ListView(
                  children: listWidgets,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
