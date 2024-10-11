import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/sensor_data_screen.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/todo_splaashscreen.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';

class EntryScreenPage extends StatelessWidget {
  const EntryScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.to(TodoSplaashscreen());
                },
              style: ElevatedButton.styleFrom(
                backgroundColor: CyanColor,
                padding: EdgeInsets.symmetric(horizontal: 56, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
                child: Text(
                  EntryScreenPageText,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: BlackColor,
                  ),
                ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(SensorDataScreen());
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: RoyalBlueColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )
              ),
              child: Text(
                EntryScreenPageText1,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: WhiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
