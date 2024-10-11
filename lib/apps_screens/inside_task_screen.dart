import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';
import 'package:to_do_sensor_tracking_app/utils/text_const.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskName;
  final DateTime dueDate;
  final List<String> folderTasks;
  final VoidCallback onTaskDeleted;

  TaskDetailsScreen({
    required this.taskName,
    required this.dueDate,
    required this.folderTasks,
    required this.onTaskDeleted,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  TextEditingController _noteController = TextEditingController();
  String _note = '';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _showNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              Addnote,
          ),
          content: TextField(
            controller: _noteController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Enter your note here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                  Cancel
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _note = _noteController.text;
                });
                Get.back();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note saved!')),
                );
              },
              child: Text(
                  Save
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: WhiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '"${widget.taskName}" will be permanently deleted.',
                style: TextStyle(fontSize: 16, color: BlackColor),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Get.back();
                  _deleteTask();
                },
                child: Text(
                  'Delete Task',
                  style: TextStyle(color: RedColor, fontSize: 16),
                ),
              ),
              Divider(),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  Cancel,
                  style: TextStyle(color: CyanColor, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTask() {
    setState(() {
      widget.folderTasks.remove(widget.taskName);
    });

    widget.onTaskDeleted();

    Get.back(result: true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: WhiteColor,
        elevation: 0,
        titleTextStyle: TextStyle(color: BlackColor, fontSize: 20),
        iconTheme: IconThemeData(color: BlackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Remind Me'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reminder set for ${widget.dueDate.toLocal()}'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Row(
                children: [
                  Text('Due '),
                  Text(
                    '${widget.dueDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(color: CyanColor),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.note_add_outlined),
              title: Text(_note.isNotEmpty ? 'Edit Note' : 'Add Note'),
              subtitle: _note.isNotEmpty
                  ? Text(
                _note,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: DarkgreyColor),
              )
                  : null,
              onTap: _showNoteDialog,
            ),
            Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  _showDeleteConfirmation(context);
                },
                icon: Icon(Icons.delete,
                    color: RedColor),
                label: Text(
                  'Delete',
                  style: TextStyle(color: RedColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}






