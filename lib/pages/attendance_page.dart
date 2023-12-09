import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final user = FirebaseAuth.instance.currentUser;

  late Stream<QuerySnapshot> _attendanceStream;
  String _month = DateFormat('MMMM').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _attendanceStream = FirebaseFirestore.instance
        .collection("Attendance")
        .doc(user!.email) // Assuming the doc ID is the user's email
        .collection("Attendance_Record")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Page"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _month,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final month = await showMonthYearPicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2099),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              brightness: Brightness.light,
                              background:
                                  const Color.fromARGB(255, 104, 103, 103),
                              primary: const Color.fromARGB(255, 131, 127, 127),
                              secondary: Colors.grey.shade400,
                              inversePrimary: Colors.grey.shade800,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (month != null) {
                      setState(() {
                        _month = DateFormat('MMMM').format(month);
                      });
                    }
                  },
                  child: const Text(
                    "Pick a month",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _attendanceStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No attendance records available.'),
                  );
                } else {
                  var attendanceData = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: attendanceData.length,
                    itemBuilder: (context, index) {
                      var timeStamp =
                          attendanceData[index]['timeStamp'] as Timestamp;
                      var checkIn = attendanceData[index]['checkIn'] ?? 'N/A';
                      var checkOut = attendanceData[index]['checkOut'] ?? 'N/A';

                      return DateFormat('MMMM').format(timeStamp.toDate()) ==
                              _month
                          ? Container(
                              height: 150,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 20),
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
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          DateFormat('EE\ndd')
                                              .format(timeStamp.toDate()),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          checkIn,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                            )
                          : const SizedBox();
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
