import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isConnected = false;
  bool isTrying = false;
  bool serviceEnabled = false;
  bool isPermissionEnalbed = false;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .3),
                child: Image.asset(
                  "assets/images/eye.png",
                  height: 150,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                child: const Text(
                  "Your app name",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
                backgroundColor: Colors.white, minHeight: 2),
          )
        ],
      ),
    );
  }
}
