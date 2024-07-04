import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late List<DateTime> _markedDates;

  @override
  void initState() {
    super.initState();
    _fetchStatuses();
  }

  Future<void> _fetchStatuses() async {
    try {
      // Fetch user ID from Firebase Authentication
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).collection('entries').get();
        List<DateTime> markedDates = [];
        snapshot.docs.forEach((doc) {
          String dateString = doc.id;
          List<String> dateParts = dateString.split('-');
          if (dateParts.length == 3) {
            int year = int.parse(dateParts[0]);
            int month = int.parse(dateParts[1]);
            int day = int.parse(dateParts[2]);
            DateTime date = DateTime(year, month, day);
            markedDates.add(date);
          }
        });
        setState(() {
          _markedDates = markedDates;
        });
      }
    } catch (e) {
      print('Error fetching statuses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: _buildCalendar(),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(fontSize: 20),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: 16),
        weekendStyle: TextStyle(fontSize: 16),
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) {
        return isSameDay(DateTime.now(), day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        // Handle day selection
      },
      onPageChanged: (focusedDay) {
        // Handle page change
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          return _buildMarkers(day);
        },
      ),
    );
  }

  Widget _buildMarkers(DateTime day) {
    if (_markedDates.contains(day)) {
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.red, // Change color to represent smoking day
          shape: BoxShape.circle,
        ),
      );
    } else {
      return Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Colors.green, // Change color to represent non-smoking day
          shape: BoxShape.circle,
        ),
      );
    }
  }
}
