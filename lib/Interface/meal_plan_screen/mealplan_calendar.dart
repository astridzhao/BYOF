import 'package:astridzhao_s_food_app/core/app_export.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

late DateTime _focusedDay;
late DateTime _firstDay;
late DateTime _lastDay;
late DateTime _selectedDay;
late CalendarFormat _calendarFormat;

class MealPlanCalendar extends StatefulWidget {
  const MealPlanCalendar({Key? key}) : super(key: key);

  @override
  _MealPlanCalendarState createState() => _MealPlanCalendarState();
}

class _MealPlanCalendarState extends State<MealPlanCalendar> {
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.week;
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: TableCalendar(
          // initial dedfault setting
          firstDay: _firstDay,
          lastDay: _lastDay,
          focusedDay: _focusedDay,
          // set calendar format
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          // set decoration style
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              color: appTheme.green_primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(
              Icons.chevron_left,
              color: appTheme.green_primary,
            ),
            rightChevronIcon: Icon(
              Icons.chevron_right,
              color: appTheme.green_primary,
            ),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: appTheme.green_primary,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: appTheme.orange_primary,
              shape: BoxShape.circle,
            ),
          ),
          // set selected day
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        ));
  }
}
