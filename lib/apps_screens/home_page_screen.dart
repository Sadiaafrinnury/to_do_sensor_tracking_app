import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/list_screen.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/app_image_const.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';
import 'add_task_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Map<String, List<String>> headlineTasks = {};

  @override
  void initState() {
    super.initState();
    _loadHeadlinesAndTasks();
  }

  void _loadHeadlinesAndTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      headlineTasks = prefs.getKeys().fold<Map<String, List<String>>>({}, (map, key) {
        map[key] = prefs.getStringList(key) ?? [];
        return map;
      });
    });
  }

  void _refreshHeadlines() {
    _loadHeadlinesAndTasks(); // Reload tasks
  }

  Future<void> _deleteHeadline(String headline) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(headline); // Remove the headline and its associated tasks
    _refreshHeadlines(); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(ProfileImage),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomePageScreenText,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      HomePageScreenText1,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: PompeiiAshColor,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            Divider(color: PompeiiAshColor),
            Expanded(
              child: ListView.builder(
                itemCount: headlineTasks.keys.length,
                itemBuilder: (context, index) {
                  String headline = headlineTasks.keys.elementAt(index);
                  int taskCount = headlineTasks[headline]?.length ?? 0;

                  return ListTile(
                    leading: Icon(Icons.task, color: CyanColor),
                    title: Text(
                      '$headline',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      '$taskCount tasks',
                      style: TextStyle(
                        fontSize: 14,
                        color: PompeiiAshColor,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: CyanColor),
                      onPressed: () {
                        _showDeleteConfirmationDialog(headline);
                      },
                    ),
                    onTap: () async {
                      final result = await Get.to(() => TaskPage(taskHeadline: headline));

                      if (result == true) {
                        _refreshHeadlines();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CircleAvatar(
        radius: 25,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Get.to(ListPage());
            if (result == true) {
              _refreshHeadlines();
            }
          },
          backgroundColor: CyanColor,
          child: Icon(
            Icons.add,
            color: WhiteColor,
          ),
        ),
      ),
    );
  }

  // Show confirmation dialog before deletion
  void _showDeleteConfirmationDialog(String headline) {
    Get.dialog(
      AlertDialog(
        title: Text('Delete Headline'),
        content: Text('Are you sure you want to delete "$headline" and its tasks?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog without deleting
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteHeadline(headline); // Delete the headline
              Get.back(); // Close the dialog after deletion
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}







