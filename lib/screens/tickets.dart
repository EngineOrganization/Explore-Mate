import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/airTicket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class TicketsScreen extends StatefulWidget {

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}


class _TicketsScreenState extends State<TicketsScreen> {

  late User user;

  List<String> titles = [];
  Map<String, Icon> icons = {};
  List<AirTicket> airTickets = [];
  List<Widget> widgets = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    getAirlines();
    isLoaded = true;
  }

  void getAirlines() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid + '/selected_tour/airlines');
    final airlineSnapshot = await ref.get();
    if (airlineSnapshot.children.length > 0) {
      setState(() {
        titles.add('Airlines');
        icons['Airlines'] = Icon(Icons.flight);
      });
    }
    airlineSnapshot.children.forEach((airTicket) {
      Owner owner = Owner(airTicket.child('owner').child('iata_code').value.toString(), airTicket.child('owner').child('id').value.toString(), airTicket.child('owner').child('logo_symbol_url').value.toString(), airTicket.child('owner').child('name').value.toString());
      Slices slices = Slices([]);
      airTicket.child('slices').children.forEach((sliceTicket) {
        DestinationSlice destinationSlice = DestinationSlice(sliceTicket.child('destination').child('city_name').value.toString(), sliceTicket.child('destination').child('iata_city_code').value.toString(), sliceTicket.child('destination').child('iata_country_code').value.toString(), sliceTicket.child('destination').child('id').value.toString(), sliceTicket.child('destination').child('name').value.toString(), sliceTicket.child('destination').child('type').value.toString());
        OriginSlice originSlice = OriginSlice(sliceTicket.child('origin').child('city_name').value.toString(), sliceTicket.child('origin').child('iata_city_code').value.toString(), sliceTicket.child('origin').child('iata_country_code').value.toString(), sliceTicket.child('origin').child('id').value.toString(), sliceTicket.child('origin').child('name').value.toString(), sliceTicket.child('origin').child('type').value.toString());
        Segments segments = Segments([]);
        sliceTicket.child('segments').children.forEach((segmentTicket) {
          Aircraft aircraft = Aircraft(segmentTicket.child('aircraft').child('iata_code').value.toString(), segmentTicket.child('aircraft').child('id').value.toString(), segmentTicket.child('aircraft').child('name').value.toString());
          OriginSegment originSegment = OriginSegment(segmentTicket.child('origin').child('iata_code').value.toString(), segmentTicket.child('origin').child('iata_country_code').value.toString(), segmentTicket.child('origin').child('id').value.toString(), segmentTicket.child('origin').child('latitude').value.toString(), segmentTicket.child('origin').child('longitude').value.toString(), segmentTicket.child('origin').child('name').value.toString(), segmentTicket.child('origin').child('time_zone').value.toString());
          DestinationSegment destinationSegment = DestinationSegment(segmentTicket.child('destination').child('iata_code').value.toString(), segmentTicket.child('destination').child('iata_country_code').value.toString(), segmentTicket.child('destination').child('id').value.toString(), segmentTicket.child('destination').child('latitude').value.toString(), segmentTicket.child('destination').child('longitude').value.toString(), segmentTicket.child('destination').child('name').value.toString(), segmentTicket.child('destination').child('time_zone').value.toString());
          Segment segment = Segment(segmentTicket.child('arriving_at').value.toString(), segmentTicket.child('departing_at').value.toString(), segmentTicket.child('id').value.toString(), aircraft, originSegment, destinationSegment);
          segments.segments.add(segment);
        });
        Slice slice = Slice(originSlice, destinationSlice, segments);
        slices.slices.add(slice);
      });
      AirTicket ticket = AirTicket(double.parse(airTicket.child('total_amount').value.toString()), airTicket.child('total_currency').value.toString(), airTicket.child('id').value.toString(), slices, owner);
      print(ticket);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return isLoaded ? DefaultTabController(
      length: titles.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            dividerHeight: 0,
            tabs: titles.map<Tab>((String title) {
              return Tab(text: title, icon: icons[title]);
            }).toList(),
          ),
        ),
        body: TabBarView(
            children: [
              Text('Hello')
            ]
        ),
      ),
    ) : Scaffold(
      body: CircularProgressIndicator(),
    );
  }


  Widget airTicketWidget(AirTicket airTicket, double width, double height) {
    return Container(
      height: height,
      color: Colors.black,
    );
  }

  // Widget airTicketsWidget(double width, double height) {
  //   return ListView.builder(
  //     itemCount: airTickets.length,
  //     itemBuilder: (context, index) {
  //       return airTicketWidget(airTickets[index], width, height * 0.3);
  //     },
  //   );
  // }
}