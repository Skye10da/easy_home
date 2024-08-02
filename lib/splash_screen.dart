import 'dart:async';
import 'package:easy_home/home.dart';
import 'package:easy_home/utilities/ui/screen_size.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late final Screen size = Screen(MediaQuery.of(context).size);

  void nav() {
    Timer(const Duration(seconds: 6), () {
      navigateFromSplash();
    });
  }

  @override
  void initState() {
    super.initState();
    nav();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: size.hp(20),
          ),
          Center(
            child: Image.asset(
              'assets/icon.png',
              width: 50,
              height: 50,
            ),
          ),
          SizedBox(
            height: size.hp(5),
          ),
          Center(
            child: Text(
              'Easy Home',
              style: TextStyle(
                // color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
                fontSize: size.hp(4),
              ),
            ),
          ),
          SizedBox(
            height: size.hp(10),
          ),
          Center(
            child: Image.asset('assets/city-unscreen.gif' // white gif
                ),
          ),
        ],
      ),
    );
  }

  Future navigateFromSplash() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Home(title: "Easy Home"),
      ),
    );
  }
}
