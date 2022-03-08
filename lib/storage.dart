import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  var results;
  var name;
  Storage storage = Storage();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  results = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ["pdf", "jpg", "png", "jpeg"]);

                  setState(() {
                    results = results;
                  });

                  if (results == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("No Files Selected"),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("File Added"),
                    ));
                  }
                  final path = results.files.single.path;
                  final file = results.files.single.name;
                  storage.uploadFile(path, file);
                },
                child: const Text("Upload File")),
          ),
          if (results != null)
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Column(
                children: [
                  Image.file(
                    File(results.files.single.path),
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // Text(''),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class Storage {
  final FirebaseStorage store = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> uploadFile(
    String filepath,
    String filename,
  ) async {
    File file = File(filepath);
    try {
      await store.ref('${auth.currentUser!.uid}/$filename').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> name(String name) async {
    String na = name;
    try {
      await store.ref('${auth.currentUser!.uid}/$name').putString(name);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
