import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:google_fonts/google_fonts.dart';

class TestScreen extends StatefulWidget {

  _TestScreenState createState() => _TestScreenState();
}


class _TestScreenState extends State<TestScreen> {

  List<String> countries_copy = ['Не указано', 'Россия', 'пнггпнгнге', '3', '4', '5', '6'];

  String? country;
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: width * 0.02, right: width * 0.5),
            padding: EdgeInsets.only(left: width * 0.01, right: width * 0.01, bottom: height * 0.005, top: height * 0.005),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFedf0f8)
            ),
            child: DropdownButton2(
              value: country,
              hint: Text(
                'Select country',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: countries_copy.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: GoogleFonts.roboto(color: Colors.black),),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  country = value.toString();
                });
              },
              buttonStyleData: ButtonStyleData(
                width: width * 0.5,
              ),
              underline: Container(),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
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
                    controller: textEditingController,
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
                  textEditingController.clear();
                }
              },
            ),
          )
        ],
      ),
    );
  }
}