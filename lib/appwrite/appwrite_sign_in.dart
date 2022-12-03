import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';

class AppWriteSignInView extends StatefulWidget {
  const AppWriteSignInView({super.key});

  @override
  State<AppWriteSignInView> createState() => _AppWriteSignInViewState();
}

class _AppWriteSignInViewState extends State<AppWriteSignInView> {
  String? email;
  String? password;
  String? carName;
  late final Client client;
  late final Account account;
  late final Databases databases;

  models.Session? session;

  List<String> list = [];

  @override
  void initState() {
    super.initState();

    client = Client();
    client
        .setEndpoint('https://10.0.2.2/v1')
        .setProject('6389d31abe5ca523c88b')
        .setSelfSigned(status: true);

    account = Account(client);
    databases = Databases(client);

    initAsync();
  }

  initAsync() async {
    try {
      models.SessionList sessionList = await account.listSessions();
      inspect(account.listSessions());
      if (sessionList.sessions.isNotEmpty) {
        session = sessionList.sessions.first;
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      session = null;
    }
  }

  register() async {
    if (email != null && password != null) {
      final user =
          await account.create(userId: ID.unique(), email: email!, password: password!);
      inspect(user);
    }
  }

  login() async {
    if (email != null && password != null) {
      session = await account.createEmailSession(email: email!, password: password!);
      inspect(session);
      setState(() {});
    }
  }

  logout() async {
    await account.deleteSessions();
    session = null;
    setState(() {});
  }

  carSubmit() async {
    databases.createDocument(
        databaseId: '6389edaaa74fb4b3aa76',
        collectionId: '6389edadb86907407050',
        documentId: ID.unique(),
        data: {'carName': carName});
  }

  deleteCar() async {
    databases.deleteDocument(
        databaseId: '6389edaaa74fb4b3aa76',
        collectionId: '6389edadb86907407050',
        documentId: '638b87996187a3d92c59');
  }

  listCar() async {
    models.DocumentList result = await databases.listDocuments(
        databaseId: '6389edaaa74fb4b3aa76', collectionId: '6389edadb86907407050');

    List<String> internal = [];
    for (var e in result.documents) {
      String? a = e.data['carName'];
      if (a != null) {
        internal.add(a);
      }
    }

    list = internal;

    setState(() {});
    inspect(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(32.0),
        children: [
              TextField(
                onChanged: (value) => email = value,
              ),
              TextField(
                onChanged: (value) => password = value,
              ),
              ElevatedButton(onPressed: register, child: const Text('register')),
              ElevatedButton(onPressed: login, child: const Text('login')),
              Text(session != null ? session!.userId : 'no Login'),
              ElevatedButton(onPressed: logout, child: const Text('logout')),
              TextField(onChanged: (value) => carName = value),
              ElevatedButton(onPressed: carSubmit, child: const Text('Car submit')),
              ElevatedButton(onPressed: listCar, child: const Text('Car list')),
              ElevatedButton(onPressed: deleteCar, child: const Text('Delete Car'))
            ] +
            list.map((e) => Text(e)).toList(),
      ),
    );
  }
}
