import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseSignInView extends StatefulWidget {
  const SupabaseSignInView({super.key});

  @override
  State<SupabaseSignInView> createState() => _SupabaseSignInViewState();
}

class _SupabaseSignInViewState extends State<SupabaseSignInView> {
  String? email;
  String? password;
  String? carName;
  SupabaseClient? client;
  Session? session;

  List<String> list = [];

  @override
  void initState() {
    super.initState();

    initAsync();
  }

  initAsync() async {
    await Supabase.initialize(
      url: 'https://exzspgiravylaqvwmmzp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV4enNwZ2lyYXZ5bGFxdndtbXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NzAwNDM1NDMsImV4cCI6MTk4NTYxOTU0M30.YBqTDK_abrZIQnudEgJ3mp-fOTWnQtMb73X1f6SwY7c',
    );

    client = Supabase.instance.client;
    final initialSession = await SupabaseAuth.instance.initialSession;
    if (initialSession != null) {
      session = initialSession;
    }
  }

  register() async {
    if (email != null && password != null) {
      AuthResponse response =
          await client!.auth.signUp(email: email!, password: password!);
      inspect(response);
    }
  }

  login() async {
    if (email != null && password != null) {
      AuthResponse response =
          await client!.auth.signInWithPassword(password: password!, email: email!);
      inspect(response);
      session = response.session;
      setState(() {});
    }
  }

  logout() async {
    await client!.auth.signOut();
    session = null;
    setState(() {});
  }

  carSubmit() async {
    final res = client!.from('Cars').insert({'carName': carName}).select();
    inspect(res);
  }

  listCar() async {
    final filter = await client!.from('Cars').select('*');
    inspect(filter);
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
              Text(session != null ? session!.user.email! : 'no Login'),
              ElevatedButton(onPressed: logout, child: const Text('logout')),
              TextField(onChanged: (value) => carName = value),
              ElevatedButton(onPressed: carSubmit, child: const Text('Car submit')),
              ElevatedButton(onPressed: listCar, child: const Text('Car list'))
            ] +
            list.map((e) => Text(e)).toList(),
      ),
    );
  }
}
