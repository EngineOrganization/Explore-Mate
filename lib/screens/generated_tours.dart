import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';


class GeneratedToursScreen extends StatefulWidget {

  @override
  _GeneratedToursScreenState createState() => _GeneratedToursScreenState();
}


class _GeneratedToursScreenState extends State<GeneratedToursScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            width: width,
            height: height * 0.3,
            decoration: BoxDecoration(
              color: Color(0xFF5e6488)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: height * 0.03, left: width * 0.02),
                  child: Text('Тур', style: GoogleFonts.roboto(color: Colors.white , fontWeight: FontWeight.bold, fontSize: 36),),
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
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  height: height * 0.3,
                  child: TimelineTile(
                    isFirst: index == 0,
                    isLast: index == 4,
                    beforeLineStyle: LineStyle(color: Color(0xFF5e6488)),
                    indicatorStyle: IndicatorStyle(
                        width: 40,
                        color: Color(0xFF5e6488)
                    ),
                    endChild: Container(
                      margin: EdgeInsets.only(left: width * 0.1),
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        color: Color(0xFF5e6488),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                            child: Text('День ' + (index + 1).toString(), style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),
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
      )
    );
  }
}