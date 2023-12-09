// ignore_for_file: use_build_context_synchronously
import 'package:daily_journal_apps/components/alv_button.dart';
import 'package:daily_journal_apps/components/alv_textfield.dart';
import 'package:daily_journal_apps/pages/forgot_password_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Log In Method
  Future<void> logIn() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // If login successful, dismiss the loading dialog
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      // If login fails, dismiss the loading dialog and show an error dialog
      if (context.mounted) Navigator.pop(context);
      String errorMessage = 'An error occurred';

      // Handle specific error messages
      if (e is FirebaseAuthException) {
        if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password entered';
        } else if (e.code == 'user-not-found') {
          errorMessage = 'User not found';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email';
        }
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Login Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

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
                "L O G I N",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
              ),

              const SizedBox(height: 50),

              //  email textfield
              MyTextField(
                hintText: "Enter Your Email Address",
                obscureText: false,
                controller: _emailController,
              ),

              const SizedBox(height: 15),
              //  password textfield
              MyTextField(
                hintText: "Enter Your Password",
                obscureText: true,
                controller: _passwordController,
              ),

              const SizedBox(height: 15),
              // forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Sign in button
              MyButtons(
                text: "Log In",
                color: Theme.of(context).colorScheme.primary,
                textColor: Colors.black,
                onTap: logIn,
              ),

              const SizedBox(height: 15),
              // register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      " Register Here",
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
