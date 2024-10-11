import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/add_task_screen.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final List<String> _items = [];
  final TextEditingController _controller = TextEditingController();

  // Method to add item and navigate to TaskPage using GetX
  void _addItemAndNavigate() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _items.add(_controller.text);
        _controller.clear();
      });

      // Navigate to TaskPage and pass the entered task as a parameter
      Get.to(() => TaskPage(taskHeadline: _items.last));  // Pass the last entered task
    } else {
      // Show a message if no text was entered
      Get.snackbar(
        'Error',
        'Please enter a task to add it!',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddScreenText1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: AddTaskScreenText2,
                hintStyle: TextStyle(
                  color: DarkgreyColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
                contentPadding: EdgeInsets.only(left: 20),
              ),
              onSubmitted: (value) => _addItemAndNavigate(),
            ),
          ],
        ),
      ),
    );
  }
}

