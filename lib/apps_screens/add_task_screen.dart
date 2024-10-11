import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_sensor_tracking_app/apps_screens/inside_task_screen.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';
import 'package:to_do_sensor_tracking_app/widget/customdatepicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';


class TaskPage extends StatefulWidget {

  final String taskHeadline;

  TaskPage({required this.taskHeadline});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  bool _isTextEntered = false;
  bool _showCircleAvatar = true;
  bool _isChecked = false;


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();


    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _controller.addListener(_handleTextChanged);
    _loadTasks();
  }

  void _handleTextChanged() {
    setState(() {
      _isTextEntered = _controller.text.isNotEmpty;
      _showCircleAvatar = true;
    });
  }

  void _addTask(String task) {
    if (task.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a task before submitting!'),
        ),
      );
      return;
    }

    if (_selectedDate == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a due date before submitting!'),
        ),
      );
      return;
    }

    DateTime now = DateTime.now();

    setState(() {
      _tasks.add(Task(
        name: task.trim(),
        isCompleted: false,
        dueDate: _selectedDate,
      ));


      int notificationId = _tasks.length;


      if (_selectedDate!.year == now.year &&
          _selectedDate!.month == now.month &&
          _selectedDate!.day == now.day) {

        _scheduleNotification(task, notificationId);
      } else {

        _scheduleNotificationForDate(task, _selectedDate!, notificationId);
      }
    });

    _controller.clear();
    _selectedDate = null;
    _isTextEntered = false;
    _showCircleAvatar = false;

    Future.delayed(Duration(seconds: 30), () {
      _controller.clear();
      setState(() {
        _isTextEntered = false;
      });
    });
  }



  Future<void> _scheduleNotification(String task, int notificationId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for tasks due today',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Task Due Today',
      'Your task "$task" is due today!',
      platformChannelSpecifics,
      payload: task,
    );
  }


  Future<void> _scheduleNotificationForDate(
      String task, DateTime dueDate, int notificationId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'task_channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);


    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      'Task Reminder',
      'Your task "$task" is due on ${DateFormat.yMMMd().format(dueDate)}!',
      tz.TZDateTime.from(dueDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }



  void _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskListJson = prefs.getStringList(widget.taskHeadline);

    if (taskListJson != null) {
      setState(() {
        _tasks.addAll(taskListJson.map((taskJson) {
          final Map<String, dynamic> taskMap = jsonDecode(taskJson);
          return Task(
            name: taskMap['name'],
            isCompleted: taskMap['isCompleted'],
            dueDate: taskMap['dueDate'] != null
                ? DateTime.parse(taskMap['dueDate'])
                : null,
          );
        }).toList());
      });
    }
  }


  void _saveAllTasks() async {
    if (_tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No tasks added. Please add a task to save.'),
        ),
      );
      return;
    }

    List<String> taskListJson = _tasks.map((task) {
      return jsonEncode({
        'name': task.name,
        'isCompleted': task.isCompleted,
        'dueDate': task.dueDate?.toIso8601String(),
      });
    }).toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.taskHeadline, taskListJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All tasks saved successfully!'),
      ),
    );
    Get.back();
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddScreenText1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 25, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CyanColor,
                  ),
                  onPressed: _saveAllTasks,
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: WhiteColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 260),
            child: Text(
              widget.taskHeadline,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _tasks.isEmpty
                ? Center(child: Text('No tasks yet'))
                : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: WhiteColor,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: _tasks[index].isCompleted,
                      onChanged: (bool? value) {
                        _toggleTaskCompletion(index);
                      },
                      activeColor: RoyalBlueColor,
                      checkColor: WhiteColor,
                    ),
                    title: Text(
                      _tasks[index].name,
                      style: TextStyle(
                        decoration: _tasks[index].isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: _tasks[index].dueDate != null
                        ? Text(
                      '${DateFormat.yMMMd().format(_tasks[index].dueDate!)}',
                      style: TextStyle(
                        color: PompeiiAshColor,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                        : null,
                    trailing: Icon(
                      _tasks[index].isCompleted
                          ? Icons.star
                          : Icons.star_border,
                      color: _tasks[index].isCompleted
                          ? CyanColor
                          : DarkcharcoaColor,
                      size: 35,
                    ),
                    onTap: () {
                      Get.to(
                        TaskDetailsScreen(
                          taskName: _tasks[index].name,
                          dueDate: _tasks[index].dueDate!,
                          folderTasks: [],
                          onTaskDeleted: () {

                            setState(() {
                              _tasks.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: AddaskScreenText1,
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          prefixIcon: Checkbox(
                            value: _isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked = newValue ?? false;
                              });
                            },
                            activeColor: CyanColor,
                          ),
                          suffixIcon: _showCircleAvatar
                              ? CircleAvatar(
                            radius: 20,
                            backgroundColor: _isTextEntered
                                ? CyanColor
                                : PompeiiAshColor,
                               child: FloatingActionButton(
                              onPressed: _isTextEntered
                                  ? () {
                                _addTask(_controller.text);
                                setState(() {
                                  _isChecked = true;
                                });
                                Future.delayed(
                                    Duration(seconds: 2), () {
                                  setState(() {
                                    _isChecked = false;
                                  });
                                });
                              }
                                  : null,
                              mini: true,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              child: Icon(
                                Icons.check,
                                color: WhiteColor,
                              ),
                            ),
                          )
                              : null,
                        ),
                        onChanged: (text) {
                          setState(() {
                            _isTextEntered = text.isNotEmpty;
                            _showCircleAvatar = true;
                          });
                        },
                        onSubmitted: (text) {
                          _addTask(text);
                          setState(() {
                            _showCircleAvatar = false;
                            _isTextEntered = false;
                            _isChecked = true;
                          });
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              _isChecked = false;
                            });
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        if (_selectedDate != null && _controller.text.isNotEmpty) {
                          _scheduleNotificationForDate(
                            _controller.text,
                            _selectedDate!,
                            _tasks.length,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Notification scheduled for the task'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please select a due date for the task'),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.note),
                      onPressed: () {

                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                    if (_selectedDate != null)
                      Text(
                        DateFormat.yMMMd().format(_selectedDate!),
                        style: TextStyle(
                          color: CyanColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class Task {
  String name;
  bool isCompleted;
  DateTime? dueDate;

  Task({required this.name, required this.isCompleted, this.dueDate});
}


