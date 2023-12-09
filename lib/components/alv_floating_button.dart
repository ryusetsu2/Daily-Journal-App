import 'package:daily_journal_apps/components/alv_dialog_box.dart';
import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        createNewTask();
      },
      child: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
