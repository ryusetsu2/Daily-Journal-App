import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const AddButton({super.key, this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(left: 12, top: 12),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
