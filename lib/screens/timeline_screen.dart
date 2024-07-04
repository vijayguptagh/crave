import 'package:flutter/material.dart';
import '../models/timeline_date.dart';

class TimelinePage extends StatelessWidget {
  final List<TimelineDay> daysList;

  const TimelinePage({Key? key, required this.daysList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 31, 206), // Updated background color
        elevation: 0, // Remove elevation
        centerTitle: true, // Center the title
        title: const Text(
          'Timeline',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White color for the "Timeline" text
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 237, 247, 246), // Light blue color for gradient start
              Color.fromARGB(255, 220, 235, 233), // Lighter blue color for gradient end
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Your Timeline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: daysList.length,
                  itemBuilder: (context, index) {
                    final day = daysList[index];
                    return Card(
                      elevation: 3.0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          day.dayNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          day.changes,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}