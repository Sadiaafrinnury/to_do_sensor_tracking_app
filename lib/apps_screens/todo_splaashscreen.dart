import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/home_page_screen.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/app_image_const.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';

class TodoSplaashscreen extends StatefulWidget {
  const TodoSplaashscreen({super.key});

  @override
  State<TodoSplaashscreen> createState() => _TodoSplaashscreenState();
}

class _TodoSplaashscreenState extends State<TodoSplaashscreen> {
  bool _showGif = true;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 6), () {
      setState(() {
        _showGif = false;
      });
      Get.to(HomePageScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: WhiteColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showGif)
                Image(
                    image: AssetImage(
                        TaskImage,
                    ),
                  height: 150,
                ),
              SizedBox(height: 20),
              Text(
                ToDoSplashScreenText,
                style: GoogleFonts.sigmar(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: BlackColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
