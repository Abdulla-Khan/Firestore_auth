import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:profile_image/login.dart';
import 'package:profile_image/storage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();

  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    Future<void> signIn(String? em, String? ps) async {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: em!, password: ps!);

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Login()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.space,
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
            SizedBox(
              width: 350,
              height: 40,
              child: TextField(
                controller: name,
                decoration: InputDecoration(
                  icon: Icon(Icons.person),
                  label: Text('Name'),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  signIn(email.text, pass.text);
                  storage.name(name.text);
                },
                child: Text('Sign In')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Login()));
                },
                child: Text('Login'))
          ],
        )),
      ),
    );
  }
}
