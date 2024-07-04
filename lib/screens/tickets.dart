import 'package:flutter/material.dart';


class TicketsScreen extends StatefulWidget {

  final int ourId;

  TicketsScreen({Key? key, required this.ourId}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState(ourId: ourId);
}


class _TicketsScreenState extends State<TicketsScreen> {

  final int ourId;

  _TicketsScreenState({Key? key, required this.ourId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(ourId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}