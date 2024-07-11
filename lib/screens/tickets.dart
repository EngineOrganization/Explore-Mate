import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


class TicketsScreen extends StatefulWidget {

  final List<List<Map<String, Object>>> planesTo_copy;
  final List<List<Map<String, Object>>> trainsTo_copy;

  TicketsScreen({Key? key, required this.planesTo_copy, required this.trainsTo_copy}) : super(key: key);

  @override
  _TicketsScreenState createState() => _TicketsScreenState(planesTo_copy: planesTo_copy, trainsTo_copy: trainsTo_copy);
}


class _TicketsScreenState extends State<TicketsScreen> {

  final List<List<Map<String, Object>>> planesTo_copy;
  final List<List<Map<String, Object>>> trainsTo_copy;

  _TicketsScreenState({Key? key, required this.planesTo_copy, required this.trainsTo_copy});

  List<List<List<Map<String, Object>>>> movements = [];

  List<String> titles = [];
  Map<String, Icon> icons = {};

  @override
  void initState() {
    super.initState();
    if (planesTo_copy.length > 0) {
      setState(() {
        titles.add('Planes');
        icons['Planes'] = Icon(Icons.flight, color: Colors.black,);
        movements.add(planesTo_copy);
      });
    }
    if (trainsTo_copy.length > 0) {
      setState(() {
        titles.add('Trains');
        icons['Trains'] = Icon(Icons.train, color: Colors.black,);
        movements.add(trainsTo_copy);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
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
          children: movements.map((movement) {
            return ListView.builder(
              itemCount: movement.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: height * 0.05, left: width * 0.05, right: width * 0.05),
                  padding: EdgeInsets.all(20),
                  height: height * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color(0xFFedf0f8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(movement[movements.indexOf(movement)][index]['title'].toString(), style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
                          titles[movements.indexOf(movement)] == 'Trains' ? Image.network(movement[movements.indexOf(movement)][index]['logotype'].toString(), width: width * 0.3,): SvgPicture.network(movement[movements.indexOf(movement)][index]['logotype'].toString())
                        ],
                      ),
                      Text(DateFormat('HH:mm').format(DateTime.parse(movement[movements.indexOf(movement)][index]['departure'].toString())).toString() + ' - ' + DateFormat('HH:mm').format(DateTime.parse(movement[movements.indexOf(movement)][index]['arrival'].toString())).toString(), style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
                    ],
                  ),
                );
              },
            );
          }).toList()
        ),
      ),
    );
  }
}