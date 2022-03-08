import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profile_image/storage.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: pass.text,
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomePages()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.network(
              'https://assets3.lottiefiles.com/packages/lf20_rlkubjgg.json',
              width: 300,
              height: 300,
            ),
            SizedBox(
              width: 350,
              height: 40,
              child: TextField(
                controller: email,
                decoration: InputDecoration(
                  icon: Icon(Icons.email),
                  label: Text('Email'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 350,
              height: 40,
              child: TextField(
                controller: pass,
                decoration: InputDecoration(
                  icon: Icon(Icons.lock),
                  label: Text('Password'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text('Login'))
          ],
        )),
      ),
    );
  }
}
