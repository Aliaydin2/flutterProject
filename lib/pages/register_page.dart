import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/my_text_field.dart';
import 'package:flutter_application_1/components/square_tile.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTop;
  const RegisterPage({super.key, required this.onTop});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    //try creating the user
    try {
      //check if password is confirmed
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        //show error message, password don't match
        showErrorMessage("PasswordS don't match!");
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop the loading circle

      Navigator.pop(context);
      //showErrorMessage(e.code);

      //wrong email
      if (e.code == 'user-not-found') {
        // print('No user found for that email');
        //wrong password
        showErrorMessage("Invalid Email");
      } else if (e.code == 'wrong-password') {
        //  print('object');
        showErrorMessage("Incorrect Password");
      }
    }
  }

  //error message to the user
  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 25),
              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),
              const SizedBox(height: 25),
              //welcome back
              Text('Let\'s create an account for you!',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),

              const SizedBox(height: 25),

              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              //passwordtextfield
              MyTextField(
                controller: passwordController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),

              //rePasswordtextfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: "ConfirmPassword",
                obscureText: true,
              ),

              const SizedBox(height: 25),

              MyButton(onTap: signUserUp, text: "Sign Up"),
              const SizedBox(height: 25),

              //or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Divider(thickness: 0.5, color: Colors.grey[400])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Or continue with",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                        child:
                            Divider(thickness: 0.5, color: Colors.grey[400])),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //google apple sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google
                  SquareTile(imagePath: 'lib/images/google.png'),

                  SizedBox(width: 25),
                  // apple
                  SquareTile(imagePath: 'lib/images/apple.png'),
                ],
              ),

              const SizedBox(height: 25),

              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTop,
                    child: const Text(
                      "Login now",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ]),
          ),
        )));
  }
}
