import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String databaseId = '';
const String collectionId = '';

class FirebaseSignInView extends StatefulWidget {
  const FirebaseSignInView({super.key});

  @override
  State<FirebaseSignInView> createState() => _FirebaseSignInViewState();
}

class _FirebaseSignInViewState extends State<FirebaseSignInView> {
  String? email;
  String? password;
  String? carName;

  List<String> list = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    initAsync();
  }

  initAsync() async {}

  register() async {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    inspect(credential);
  }

  login() async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
    inspect(credential);
    setState(() {});
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }

  carSubmit() async {
    DocumentReference ref = await db.collection("cars").add({'carName': carName!});
    inspect(ref);
  }

  deleteCar() async {}

  listCar() async {
    setState(() {});
    inspect(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(32.0), children: [
        TextField(
          onChanged: (value) => email = value,
        ),
        TextField(
          onChanged: (value) => password = value,
        ),
        ElevatedButton(onPressed: register, child: const Text('register')),
        ElevatedButton(onPressed: login, child: const Text('login')),
        Text(FirebaseAuth.instance.currentUser?.email ?? 'no Login'),
        ElevatedButton(onPressed: logout, child: const Text('logout')),
        TextField(onChanged: (value) => carName = value),
        ElevatedButton(onPressed: carSubmit, child: const Text('Car submit')),
        ElevatedButton(onPressed: listCar, child: const Text('Car list')),
        ElevatedButton(onPressed: deleteCar, child: const Text('Delete Car'))
      ]
          //+
          //list.map((e) => Text(e)).toList(),
          ),
    );
  }
}
