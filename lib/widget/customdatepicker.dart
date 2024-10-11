import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_sensor_tracking_app/utils/app_color.dart';

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: BlackColor,
    //barrierColor: Colors.black.withOpacity(7),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: CustomDatePickerDialog(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        ),
      );
    },
  );
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  CustomDatePickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  _CustomDatePickerDialogState createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            DateFormat.yMMMM().format(_selectedDate!),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              return Expanded(
                child: Center(
                  child: Text(
                    DateFormat.E().format(DateTime(2021, 1, index + 4)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: CyanColor,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 8),
        Flexible(
          child: _buildDateGrid(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text(
                "CANCEL",
                style: TextStyle(
                  color: BlackColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(_selectedDate),
              child: Text(
                "DONE",
                style: TextStyle(
                  color: CyanColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateGrid() {
    final daysInMonth = DateUtils.getDaysInMonth(_selectedDate!.year, _selectedDate!.month);
    final firstDayOffset = DateTime(_selectedDate!.year, _selectedDate!.month, 1).weekday - 1; // 0 is Monday in this setup

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7 days in a week
      ),
      itemCount: daysInMonth + firstDayOffset,
      itemBuilder: (context, index) {
        if (index < firstDayOffset) {
          return Container();
        } else {
          final dayNumber = index - firstDayOffset + 1;
          final date = DateTime(_selectedDate!.year, _selectedDate!.month, dayNumber);

          final isCurrentDate = DateTime.now().day == dayNumber &&
              DateTime.now().month == _selectedDate!.month &&
              DateTime.now().year == _selectedDate!.year;

          final isFirst12Days = dayNumber <= 12;

          return GestureDetector(
            onTap: () => _onDateSelected(date),
            child: Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: isCurrentDate
                    ? Border.all(color: CyanColor, width: 2)
                    : null,
                color: isCurrentDate
                    ? CyanColor
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  "$dayNumber",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isCurrentDate
                        ? WhiteColor
                        : (isFirst12Days ? PinkSwanColor : Colors.black),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
