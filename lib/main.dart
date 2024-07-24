import 'package:explore_mate/screens/home.dart';
import 'package:explore_mate/screens/login.dart';
import 'package:explore_mate/screens/tickets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD4r7Vuz7D-hQXWsLLL92ZNEssTP3ZXqv4",
        appId: "1:194619597829:android:7703dfebc8bfe340f2286c",
        messagingSenderId: 'sendid',
        projectId: "engine-4a21e",
        storageBucket: "engine-4a21e.appspot.com",
        databaseURL: "https://engine-4a21e-default-rtdb.europe-west1.firebasedatabase.app/",
      )
  );
  bool isSign = false;
  await FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user != null) {
      isSign = true;
    }
  });
  runApp(
    MaterialApp(
      home: isSign ? TicketsScreen() : LoginScreen(),
      debugShowCheckedModeBanner: false,
    )
  );
}