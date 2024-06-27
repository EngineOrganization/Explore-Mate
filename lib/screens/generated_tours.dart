import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class GeneratedToursScreen extends StatefulWidget {

  @override
  _GeneratedToursScreenState createState() => _GeneratedToursScreenState();
}


class _GeneratedToursScreenState extends State<GeneratedToursScreen> {

  late User user;

  List<List<List<Map<String, String>>>> tours = [];
  List tours_countries = [];
  List tours_cities = [];
  int page_count = 0;

  @override
  void initState() {
    super.initState();
    get_generated_tours();
  }

  void get_generated_tours() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid + '/generated_tours');
    final snapshot = await ref.get();
    int length = snapshot.children.length;
    for (int i = 0; i < length; i++) {
      int daysLength = snapshot.child(i.toString()).child('Trip').children.length;
      tours.add([]);
      tours_countries.add(snapshot.child(i.toString()).child('country').value.toString());
      tours_cities.add(snapshot.child(i.toString()).child('city').value.toString());
      for (int j = 0; j < daysLength; j++) {
        int actionsLength = snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).children.length;
        tours[i].add([]);
        for (int k = 0; k < actionsLength; k++) {
          tours[i][j].add({});
          tours[i][j][k]['name'] =  snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('name').value.toString();
          tours[i][j][k]['lat'] =  snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('lat').value.toString();
          tours[i][j][k]['lon'] =  snapshot.child(i.toString()).child('Trip').child('Day ' + (j+1).toString()).child('Action ' + (k+1).toString()).child('lon').value.toString();
        }
      }
    }
    setState(() {
      page_count = tours.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: PageView.builder(
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
                              Text(tours_countries[pageIndex], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
                              Text(tours_cities[pageIndex], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 28),)
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 0.02),
                          width: width * 0.2,
                          height: height * 0.1,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: page_count,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Icon(Icons.circle, color: index == pageIndex ? Colors.black : Colors.white),
                              );
                            },
                          ),
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
                  itemCount: tours[pageIndex].length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: height * 0.3,
                      child: TimelineTile(
                        isFirst: index == 0,
                        isLast: index == 4,
                        beforeLineStyle: LineStyle(color: Colors.black),
                        indicatorStyle: IndicatorStyle(
                            width: 40,
                            color: Colors.black
                        ),
                        endChild: Container(
                          margin: EdgeInsets.only(left: width * 0.1),
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
                                child: Text('День ' + (index + 1).toString(), style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      )
    );
  }
}