import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color color;
  final Color textColor;
  const MyButtons({
    super.key,
    this.onTap,
    required this.text,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(25),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 18, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
