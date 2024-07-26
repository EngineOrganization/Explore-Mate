import 'package:explore_mate/screens/airline_ticket.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/airTicket.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';


class TicketsScreen extends StatefulWidget {

  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}


class _TicketsScreenState extends State<TicketsScreen> {

  late User user;
  late double width;
  late double height;

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
      int slicesLength = airTicket.child('slices').children.length;
      for (int i = 0; i < slicesLength; i++) {
        DataSnapshot sliceTicket = airTicket.child('slices').child(i.toString());
        DestinationSlice destinationSlice = DestinationSlice(sliceTicket.child('destination').child('city_name').value.toString(), sliceTicket.child('destination').child('iata_city_code').value.toString(), sliceTicket.child('destination').child('iata_country_code').value.toString(), sliceTicket.child('destination').child('id').value.toString(), sliceTicket.child('destination').child('name').value.toString(), sliceTicket.child('destination').child('type').value.toString());
        OriginSlice originSlice = OriginSlice(sliceTicket.child('origin').child('city_name').value.toString(), sliceTicket.child('origin').child('iata_city_code').value.toString(), sliceTicket.child('origin').child('iata_country_code').value.toString(), sliceTicket.child('origin').child('id').value.toString(), sliceTicket.child('origin').child('name').value.toString(), sliceTicket.child('origin').child('type').value.toString());
        Segments segments = Segments([]);
        int segmentsLength = sliceTicket.child('segments').children.length;
        for (int j = 0; j < segmentsLength; j++) {
          DataSnapshot segmentTicket = sliceTicket.child('segments').child(j.toString());
          Aircraft aircraft = Aircraft(segmentTicket.child('aircraft').child('iata_code').value.toString(), segmentTicket.child('aircraft').child('id').value.toString(), segmentTicket.child('aircraft').child('name').value.toString());
          OriginSegment originSegment = OriginSegment(segmentTicket.child('origin').child('iata_code').value.toString(), segmentTicket.child('origin').child('iata_country_code').value.toString(), segmentTicket.child('origin').child('id').value.toString(), segmentTicket.child('origin').child('latitude').value.toString(), segmentTicket.child('origin').child('longitude').value.toString(), segmentTicket.child('origin').child('name').value.toString(), segmentTicket.child('origin').child('time_zone').value.toString());
          DestinationSegment destinationSegment = DestinationSegment(segmentTicket.child('destination').child('iata_code').value.toString(), segmentTicket.child('destination').child('iata_country_code').value.toString(), segmentTicket.child('destination').child('id').value.toString(), segmentTicket.child('destination').child('latitude').value.toString(), segmentTicket.child('destination').child('longitude').value.toString(), segmentTicket.child('destination').child('name').value.toString(), segmentTicket.child('destination').child('time_zone').value.toString());
          Segment segment = Segment(DateFormat('dd/MM/yyyy, HH:mm:ss').parse(segmentTicket.child('arriving_at').value.toString()), DateFormat('dd/MM/yyyy, HH:mm:ss').parse(segmentTicket.child('departing_at').value.toString()), segmentTicket.child('id').value.toString(), aircraft, originSegment, destinationSegment);
          segments.segments.add(segment);
        }
        Slice slice = Slice(originSlice, destinationSlice, segments);
        slices.slices.add(slice);
      }
      AirTicket ticket = AirTicket(double.parse(airTicket.child('total_amount').value.toString()), airTicket.child('total_currency').value.toString(), airTicket.child('id').value.toString(), slices, owner);
      setState(() {
        airTickets.add(ticket);
      });
    });
    setState(() {
      widgets.add(airTicketsWidget());
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
            children: widgets
        ),
      ),
    ) : Scaffold(
      body: CircularProgressIndicator(),
    );
  }


  Widget airTicketWidget(AirTicket airTicket) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AirlineTicket(airlineTicket: airTicket,)));
      },
      child: Container(
        height: height * 0.2,
        margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFf0f0f0)
        ),
        padding: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02, left: width * 0.03, right: width * 0.03),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(airTicket.total_currency + ' ' + airTicket.total_amount.toString(), style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),),
                SvgPicture.network(airTicket.owner.logo_symbol_url, width: width * 0.03)
              ],
            ),
            Expanded(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: airTicket.slices.slices[0].segments.segments.length + 1,
                        itemBuilder: (context, index) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.06,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(index == airTicket.slices.slices[0].segments.segments.length ? (airTicket.slices.slices[0].segments.segments[index-1].departing_at.hour.toString() + ':' + airTicket.slices.slices[0].segments.segments[index-1].departing_at.minute.toString()) : (airTicket.slices.slices[0].segments.segments[index].arriving_at.hour.toString() + ':' + airTicket.slices.slices[0].segments.segments[index].arriving_at.minute.toString())),
                                    Text(index == airTicket.slices.slices[0].segments.segments.length ? airTicket.slices.slices[0].segments.segments[index-1].destinationSegment.iata_code : airTicket.slices.slices[0].segments.segments[index].originSegment.iata_code),
                                  ],
                                ),
                              ),
                              index == airTicket.slices.slices[0].segments.segments.length ? Container() : Icon(Icons.arrow_right, color: Colors.black, size: 24,)
                            ],
                          );
                        },
                      ),
                    ),
                    airTicket.slices.slices[0].segments.segments.length == 1 ? Text('Direct') : Text((airTicket.slices.slices[0].segments.segments.length - 1).toString() + ' layovers'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget airTicketsWidget() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: height * 0.05),
          width: width,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: airTickets.length,
            itemBuilder: (context, index) {
              return airTicketWidget(airTickets[index]);
            },
          ),
        )
      ],
    );
  }
}