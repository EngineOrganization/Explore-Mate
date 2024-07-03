import 'dart:convert';
import 'dart:math';
import 'package:explore_mate/screens/generated_tours.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';


class CreateTravelScreen extends StatefulWidget {

  @override
  _CreateTravelScreenState createState() => _CreateTravelScreenState();
}


class _CreateTravelScreenState extends State<CreateTravelScreen> {


  late User user;

  late Socket socket;

  double activity_value = 5;
  double day_value = 5;
  int people_type = 0;
  int budget_type = 0;
  int fromOf_type = 0;
  List people = ['Один', 'Семья', 'Друзья', 'Влюблённые'];
  List priorities = ['Еда', 'Достопримечательности', 'Интересные места', 'Экстрим'];
  List fromOf = ['Текущее местоположение', 'Другое место'];
  List priority_icons = [Icons.fastfood, Icons.museum, Icons.storefront, Icons.sports_motorsports];
  List budget = ['Маленький', 'Средний', 'Большой'];
  DateTime travelDate = DateTime.now();

  List<String> countries = ['Не указано'];
  List<String> cities = ['Не указано'];
  Set<String> priority = {};
  String dropdownCountryTo = 'Не указано';
  String dropdownCityTo = 'Не указано';
  String dropdownCountryOf = 'Не указано';
  String dropdownCityOf = 'Не указано';

  @override
  void initState() {
    super.initState();
    connectToServer();
    getUser();
  }


  void selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      }
    );
    if (picked != null) {
      setState(() {
        travelDate = picked;
      });
    }
  }

  void getUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((User? _user) {
      setState(() {
        user = _user!;
      });
    });
  }

  void connectToServer() async {
    Socket.connect('192.168.1.6', 4048).then((Socket sock) {
      socket = sock;
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = 1;
      socket.write(json.encode(data));
      socket.listen((data) {
        final String response = String.fromCharCodes(data);
        List<dynamic> resp = json.decode(response);
        setState(() {
          countries = List<String>.from(resp as List);
        });
      },
          cancelOnError: false);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
    socket.close();
  }


  void get_cities() {
    Socket.connect('192.168.1.6', 4048).then((Socket sock) {
      socket = sock;
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = 2;
      data['data'] = dropdownCountryTo;
      socket.write(json.encode(data));
      socket.listen((data) {
        final String response = String.fromCharCodes(data);
        List<dynamic> resp = json.decode(response);
        setState(() {
          cities = List<String>.from(resp as List);
          print(cities);
        });
      },
          cancelOnError: false);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
    socket.close();
  }


  void get_tours() {
    Socket.connect('192.168.1.6', 4048).then((Socket sock) {
      socket = sock;
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = 3;
      data['country'] = dropdownCountryOf;
      data['city'] = dropdownCityOf;
      data['activity'] = activity_value.toString();
      data['people'] = people[people_type];
      data['priorities'] = priority.toString();
      data['countDay'] = day_value.toString();
      data['budget'] = budget[budget_type];
      data['uid'] = user.uid.toString();
      data['travelDate'] = travelDate.toString().split(" ")[0];
      socket.write(json.encode(data));
      socket.listen((data) {
        final String response = String.fromCharCodes(data);
        print(jsonDecode(jsonDecode(response))['Trip']);

      },
          cancelOnError: false);
    }).catchError((e) {
      print("Unable to connect: $e");
    });
    socket.close();
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.03, left: width * 0.02),
            child: Text('Создай своё путешествие!', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 36),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Страна', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5, top: height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 2)
            ),
            child: Center(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton(
                  menuMaxHeight: height * 0.5,
                  alignment: Alignment.center,
                  borderRadius: BorderRadius.circular(20),
                  value: dropdownCountryTo,
                  onChanged: (String? value) {
                    setState(() {
                      dropdownCountryTo = value!;
                      dropdownCityTo = 'Не указано';
                      get_cities();
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down),
                  underline: SizedBox(),
                  items: countries.map<DropdownMenuItem<String>>((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                    );
                  }).toList(),
                ),
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.03),
            child: Text('Город', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5, top: height * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 2)
              ),
              child: Center(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    menuMaxHeight: height * 0.5,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(20),
                    value: dropdownCityTo,
                    onChanged: (String? value) {
                      setState(() {
                        dropdownCityTo = value!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    items: cities.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                      );
                    }).toList(),
                  ),
                ),
              )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.03),
            child: Text('Оцените степень своей активности', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Slider(
              value: activity_value,
              activeColor: Colors.black,
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
                    selectedColor: Colors.black,
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
                      selectedColor: Colors.black,
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
                      avatar: Icon(priority_icons[index], color: priority.contains(priorities[index]) ? Colors.white : Colors.black,),
                      showCheckmark: false,
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
                      selectedColor: Colors.black,
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
            child: Text('На сколькой дней вы хотели бы отправиться в путешествие?', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
              child: Slider(
                value: day_value,
                activeColor: Colors.black,
                max: 30,
                min: 1,
                divisions: 29,
                label: day_value.round().toString(),
                onChanged: (value) {
                  setState(() {
                    day_value = value;
                  });
                },
              )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Какого числа вы планируете начать путешествие?', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    selectDate();
                  },
                  child: Text('Выбрать дату начала путешествия'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                  child: Text(travelDate.toString().split(" ")[0], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),),
                  decoration: BoxDecoration(
                    color: Color(0xFFedf0f8),
                    borderRadius: BorderRadius.circular(30)
                  ),
                )
              ],
            )
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Откуда вы начнёте путешествие?', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
              height: height * 0.05,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fromOf.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: width * 0.02),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: Text(fromOf[index], style: GoogleFonts.roboto(color: fromOf_type == index ? Colors.white : Colors.black),),
                      selected: fromOf_type == index,
                      onSelected: (value) {
                        setState(() {
                          fromOf_type = index;
                        });
                      },
                      selectedColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                  );
                },
              )
          ),
          fromOf[fromOf_type] == 'Другое место' ? Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5, top: height * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 2)
              ),
              child: Center(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    menuMaxHeight: height * 0.5,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(20),
                    value: dropdownCountryOf,
                    onChanged: (String? value) {
                      setState(() {
                        dropdownCountryOf = value!;
                        dropdownCityOf = 'Не указано';
                        get_cities();
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    items: countries.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                      );
                    }).toList(),
                  ),
                ),
              )
          ) : Container(),
          fromOf[fromOf_type] == 'Другое место' ? Container(
              margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5, top: height * 0.01),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 2)
              ),
              child: Center(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton(
                    menuMaxHeight: height * 0.5,
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(20),
                    value: dropdownCityOf,
                    onChanged: (String? value) {
                      setState(() {
                        dropdownCityOf = value!;
                      });
                    },
                    icon: Icon(Icons.arrow_drop_down),
                    underline: SizedBox(),
                    items: cities.map<DropdownMenuItem<String>>((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                      );
                    }).toList(),
                  ),
                ),
              )
          ) : Container(),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.02),
            child: Text('Напишите всё, что вы хотите видеть в своем туре', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            height: height * 0.2,
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            child: TextField(
              cursorColor: Colors.black,
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
                hintText: 'Введите Ваши пожелания, мы подберём для вас варианты',
                fillColor: Colors.grey.shade300,
                filled: true,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.3, right: width * 0.3, top: height * 0.02, bottom: height * 0.02),
            child: ElevatedButton(
              onPressed: () {
                get_tours();
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => GeneratedToursScreen()));
              },
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
