import 'package:explore_mate/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class GeneratedToursScreen extends StatefulWidget {

  @override
  _GeneratedToursScreenState createState() => _GeneratedToursScreenState();
}


class _GeneratedToursScreenState extends State<GeneratedToursScreen> {

  late final MapController mapController;

  List<LatLng> points = [];
  List<Marker> markers = [];

  late User user;

  List<List<List<Map<String, String>>>> tours = [];
  List tours_countries = [];
  List tours_cities = [];
  List tours_countries_copy = [];
  List tours_cities_copy = [];
  int page_count = 0;
  List<List<List<Map<String, String>>>> tours_copy = [];

  @override
  void initState() {
    super.initState();
    get_generated_tours();
    mapController = MapController();
  }

  final _controller = PageController();

  void get_generated_tours() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid + '/generated_tours');
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      int length = snapshot.children!.length;
      setState(() {
        page_count = length;
      });
      tours = [];
      tours_cities = [];
      tours_countries = [];
      for (int i = 0; i < length; i++) {
        int daysLength = snapshot.child(i.toString()).child('Trip').children!.length;
        tours.add([]);
        tours_countries.add(snapshot.child(i.toString()).child('country').value.toString());
        tours_cities.add(snapshot.child(i.toString()).child('city').value.toString());
        for (int j = 0; j < daysLength; j++) {
          int actionsLength = snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).children!.length;
          tours[i].add([]);
          for (int k = 0; k < actionsLength; k++) {
            tours[i][j].add({});
            tours[i][j][k]['name'] = snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('name').value.toString();
            tours[i][j][k]['lat'] = snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('lat').value.toString();
            tours[i][j][k]['lon'] = snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('lon').value.toString();
          }
        }
      }
      setState(() {
        tours_copy = tours;
        tours_countries_copy = tours_countries;
        tours_cities_copy = tours_cities;
      });
    });
  }


  void select_tour(int tour_index) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid + '/generated_tours/' + tour_index.toString());
    final snapshot = await ref.get();
    DatabaseReference ref_1 = FirebaseDatabase.instance.ref().child('users/' + user.uid + '/selected_tour');
    await ref_1.set(snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: page_count,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, pageIndex) {
          return ListView(
            children: [
              Container(
                width: width,
                height: height * 0.3,
                decoration: BoxDecoration(
                    color: Color(0xFFf0f0f0)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: height * 0.03, left: width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tours_countries_copy[pageIndex], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
                              Text(tours_cities_copy[pageIndex], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 28),)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 0.02),
                          width: width * 0.2,
                          height: height * 0.1,
                          child: SmoothPageIndicator(
                            controller: _controller,
                            count: page_count,
                            effect: ExpandingDotsEffect(
                              activeDotColor: Colors.black,
                              dotColor: Colors.white,
                              dotHeight: 30,
                              dotWidth: 30
                            ),
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.3 * 5,
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: tours_copy[pageIndex].length,
                  itemBuilder: (context, dayIndex) {
                    return Container(
                      height: height * 0.3,
                      child: TimelineTile(
                        isFirst: dayIndex == 0,
                        isLast: dayIndex == 4,
                        beforeLineStyle: LineStyle(color: Colors.black),
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.black
                        ),
                        alignment: TimelineAlign.end,
                        startChild: Container(
                          margin: EdgeInsets.only(right: width * 0.1),
                          height: height * 0.2,
                          decoration: BoxDecoration(
                              color: Color(0xFFf0f0f0),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                                child: Text('День ' + (dayIndex + 1).toString(), style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: width * 0.01),
                                height: height * 0.15,
                                width: width * 0.5,
                                child: ListView.builder(
                                  itemCount: tours_copy[pageIndex][dayIndex].length,
                                  itemBuilder: (context, actionIndex) {
                                    return Container(
                                      margin: EdgeInsets.only(left: width * 0.01, top: height * 0.01),
                                      padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, top: height * 0.01, bottom: height * 0.01),
                                      child: Text(tours_copy[pageIndex][dayIndex][actionIndex]['name']!, style: GoogleFonts.roboto(color: Colors.black, fontSize: 14),),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20)
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: height * 0.5,
                width: width,
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
                    MarkerLayer(markers: markers)
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: width * 0.3, right: width * 0.3, top: height * 0.02, bottom: height * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    select_tour(pageIndex);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black
                  ),
                  child: Text('Выбрать тур', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          );
        },
      )
    );
  }
}