import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_journal_apps/components/alv_button.dart';
import 'package:daily_journal_apps/components/alv_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String checkIn = "--:--";
  String checkOut = "--:--";
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    _getRecord();
  }

  void reloadData() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .where('email', isEqualTo: user.email)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Attendance")
          .doc(snap.docs[0].id)
          .collection("Attendance_Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkOut = "--:--";
        checkIn = "--:--";
      });
    }
  }

  void _getRecord() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("Users")
          .where('email', isEqualTo: user.email)
          .get();

      DocumentSnapshot snap2 = await FirebaseFirestore.instance
          .collection("Attendance")
          .doc(snap.docs[0].id)
          .collection("Attendance_Record")
          .doc(DateFormat('dd MMMM yyyy').format(DateTime.now()))
          .get();

      setState(() {
        checkIn = snap2['checkIn'];
        checkOut = snap2['checkOut'];
      });
    } catch (e) {
      setState(() {
        checkOut = "--:--";
      });
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AlvDrawer(),
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: reloadData, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<DocumentSnapshot>(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Text('No data found');
              }

              final username = snapshot.data!.get('username');

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Welcome, $username",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              user.email!,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 133, 131, 131),
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      "Today's Status",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  Container(
                    height: 150,
                    margin: const EdgeInsets.only(top: 20, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(44, 0, 0, 0),
                          blurRadius: 10,
                          offset: Offset(2, 6),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "CHECK IN",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                checkIn,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "CHECK OUT",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                checkOut,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: DateTime.now().day.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: DateFormat(' MMMM yyyy').format(
                              DateTime.now(),
                            ),
                            style: const TextStyle(
                              color: Color.fromARGB(255, 77, 77, 77),
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder(
                      stream: Stream.periodic(const Duration(seconds: 1)),
                      builder: (context, snapshot) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DateFormat('hh:mm:ss a').format(
                              DateTime.now(),
                            ),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 61, 61, 61)),
                          ),
                        );
                      }),
                  checkOut == "--:--"
                      ? Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: checkIn == "--:--"
                              ? MyButtons(
                                  text: "Tap to CHECK IN",
                                  color: Theme.of(context).colorScheme.primary,
                                  textColor: Colors.black,
                                  onTap: () async {
                                    QuerySnapshot snap = await FirebaseFirestore
                                        .instance
                                        .collection("Users")
                                        .where('email', isEqualTo: user.email)
                                        .get();

                                    DocumentSnapshot snap2 =
                                        await FirebaseFirestore
                                            .instance
                                            .collection("Attendance")
                                            .doc(snap.docs[0].id)
                                            .collection("Attendance_Record")
                                            .doc(DateFormat('dd MMMM yyyy')
                                                .format(DateTime.now()))
                                            .get();
                                    try {
                                      String checkIn = snap2['checkIn'];

                                      setState(() {
                                        checkOut = DateFormat('hh:mm')
                                            .format(DateTime.now());
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(snap.docs[0].id)
                                          .collection("Attendance_Record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                              .format(DateTime.now()))
                                          .update({
                                        'timeStamp': Timestamp.now(),
                                        'checkIn': checkIn,
                                        'checkOut': DateFormat('hh:mm a')
                                            .format(DateTime.now())
                                      });
                                    } catch (e) {
                                      setState(() {
                                        checkIn = DateFormat('hh:mm')
                                            .format(DateTime.now());
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(snap.docs[0].id)
                                          .collection("Attendance_Record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                              .format(DateTime.now()))
                                          .set({
                                        'timeStamp': Timestamp.now(),
                                        'checkIn': DateFormat('hh:mm a')
                                            .format(DateTime.now()),
                                      });
                                    }
                                  },
                                )
                              : MyButtons(
                                  text: "CHECK OUT",
                                  color: const Color.fromARGB(255, 212, 20, 6),
                                  textColor: Colors.white,
                                  onTap: () async {
                                    QuerySnapshot snap = await FirebaseFirestore
                                        .instance
                                        .collection("Users")
                                        .where('email', isEqualTo: user.email)
                                        .get();

                                    DocumentSnapshot snap2 =
                                        await FirebaseFirestore
                                            .instance
                                            .collection("Attendance")
                                            .doc(snap.docs[0].id)
                                            .collection("Attendance_Record")
                                            .doc(DateFormat('dd MMMM yyyy')
                                                .format(DateTime.now()))
                                            .get();
                                    try {
                                      String checkIn = snap2['checkIn'];

                                      setState(() {
                                        checkOut = DateFormat('hh:mm')
                                            .format(DateTime.now());
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(snap.docs[0].id)
                                          .collection("Attendance_Record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                              .format(DateTime.now()))
                                          .update({
                                        'timeStamp': Timestamp.now(),
                                        'checkIn': checkIn,
                                        'checkOut': DateFormat('hh:mm a')
                                            .format(DateTime.now())
                                      });
                                    } catch (e) {
                                      setState(() {
                                        checkIn = DateFormat('hh:mm')
                                            .format(DateTime.now());
                                      });

                                      await FirebaseFirestore.instance
                                          .collection("Attendance")
                                          .doc(snap.docs[0].id)
                                          .collection("Attendance_Record")
                                          .doc(DateFormat('dd MMMM yyyy')
                                              .format(DateTime.now()))
                                          .set({
                                        'timeStamp': Timestamp.now(),
                                        'checkIn': DateFormat('hh:mm a')
                                            .format(DateTime.now())
                                      });
                                    }
                                  }),
                        )
                      : Container(
                          margin: const EdgeInsets.only(top: 100),
                          child: const Text(
                            "You Already Checked Out",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
