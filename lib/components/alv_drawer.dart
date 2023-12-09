import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AlvDrawer extends StatefulWidget {
  const AlvDrawer({super.key});

  @override
  State<AlvDrawer> createState() => _AlvDrawerState();
}

class _AlvDrawerState extends State<AlvDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header
          Column(
            children: [
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 100),

              // Profile col
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: AlvListTile(
                  icon: Icons.person,
                  text: "P R O F I L E",
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/profile_page');
                  },
                ),
              ),
              // Attendance col
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: AlvListTile(
                  icon: Icons.book,
                  text: "A T T E N D A N C E",
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/attendance_page');
                  },
                ),
              ),
              // Daily Journal
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: AlvListTile(
                  icon: Icons.calendar_month,
                  text: "J O U R N A L",
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushNamed(context, '/journal_page');
                  },
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 10.0, bottom: 20),
            child: AlvListTile(
              icon: Icons.logout,
              text: "L O G  O U T",
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AlvListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;

  const AlvListTile({
    super.key,
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.inversePrimary,
        size: 25,
      ),
      title: Text(text),
      onTap: onTap,
    );
  }
}
