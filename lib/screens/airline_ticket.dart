import 'package:flutter/material.dart';
import 'models/airTicket.dart';


class AirlineTicket extends StatefulWidget {

  final AirTicket airlineTicket;

  AirlineTicket({Key? key, required this.airlineTicket}) : super(key: key);

  @override
  _AirlineTicketState createState() => _AirlineTicketState(airlineTicket: airlineTicket);
}


class _AirlineTicketState extends State<AirlineTicket> {

  final AirTicket airlineTicket;
  _AirlineTicketState({Key? key, required this.airlineTicket});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}