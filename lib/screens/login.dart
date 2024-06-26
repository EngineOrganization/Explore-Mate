import 'package:explore_mate/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/explore_mate.png', width: width * 0.3,),
          Container(
            margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2, top: height * 0.05),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 18
                ),
                prefixIcon: Icon(Icons.email, color: Colors.black45,),
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFedf0f8),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.2, right: width * 0.2, top: height * 0.02),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.black45,
                      fontSize: 18
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.black45,),
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Color(0xFFedf0f8),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)
                  )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.01),
            child: Text('Забыли пароль?'),
          ),
          Container(
            margin: EdgeInsets.only(top: height * 0.02),
            width: width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                signIn();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
              ),
              child: Text('Войти', style: GoogleFonts.roboto(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
            ),
          ),
         Container(
           margin: EdgeInsets.only(top: height * 0.02),
           child:  Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text('Нет аккаунта?', style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),),
               GestureDetector(
                 onTap: () {},
                 child: Text(' Зарегистрироваться', style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
               )
             ],
           ),
         )
        ],
      ),
    );
  }


  void signIn() async {
    print(emailController.text);
    print(passwordController.text);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } catch (e) {
      print(e);
    }
  }
}