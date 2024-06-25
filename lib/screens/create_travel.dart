import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';


class CreateTravelScreen extends StatefulWidget {

  @override
  _CreateTravelScreenState createState() => _CreateTravelScreenState();
}


class _CreateTravelScreenState extends State<CreateTravelScreen> {

  double activity_value = 5;
  int people_type = 0;
  int budget_type = 0;
  List people = ['Один', 'Семья', 'Друзья', 'Влюблённые'];
  List priorities = ['Еда', 'Необычные места', 'Экстрим'];
  List budget = ['Маленький', 'Средний', 'Большой'];

  Map<String, dynamic> places = {'Russia': ['Moscow']};
  List<String> cities = [];
  Set<String> priority = {};
  String dropdownCountry = 'Russia';
  String dropdownCity = 'Moscow';

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    Socket socket;
    Socket.connect('192.168.1.6', 4048).then((Socket sock) {
      socket = sock;
      socket.listen((data) {
        final String response = String.fromCharCodes(data);
        print(response);
        Map<String, dynamic> resp = json.decode(response);
        setState(() {
          places = resp;
        });
        print(places.keys);
      },
          cancelOnError: false);
      socket.write('Hello');
      socket.close();
    }).catchError((e) {
      print("Unable to connect: $e");
    });
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.05, left: width * 0.02),
            child: Text('Создай своё путешествие!', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.05),
            child: Text('Страна', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5, top: height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2)
            ),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                menuMaxHeight: height * 0.5,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(20),
                value: dropdownCountry,
                onChanged: (String? value) {
                  setState(() {
                    dropdownCountry = value!;
                    cities = List<String>.from(places[dropdownCountry]).toList();
                    print(cities);
                  });
                },
                icon: Icon(Icons.arrow_drop_down),
                underline: SizedBox(),
                items: places.keys.toList().map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                  );
                }).toList(),
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.03),
            child: Text('Город', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.03),
            child: Text('Оцените степень своей активности', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            child: Slider(
              value: activity_value,
              activeColor: Color(0xFF5e6488),
              max: 10,
              divisions: 10,
              label: activity_value.round().toString(),
              onChanged: (value) {
                setState(() {
                  activity_value = value;
                });
              },
            )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('С кем вы будете путешествовать?', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            height: height * 0.05,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: people.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: width * 0.02),
                  child: ChoiceChip(
                    checkmarkColor: Colors.white,
                    label: Text(people[index], style: GoogleFonts.roboto(color: people_type == index ? Colors.white : Colors.black),),
                    selected: people_type == index,
                    onSelected: (value) {
                      setState(() {
                        people_type = index;
                      });
                    },
                    selectedColor: Color(0xFF5e6488),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                );
              },
            )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Оцените ваш бюджет', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
              height: height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: budget.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: width * 0.02),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: Text(budget[index], style: GoogleFonts.roboto(color: budget_type == index ? Colors.white : Colors.black),),
                      selected: budget_type == index,
                      onSelected: (value) {
                        setState(() {
                          budget_type = index;
                        });
                      },
                      selectedColor: Color(0xFF5e6488),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  );
                },
              )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Ваши приоритеты', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
              height: height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: priorities.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: width * 0.02),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: Text(priorities[index], style: GoogleFonts.roboto(color: priority.contains(priorities[index]) ? Colors.white : Colors.black),),
                      selected: priority.contains(priorities[index]),
                      onSelected: (value) {
                        setState(() {
                          if (priority.contains(priorities[index])) {
                            priority.remove(priorities[index]);
                          } else {
                            priority.add(priorities[index]);
                          }
                        });
                      },
                      selectedColor: Color(0xFF5e6488),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  );
                },
              )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Напишите всё, что вы хотите видеть в своем туре', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            height: height * 0.2,
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            child: TextField(
              cursorColor: Color(0xFF5e6488),
              enabled: true,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none
                  )
                ),
                hintText: 'Введите Ваши пожелания',
                fillColor: Colors.grey.shade300,
                filled: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.3, right: width * 0.3, top: height * 0.02),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black
              ),
              child: Text('Сгенерировать варианты!', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      )
    );
  }
}
