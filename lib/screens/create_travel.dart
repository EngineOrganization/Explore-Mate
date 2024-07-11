import 'dart:convert';
import 'package:explore_mate/screens/generated_tours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:dropdown_button2/dropdown_button2.dart';


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

  Map<String, Map<String, String>> countries = {};
  Map<String, Map<String, String>> countries_copy = {};
  Map<String, String> cities_to = {};
  Map<String, String> cities_copy_to = {};
  Map<String, String> cities_of = {};
  Map<String, String> cities_copy_of = {};
  Set<String> priority = {};
  String? dropdownCountryTo;
  String? dropdownCityTo;
  String? dropdownCountryOf;
  String? dropdownCityOf;

  final TextEditingController textEditingControllerCountryTo = TextEditingController();
  final TextEditingController textEditingControllerCityTo = TextEditingController();
  final TextEditingController textEditingControllerCountryOf = TextEditingController();
  final TextEditingController textEditingControllerCityOf = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('places');
    ref.onValue.listen((DatabaseEvent event) {
      countries = {};
      final snapshot = event.snapshot;
      snapshot.child('countries').children.forEach((country) {
        countries[country.child('name').value.toString()] = {'code': country.key.toString(), 'flag': country.child('flag').value.toString()};
      });
      setState(() {
        countries_copy = countries;
      });
    });
  }


  void get_cities(bool to) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('places');
    ref.onValue.listen((DatabaseEvent event) {
      final snapshot = event.snapshot;
      to ? cities_to = {} : cities_of = {};
      snapshot.child('countries').child(countries[to ? dropdownCountryTo.toString() : dropdownCountryOf.toString()]!['code'].toString()).child('cities').children.forEach((city) {
        to ? cities_to[city.key.toString()] = city.value.toString() : cities_of[city.key.toString()] = city.value.toString();
      });
      setState(() {
        to ? cities_copy_to = cities_to : cities_copy_of = cities_of;
      });
    });
  }


  void get_tours() {
    Socket.connect('192.168.1.4', 4048).then((Socket sock) {
      socket = sock;
      Map<String, dynamic> data = new Map<String, dynamic>();
      data['type'] = 3;
      data['countryTo'] = dropdownCountryTo;
      data['cityTo'] = dropdownCityTo;
      data['countryOf'] = dropdownCountryOf;
      data['cityOf'] = dropdownCityOf;
      data['iata_of'] = cities_of[dropdownCityOf];
      data['iata_to'] = cities_of[dropdownCityTo];
      data['activity'] = activity_value.toString();
      data['people'] = people[people_type];
      data['priorities'] = priority.toString();
      data['countDay'] = day_value.toString();
      data['budget'] = budget[budget_type];
      data['uid'] = user.uid.toString();
      data['travelDate'] = travelDate.toString().split(" ")[0];
      data['countryCode'] = countries[dropdownCountryTo]!['code'];
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
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.005, top: height * 0.005),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFedf0f8)
            ),
            child: DropdownButton2(
              isExpanded: true,
              value: dropdownCountryTo,
              hint: Text(
                'Select country',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: countries_copy.keys.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                      Container(
                        height: 15,
                        width: 25,
                        child: SvgPicture.network(countries_copy[item]!['flag'].toString(), fit: BoxFit.fill,),
                      )
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownCountryTo = value.toString();
                  get_cities(true);
                });
              },
              buttonStyleData: ButtonStyleData(
                width: width * 0.5,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: height * 0.4
              ),
              underline: Container(),
              dropdownSearchData: DropdownSearchData(
                  searchController: textEditingControllerCountryTo,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingControllerCountryTo,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFedf0f8),
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          hintText: 'Find a place',
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  }
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingControllerCountryTo.clear();
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02, top: height * 0.03),
            child: Text('Город', style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.005, top: height * 0.005),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFedf0f8)
            ),
            child: DropdownButton2(
              isExpanded: true,
              value: dropdownCityTo,
              hint: Text(
                'Select city',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: cities_copy_to.keys.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownCityTo = value.toString();
                });
              },
              buttonStyleData: ButtonStyleData(
                width: width * 0.5,
              ),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: height * 0.4
              ),
              underline: Container(),
              dropdownSearchData: DropdownSearchData(
                  searchController: textEditingControllerCityTo,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingControllerCityTo,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFedf0f8),
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          hintText: 'Find a place',
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  }
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingControllerCityTo.clear();
                }
              },
            ),
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
            margin: EdgeInsets.only(left: width * 0.02),
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    selectDate();
                  },
                  child: Text('Выбрать дату начала путешествия', style: TextStyle(fontSize: 10),),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.only(top: 2, bottom: 2, left: 4, right: 4)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                  margin: EdgeInsets.only(left: width * 0.1),
                  child: Text(travelDate.toString().split(" ")[0], style: GoogleFonts.roboto(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
                  decoration: BoxDecoration(
                    color: Color(0xFFedf0f8),
                    borderRadius: BorderRadius.circular(20)
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
              margin: EdgeInsets.only(left: width * 0.02),
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
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.005, top: height * 0.005),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFedf0f8)
            ),
            child: DropdownButton2(
              isExpanded: true,
              value: dropdownCountryOf,
              hint: Text(
                'Select country',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: countries_copy.keys.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownCountryOf = value.toString();
                  get_cities(false);
                });
              },
              buttonStyleData: ButtonStyleData(
                width: width * 0.5,
              ),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: height * 0.4
              ),
              underline: Container(),
              dropdownSearchData: DropdownSearchData(
                  searchController: textEditingControllerCountryOf,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingControllerCountryOf,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFedf0f8),
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          hintText: 'Find a place',
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  }
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingControllerCountryOf.clear();
                }
              },
            ),
          ) : Container(),
          fromOf[fromOf_type] == 'Другое место' ? Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.005, top: height * 0.005),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFedf0f8)
            ),
            child: DropdownButton2(
              isExpanded: true,
              value: dropdownCityOf,
              hint: Text(
                'Select city',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: cities_copy_of.keys.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownCityOf = value.toString();
                });
              },
              buttonStyleData: ButtonStyleData(
                width: width * 0.5,
              ),
              dropdownStyleData: DropdownStyleData(
                  maxHeight: height * 0.4
              ),
              underline: Container(),
              dropdownSearchData: DropdownSearchData(
                  searchController: textEditingControllerCityOf,
                  searchInnerWidgetHeight: 60,
                  searchInnerWidget: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 4,
                      right: 8,
                      left: 8,
                    ),
                    child: TextFormField(
                      expands: true,
                      maxLines: null,
                      controller: textEditingControllerCityOf,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFedf0f8),
                          prefixIcon: Icon(Icons.search),
                          isDense: true,
                          hintText: 'Find a place',
                          hintStyle: TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value.toString().contains(searchValue);
                  }
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingControllerCityOf.clear();
                }
              },
            ),
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
            margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1, top: height * 0.02, bottom: height * 0.02),
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
