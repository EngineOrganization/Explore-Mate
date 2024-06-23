import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class CafeScreen extends StatefulWidget {

  @override
  _CafeScreenState createState() => _CafeScreenState();
}


class _CafeScreenState extends State<CafeScreen> {

  int count_images = 3;

  final List<ChartData> chartData = [
    ChartData('1', 1),
    ChartData('2', 2),
    ChartData('3', 3),
    ChartData('4', 4),
    ChartData('5', 5),
    ChartData('6', 6),
    ChartData('7', 7),
    ChartData('8', 8),
    ChartData('9', 9),
    ChartData('10', 10),
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: width,
                height: height * 0.25,
                color: Color(0xFF5e6488),
              ),
              Container(
                width: width,
                height: width * 0.06,
                color: Colors.white,
              ),
              Container(
                margin: EdgeInsets.only(right: width * 0.1),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: width * 0.06,
                    child: Text('10', style: GoogleFonts.roboto(color: Color(0xFF5e6488), fontSize: 40),)
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: width * 0.1),
                child: Icon(Icons.star, color: Color(0xFF5e6488), size: 40,),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.only(left: width * 0.03, bottom: width * 0.01),
                child: Text('Название', style: GoogleFonts.roboto(color: Colors.black, fontSize: 30),),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.05),
            width: width,
            height: height * 0.2,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20)
            ),
            padding: EdgeInsets.all(20),
            child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: GoogleFonts.roboto(color: Colors.black, fontSize: 14),),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.05),
            height: height * 0.2,
            width: width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: count_images,
              itemBuilder: (context, index) {
                return Container(
                  width: width * 0.4,
                  decoration: BoxDecoration(
                      color: Color(0xFF131a50).withOpacity(1 - 0.3 * index),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.03),
            child: Text('Часы работы', style: GoogleFonts.roboto(color: Colors.black, fontSize: 30)),
          ),
          Container(
            height: width * 0.15,
            width: width,
            margin: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(left: width * 0.01,right: width * 0.01),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: width * 0.04,
                        backgroundColor: index >= 5 ? Color(0xFF131a50) : Colors.grey,
                      ),
                      Text('11:00-18:00', style: GoogleFonts.roboto(color: Colors.black, fontSize: 16))
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            height: height * 0.2,
            child: SfCartesianChart(
              margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
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
                  color: Color(0xFF5e6488),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.05),
            height: height * 2 * 0.2 * 5,
            color: Color(0xFF5e6488),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: height * 0.03,
                        child: Icon(Icons.account_circle_rounded),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: width * 0.02),
                          height: height * 0.1,
                          width: width * 0.8,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
                          child: Row(
                            children: [
                              Container(
                                width: width * 0.6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Иван Иванов', style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.', style: GoogleFonts.roboto(color: Colors.black, fontSize: 10),),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(Icons.star, size: 80, color: Color(0xFF5e6488),),
                                    Text('10', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: Colors.white),)
                                  ],
                                ),
                              )
                            ],
                          )
                      )
                    ],
                  ),
                );
              },
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