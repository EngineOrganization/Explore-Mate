import 'package:explore_mate/screens/create_travel.dart';
import 'package:explore_mate/screens/generated_tours.dart';
import 'package:explore_mate/screens/map.dart';
import 'package:explore_mate/screens/profile.dart';
import 'package:explore_mate/screens/subscription.dart';
import 'package:explore_mate/screens/tour.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  late User user;

  bool time_is_open = false;
  bool is_travel = false;

  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  List functions = ['Ближайшие магазины', 'Перевести речь собеседника', 'Придумать равзлечение', 'Где поесть?'];
  List functions_icons = [Icons.shopping_basket_outlined, Icons.translate, Icons.attractions_outlined, Icons.restaurant];
  final List<ChartData> chartData = [
    ChartData('чебуречная', 1),
    ChartData('абоба', 2),
    ChartData('баобаб', 5),
    ChartData('шаурма', 7),
  ];

  List<List<List<Map<String, String>>>> tours = [];
  List tours_countries = [];
  List tours_cities = [];
  int tours_count = 0;

  String selected_tour_country = '';
  String selected_tour_city = '';
  String selected_tour_budget = '';

  bool user_initializated = false;

  List<String> images = [];
  List<String> images_copy = [];

  @override
  void initState() {
    super.initState();
    get_tours();
  }

  void get_tours() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
        user_initializated = true;
      });
    });
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('users/' + user.uid);
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot.child('generated_tours');
      final snapshot1 = event.snapshot.child('selected_tour');
      if (event.snapshot.child('selected_tour').exists) {
        setState(() {
          is_travel = true;
          selected_tour_country = event.snapshot.child('selected_tour').child('country').value.toString();
          selected_tour_city = event.snapshot.child('selected_tour').child('city').value.toString();
          selected_tour_budget = event.snapshot.child('selected_tour').child('budget').value.toString();
        });
      }
      tours = [];
      int length = snapshot.children.length;
      for (int i = 0; i < length; i++) {
        int daysLength = snapshot.child(i.toString()).child('Trip').children.length;
        tours.add([]);
        tours_countries.add(snapshot.child(i.toString()).child('countryTo').value.toString());
        tours_cities.add(snapshot.child(i.toString()).child('cityTo').value.toString());
        images.add(snapshot.child(i.toString()).child('image').value.toString());
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
        tours_count = tours.length;
        images_copy = images;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  margin: EdgeInsets.only(top: height * 0.02, left: width * 0.05),
                  decoration: BoxDecoration(
                      color: Color(0xFFf0f0f0),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      user_initializated ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.face, size: 30, color: Colors.black,),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02),
                            child: Text(user.email.toString(), style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                          )
                        ],
                      ) : CircularProgressIndicator(color: Colors.black,)
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(right: width * 0.05, top: height * 0.02),
                  padding: EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        child: Text('Осталось туров', style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.02),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Text('0', style: GoogleFonts.roboto(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                        ),
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xFFf0f0f0),
                      borderRadius: BorderRadius.circular(30)
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => SubscriptionScreen()));
                },
              )
            ],
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (is_travel) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TourScreen()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTravelScreen()));
                  }
                },
                child: Container(
                  height: height * 0.25,
                  margin: EdgeInsets.only(left: width * 0.05),
                  width: width * 0.43,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: height * 0.02),
                        child: Text(is_travel ? 'Ваше путешествие' : 'Создать путешествие', style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),
                      ),
                      is_travel ? Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text('Страна: ' + selected_tour_country, style: GoogleFonts.roboto(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: width * 0.02),
                            ),
                            Container(
                              child: Text('Город: ' + selected_tour_city, style: GoogleFonts.roboto(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: width * 0.02),
                            ),
                            Container(
                              child: Text('Бюджет: ' + selected_tour_budget, style: GoogleFonts.roboto(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold )),
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: width * 0.02),
                            ),
                          ],
                        ),
                      ) : Container()
                    ],
                  ),
                ),
              ),
              Container(
                width: width * 0.43,
                height: height * 0.25,
                margin: EdgeInsets.only(right: width * 0.05),
                decoration: BoxDecoration(
                  color: Color(0xFFedf0f8),
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      child: Text('Быстрые функции', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
                    ),
                    Container(
                      width: width * 0.4,
                      height: height * 0.2,
                      child: ListView.builder(
                        itemCount: functions.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: height * 0.04,
                            padding: EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
                            margin: EdgeInsets.only(top: height * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(functions[index], style: GoogleFonts.roboto(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),),
                                Icon(functions_icons[index])
                              ],
                            )
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          selected_tour_country != '' ?  Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.1, top: width * 0.02),
                  child: Text('Сверимся?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                ),
                Container(
                  height: height * 0.2,
                  margin: EdgeInsets.only(left: width * 0.06, right: width * 0.06, top: height * 0.02),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: width * 0.3,
                        height: height * 0.2,
                        child: TimelineTile(
                          isFirst: index == 0,
                          isLast: index == (tours_count - 1),
                          axis: TimelineAxis.horizontal,
                          beforeLineStyle: LineStyle(color: Colors.black),
                          indicatorStyle: IndicatorStyle(
                              width: 50,
                              color: Colors.black
                          ),
                          endChild: Container(
                            margin: EdgeInsets.only(right: width * 0.03, top: height * 0.01),
                            width: width * 0.3,
                            decoration: BoxDecoration(
                                color: Color(0xFFedf0f8),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                              child: Text('Text', style: GoogleFonts.roboto(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ) : Container(),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.01),
            height: height * 0.2,
            child: YandexMap(
              key: mapKey,
              onMapCreated: (YandexMapController yandexMapController) async {
                controller = yandexMapController;
                final mediaQuery = MediaQuery.of(context);
                final height = mapKey.currentContext!.size!.height * mediaQuery.devicePixelRatio;
                final width = mapKey.currentContext!.size!.width * mediaQuery.devicePixelRatio;
                await controller.toggleUserLayer(
                    visible: true,
                    autoZoomEnabled: true,
                    anchor: UserLocationAnchor(
                        course: Offset(1 * width, 0.5 * height),
                        normal: Offset(0.5 * width, 0.5 * height)
                    )
                );
              },
              onUserLocationAdded: (UserLocationView view) async {
                return view.copyWith(
                    pin: view.pin.copyWith(
                        icon: PlacemarkIcon.single(
                            PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('assets/user.png'))
                        )
                    ),
                    accuracyCircle: view.accuracyCircle.copyWith(
                        fillColor: Colors.green.withOpacity(0.5)
                    )
                );
              },
              onMapTap: (Point) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));
              },
            ),
          ),
          tours.isNotEmpty ? Container(
            margin: EdgeInsets.only(left: width * 0.04, top: width * 0.02),
            child: Text('Туры, сгенерированные для вас', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ) : Container(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => GeneratedToursScreen()));
            },
            child: Container(
              margin: EdgeInsets.only(left: width * 0.055, right: width * 0.055, top: height * 0.01),
              height: height * 0.08,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tours.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: width * 0.26,
                    margin: EdgeInsets.only(right: width * 0.055),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        image: DecorationImage(image: NetworkImage(images_copy[index]), fit: BoxFit.cover, opacity: 0.6, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.plus))
                    ),
                    padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tours_countries[index], style: GoogleFonts.roboto(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        Text(tours_cities[index], style: GoogleFonts.roboto(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: width * 0.05, top: height * 0.01),
            child: Text('Рейтинг кафе поблизости', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          Container(
            height: height * 0.4,
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            child: SfCartesianChart(
              margin: EdgeInsets.only(top: 0),
              plotAreaBackgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              borderWidth: 0,
              plotAreaBorderWidth: 0,
              enableSideBySideSeriesPlacement: false,
              primaryXAxis: CategoryAxis(
                arrangeByIndex: true,
                majorGridLines: MajorGridLines(width: 0),
                majorTickLines: MajorTickLines(width: 0),
              ),
              primaryYAxis: CategoryAxis(
                isVisible: false,
                maximum: chartData.last.y + 1,
              ),
              series: [
                ColumnSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData sales, _) => sales.x,
                  yValueMapper: (ChartData sales, _) => sales.y,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                  color: Colors.black,
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}


class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}