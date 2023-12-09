import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class MyDescriptionTextFIeld extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  const MyDescriptionTextFIeld({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13.0),
      child: TextField(
        maxLines: 1,
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(height: 10, fontSize: 17),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
