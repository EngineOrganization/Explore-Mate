import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CreateOrganizationScreen extends StatefulWidget {

  @override
  _CreateOrganizationScreenState createState() => _CreateOrganizationScreenState();
}


class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {

  int choice = 0;

  List<String> days = ['Понедельник', 'Вторник', 'Среда', 'Четверг', 'Пятница', 'Суббота', 'Воскресенье'];
  List<String> types = ['Ресторан', 'Кафе', 'Магазин'];
  List<TimeOfDay> work_time = [];
  List<bool> is_work = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.05, left: width * 0.02),
            child: Text('Название', style: GoogleFonts.roboto(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.2),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Введите название вашей организации'
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
              child: Text('Вид деятельности', style: GoogleFonts.roboto(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            height: height * 0.05,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  child: ChoiceChip(
                    label: Text(types[index], style: GoogleFonts.roboto(color:  choice == index ? Colors.white : Colors.black),),
                    checkmarkColor: Colors.white,
                    selected: choice == index,
                    onSelected: (value) {
                      setState(() {
                        choice = index;
                      });
                    },
                    selectedColor: Color(0xFF5e6488),
                  ),
                );
              },
            )
          ),
          Container(
              margin: EdgeInsets.only(top: height * 0.02, left: width * 0.02),
              child: Text('Режим работы', style: GoogleFonts.roboto(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold))
          ),
          Container(
            width: width * 0.8,
            height: height * 0.03 * 7 + height * 7 * 0.02,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: days.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: height * 0.01, left: width * 0.05),
                  height: height * 0.03,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(days[index]),
                      ),
                      Row(
                        children: [
                          Switch(
                            value: is_work[index],
                            activeColor: Colors.white,
                            activeTrackColor: Color(0xFF5e6488),
                            onChanged: (value) {
                              setState(() {
                                is_work[index] = value;
                              });
                            },
                          ),
                          is_work[index] ?
                          Container(
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF5e6488)
                                ),
                                child: Text('Выбрать время работы', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)
                            ),
                          ) : Container()
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}