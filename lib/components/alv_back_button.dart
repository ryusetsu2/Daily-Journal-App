import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Icon(Icons.arrow_back),
          ),
        ),
      ),
    );
  }
}
