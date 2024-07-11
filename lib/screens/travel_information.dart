import 'package:explore_mate/screens/tickets.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:google_fonts/google_fonts.dart';


class TravelInformation extends StatefulWidget {

  @override
  _TravelInformationState createState() => _TravelInformationState();
}


class _TravelInformationState extends State<TravelInformation> {

  final _controller = PageController();

  List<String> information = [
    'Поздравляем вас с выбором тура!',
    'Сейчас вам будут предложены способы добраться до места назначения. Также вы можете добраться своим ходом.'
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        itemCount: information.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, pageIndex) {
          return Column(
            children: [
              SafeArea(
                child: Container(
                    alignment: Alignment.topRight,
                    height: height * 0.1,
                    margin: EdgeInsets.only(right: width * 0.02),
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: information.length,
                      effect: ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.white,
                          dotHeight: width * 0.04,
                          dotWidth: width * 0.04
                      ),
                    )
                ),
              ),
              Container(
                child: Text(information[pageIndex], style: GoogleFonts.roboto(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),),
              ),
              Container(
                alignment: Alignment.bottomRight,
                margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1, top: height * 0.02, bottom: height * 0.02),
                child: ElevatedButton(
                  onPressed: () {
                    pageIndex == information.length - 1 ? Navigator.of(context).push(MaterialPageRoute(builder: (context) => TicketsScreen())) : _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.bounceInOut);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white
                  ),
                  child: Text('Далее', style: GoogleFonts.roboto(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}