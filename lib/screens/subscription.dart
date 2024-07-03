import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class SubscriptionScreen extends StatefulWidget {

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}


class _SubscriptionScreenState extends State<SubscriptionScreen> {

  late User user;
  List subscriptions = [];
  List subscriptions_copy = [];

  @override
  void initState() {
    super.initState();
    getSubscriptions();
  }

  void getSubscriptions() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('subscriptions');
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      int subscription_types = snapshot.children.length;
      for (int i = 0; i < subscription_types; i++) {
        print(snapshot.child((i+1).toString()).child('price').value);
        subscriptions.add([snapshot.child((i+1).toString()).child('price').value, snapshot.child((i+1).toString()).child('count').value]);
      }
    });
    setState(() {
      subscriptions_copy = subscriptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(),
    );
  }
}