import 'package:explore_mate/screens/create_travel.dart';
import 'package:explore_mate/screens/map.dart';
import 'package:explore_mate/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int count_times = 10;
  int count_travels = 3;
  bool time_is_open = false;
  bool is_travel = false;

  late YandexMapController controller;
  GlobalKey mapKey = GlobalKey();
  Future<bool> get locationPermissionNotGranted async => !(await Permission.location.request().isGranted);

  List functions = ['Ближайшие магазины', 'Перевести речь собеседника'];
  List functions_icons = [Icons.shopping_basket_outlined, Icons.translate];

  final List<ChartData> chartData = [
    ChartData('чебуречная', 1),
    ChartData('абоба', 2),
    ChartData('баобаб', 5),
    ChartData('шаурма', 7),
  ];

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.face, size: 30, color: Colors.black,),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: width * 0.02),
                            child: Text('Иван И.', style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: width * 0.05),
                child: Image.asset('assets/explore_mate.png', width: width * 0.2,),
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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateTravelScreen()));
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
                        child: Text(is_travel ? 'Ваш план на день' : 'Создать путешествие', style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),
                      )
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
                        physics: NeverScrollableScrollPhysics(),
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
          Container(
            margin: EdgeInsets.only(left: width * 0.1, top: width * 0.02),
            child: Text('Сверимся?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            height: time_is_open ? (count_times + 1) * 20 : 6 * 20,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: time_is_open ? count_times : 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 2),
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: time_is_open ? Colors.grey : Colors.grey.withOpacity(1 / (index + 1)),
                        height: 3,
                        width: width * 0.65,
                      ),
                      Text('XX:XX', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),)
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: height * 0.025,
            margin: EdgeInsets.only(left: width * 0.4, right: width * 0.4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              onPressed: () {
                setState(() {
                  time_is_open = !time_is_open;
                });
              },
              child: Icon(time_is_open ? Icons.arrow_upward_outlined : Icons.arrow_downward_outlined, color: Colors.white, size: 18,),
            ),
          ),
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
          Container(
            margin: EdgeInsets.only(left: width * 0.04, top: width * 0.02),
            child: Text('Туры, сгенерированные для вас', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            height: height * 0.08,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count_travels,
              itemBuilder: (context, index) {
                return Container(
                  width: width * 0.25,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(14)
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.only(right: width * 0.05, top: height * 0.01),
            child: Text('Рейтинг кафе в вашем городе', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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