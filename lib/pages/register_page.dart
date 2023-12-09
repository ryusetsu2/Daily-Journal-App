// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_journal_apps/components/alv_button.dart';
import 'package:daily_journal_apps/components/alv_textfield.dart';
import 'package:daily_journal_apps/helper/helper_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Register Method
  void register() async {
    //show loading
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );

    //confirm the password parameter
    if (passwordController.text != confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);

      //display message to user
      displayMessageToUser("Your Password didn't match", context);
    }

    //if the password match
    else {
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        //create an user and add them to db
        createUserDocument(userCredential);

        // pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop the loading circle
        Navigator.pop(context);

        //displaying the error message
        displayMessageToUser(e.code, context);
      }
    }
  }

  // creating and storing the data
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email!)
          .set({
        'email': userCredential.user!.email,
        'username': userNameController.text,
      });
    }
  }

  //Creating the User

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo optional
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              // title
              const Text(
                "R E G I S T E R",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),

              SizedBox(height: 50),

              //  Username textfield
              MyTextField(
                hintText: "Enter Your Username",
                obscureText: false,
                controller: userNameController,
              ),

              SizedBox(height: 15),
              //  Email textfield
              MyTextField(
                hintText: "Enter Your Email Address",
                obscureText: false,
                controller: emailController,
              ),

              SizedBox(height: 15),
              //  password textfield
              MyTextField(
                hintText: "Enter Your Password",
                obscureText: true,
                controller: passwordController,
              ),

              SizedBox(height: 15),
              //  Confirm Password textfield
              MyTextField(
                hintText: "Re-Enter Your Password",
                obscureText: true,
                controller: confirmPasswordController,
              ),

              SizedBox(height: 30),

              // Sign up button
              MyButtons(
                text: "Register",
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.black,
                onTap: register,
              ),

              SizedBox(height: 10),
              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      " Login here",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
