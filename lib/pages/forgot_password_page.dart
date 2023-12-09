// ignore_for_file: use_build_context_synchronously

import 'package:daily_journal_apps/components/alv_add_button.dart';
import 'package:daily_journal_apps/components/alv_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Succeed"),
              content: Text(
                  "Link has been sent, check your Gmail to reset password"),
            );
          });
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Enter your Email, and the Link will be sent to your Gmail",
            ),
          ),
          const SizedBox(height: 10),
          MyTextField(
            hintText: "Enter your Email",
            obscureText: false,
            controller: _emailController,
          ),
          const SizedBox(height: 10),
          AddButton(
            text: "Reset Password",
            onTap: () => resetPassword(),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
