import 'package:explore_mate/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int count_times = 6;
  int count_travels = 3;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            margin: EdgeInsets.only(top: height * 0.02, left: width * 0.05, right: width * 0.7),
            height: height * 0.05,
            decoration: BoxDecoration(
                color: Color(0xFFf0f0f0),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: height * 0.02,
                      child: Icon(Icons.account_circle),
                    ),
                    Text('Иван И.')
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            height: height * 0.3,
            decoration: BoxDecoration(
              color: Color(0xFF5e6488),
              borderRadius: BorderRadius.circular(24)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: width * 0.05, top: height * 0.05),
                  child: Text('Ваш план на день', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.1, top: width * 0.02),
            child: Text('Сверимся?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            height: height * 0.2,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: count_times,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 2),
                  height: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.grey.withOpacity(1 / (index + 1)),
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
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30)
            ),
            child: Icon(Icons.arrow_downward_outlined, color: Colors.white, size: 18,),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.01),
            height: height * 0.3,
            child: YandexMap(
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
                    color: Color(0xFF131a50),
                    borderRadius: BorderRadius.circular(14)
                  ),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}