import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/entry_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      //),
      home: EntryScreenPage(),
    );
  }
}

