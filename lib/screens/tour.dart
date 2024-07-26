import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class TourScreen extends StatefulWidget {

  @override
  _TourScreenState createState() => _TourScreenState();
}


class _TourScreenState extends State<TourScreen> {

  late final MapController mapController;

  late User user;
  List<List<Map<String, String>>> tour = [];
  List<List<Map<String, String>>> tour_copy = [];
  String tour_country = '';
  String tour_city = '';

  List<List<Marker>> markers = [];
  List<List<Marker>> markers_copy = [];

  int selected_day = 0;


  @override
  void initState() {
    super.initState();
    mapController = MapController();
    get_tour();
  }

  void get_tour() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid);
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot.child('selected_tour');
      if (event.snapshot.child('selected_tour').exists) {
        setState(() {
          tour_country = event.snapshot.child('selected_tour').child('countryTo').value.toString();
          tour_city = event.snapshot.child('selected_tour').child('cityTo').value.toString();
          tour = [];
        });
        DateTime tour_date = DateFormat("yyyy-MM-dd").parse(event.snapshot.child('selected_tour').child('travelDate').value.toString());
        DateTime current_date = DateTime.now();
        selected_day = DateTime(current_date.year - tour_date.year, current_date.month - tour_date.month, current_date.day - tour_date.day + 1).day - 1;
      }
      int daysLength = snapshot.child('Trip').children.length;
      for (int i = 0; i < daysLength; i++) {
        int actionsLength = snapshot.child('Trip').child('Day ' + (i+1).toString()).children.length;
        tour.add([]);
        markers.add([]);
        for (int j = 0; j < actionsLength; j++) {
          tour[i].add({});
          tour[i][j]['name'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('name').value.toString();
          tour[i][j]['info'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('info').value.toString();
          tour[i][j]['lat'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('lat').value.toString();
          tour[i][j]['lon'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('lon').value.toString();
          markers[i].add(Marker(point: LatLng(double.parse(tour[i][j]['lat'].toString()), double.parse(tour[i][j]['lon'].toString())), child: Container(
            child: Icon(Icons.place, size: 40,),
          )));
        }
      }
      setState(() {
        tour_copy = tour;
        markers_copy = markers;
      });
    });
  }


  void navigateWithGoogle(String? lat, String? lon) async {
    var uri = Uri.parse("google.navigation:q=$lat,$lon&mode=d");
    await launchUrlString(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: width,
            height: height * 0.5,
            child: markers_copy.length > 0 ? FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: markers_copy[selected_day][0].point,
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.engine.explore_mate',
                ),
                MarkerLayer(markers: markers_copy[selected_day])
              ],
            ) : Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          ),
          tour_copy.isNotEmpty ? Container(
            height: height * 0.5,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: width * 0.01, top: height * 0.01),
                      child: Text(tour_country, style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
                    ),
                    Container(
                      width: width * 0.6,
                      height: height * 0.05,
                      padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, top: height * 0.005, bottom: height * 0.005),
                      margin: EdgeInsets.only(right: width * 0.05, top: height * 0.01),
                      child: ListView.builder(
                        itemCount: tour.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: width * 0.02),
                            child: ChoiceChip(
                              showCheckmark: false,
                              label: Text('День ' + (index + 1).toString(), style: GoogleFonts.roboto(color: selected_day == index ? Colors.white : Colors.black),),
                              onSelected: (value) {
                                setState(() {
                                  selected_day = index;
                                });
                              },
                              selectedColor: Colors.black,
                              selected: selected_day == index,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.01),
                  child: Text(tour_city, style: GoogleFonts.roboto(color: Colors.black, fontSize: 20),),
                ),
                Container(
                  width: width,
                  height: height * 0.3,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tour_copy[selected_day].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: width * 0.45,
                        height: height * 0.3,
                        child: TimelineTile(
                          isFirst: index == 0,
                          isLast: index == (tour_copy[selected_day].length - 1),
                          axis: TimelineAxis.horizontal,
                          beforeLineStyle: LineStyle(color: Colors.black),
                          indicatorStyle: IndicatorStyle(
                              width: 50,
                              color: Colors.black
                          ),
                          endChild: Container(
                            margin: EdgeInsets.only(right: width * 0.02, top: height * 0.01),
                            width: width * 0.4,
                            decoration: BoxDecoration(
                                color: Color(0xFFedf0f8),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                                padding: EdgeInsets.only(top: height * 0.01, bottom: height * 0.02),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * 0.06,
                                      child: Text(tour_copy[selected_day][index]['name'].toString(), style: GoogleFonts.roboto(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: height * 0.02),
                                      child: Text(tour_copy[selected_day][index]['info'].toString(), style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.bottomLeft,
                                        child: ElevatedButton(
                                          child: Text('Маршрут', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold),),
                                          onPressed: () {
                                            String? lat = tour_copy[selected_day][index]['lat'];
                                            String? lon = tour_copy[selected_day][index]['lon'];
                                            navigateWithGoogle(lat, lon);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.black
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  mapController.move(markers[selected_day][index].point, 14);
                                });
                              },
                            )
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ) : CircularProgressIndicator(
            color: Colors.black,
          )
        ],
      ),
    );
  }
}