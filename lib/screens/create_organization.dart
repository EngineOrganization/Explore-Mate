import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CreateOrganizationScreen extends StatefulWidget {

  @override
  _CreateOrganizationScreenState createState() => _CreateOrganizationScreenState();
}


class _CreateOrganizationScreenState extends State<CreateOrganizationScreen> {

  int choice = 0;

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
            child: Text('Название', style: GoogleFonts.roboto(color: Colors.black, fontSize: 20)),
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
              child: Text('Вид деятельности', style: GoogleFonts.roboto(color: Colors.black, fontSize: 20))
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('Ресторан'),
                  selected: choice == 0,
                  onSelected: (value) {
                    setState(() {
                      choice = 0;
                    });
                  },
                  selectedColor: Color(0xFF5e6488),
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                ChoiceChip(
                  label: Text('Кафе'),
                  selected: choice == 1,
                  onSelected: (value) {
                    setState(() {
                      choice = 1;
                    });
                  },
                  selectedColor: Color(0xFF5e6488),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}