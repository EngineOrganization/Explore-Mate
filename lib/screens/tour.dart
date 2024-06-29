import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';


class TourScreen extends StatefulWidget {

  @override
  _TourScreenState createState() => _TourScreenState();
}


class _TourScreenState extends State<TourScreen> {

  late final MapController mapController;

  late User user;
  List<List<Map<String, String>>> tour = [];
  String tour_country = '';
  String tour_city = '';


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
          tour_country = event.snapshot.child('selected_tour').child('country').value.toString();
          tour_city = event.snapshot.child('selected_tour').child('city').value.toString();
        });
      }
      int daysLength = snapshot.child('Trip').children.length;
      for (int i = 0; i < daysLength; i++) {
        int actionsLength = snapshot.child(i.toString()).child('Trip').child('Day ' + (i+1).toString()).children.length;
        tour.add([]);
        for (int j = 0; j < actionsLength; j++) {
          tour[i].add({});
          tour[i][j]['name'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('name').value.toString();
          tour[i][j]['lat'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('lat').value.toString();
          tour[i][j]['lon'] = snapshot.child('Trip').child('Day ' + (i+1).toString()).child('Action ' + (j + 1).toString()).child('lon').value.toString();
        }
      }
    });
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
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(51.509364, -0.128928),
                initialZoom: 9.2,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.engine.explore_mate',
                ),
              ],
            ),
          ),
          Container(
            height: height * 0.5,
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.01, top: height * 0.01),
                  child: Text(tour_country, style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.01),
                  child: Text(tour_city, style: GoogleFonts.roboto(color: Colors.black, fontSize: 20),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}