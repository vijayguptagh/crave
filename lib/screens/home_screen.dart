import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravecrush/models/timeline_date.dart';
import 'package:cravecrush/screens/alert_screen.dart';
import 'package:cravecrush/screens/guide_screen.dart';
import 'package:cravecrush/screens/login_screen.dart';
import 'package:cravecrush/screens/navbar_screen.dart';
import 'package:cravecrush/screens/wallet_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'timeline_screen.dart';
import 'dart:ui' show lerpDouble; // Add this import for lerpDouble

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final List<TimelineDay> daysList;
  final TextEditingController _entryController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    daysList = getDummyTimelineDays();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _navigateToGuidePage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewsHomePage()),
    );
  }

  void _navigateToWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WalletPage()),
    );
  }

  void _navigateToHealthPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimelinePage(daysList: daysList)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color accentColor = Theme.of(context).colorScheme.secondary;

    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E5),
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text(
          'Quit Smoke',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF5A301C),
                borderRadius: BorderRadius.circular(0.0),
              ),
              margin: const EdgeInsets.all(0.0),
              padding: const EdgeInsets.all(20.0),
              height: MediaQuery.of(context).size.height / 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/title.png',
                      width: 600, // Adjust width as needed
                      height: 80, // Adjust height as needed
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      'assets/images/homepage.png',
                      width: 400, // Adjust width as needed
                      height: 180, // Adjust height as needed
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 2), // Add space between image and smoke-free hours
                    FutureBuilder<int>(
                      future: _fetchSmokeFreeHours(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int smokeFreeHours = snapshot.data ?? 0;
                          return Column(
                            children: [
                              Text(
                                'Smoke-Free Hours:',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2.0,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              // Add space between text and value
                              Text(
                                '$smokeFreeHours',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 2.0,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: const Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10), // Add space between smoke-free hours and button
                    ElevatedButton(
                      onPressed: () {
                        _showSmokeEntryDialog(context);
                      },
                      child: const Text('Smoked a Cigarette today?',
                        style: TextStyle(
                          color: Color(0xFF5A301C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 110,
                  height: 100,
                  child: _buildIconButton('Wallet', Icons.account_balance_wallet),
                ),
                SizedBox(
                  width: 110,
                  height: 100,
                  child: _buildIconButton('Health Progress', Icons.favorite),
                ),
                SizedBox(
                  width: 110,
                  height: 100,
                  child: _buildIconButton('Guide', Icons.book),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildEmergencySupportButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(String label, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        if (label == 'Guide') {
          _navigateToGuidePage();
        } else if (label == 'Wallet') {
          _navigateToWalletPage();
        } else if (label == 'Health Progress') {
          _navigateToHealthPage();
        } else {
          // Perform action when other buttons are pressed
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySupportButton() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(30),
                shape: const CircleBorder(),
                backgroundColor: Colors.red,
              ),
              child: Stack(
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.white,
                    size: 40,
                  ),
                  Positioned.fill(
                    child: Container(
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: SmokePainter(_animation.value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSmokeEntryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Smoking Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                _submitSmokeEntry('Yes');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your entry for today has been submitted.'),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _submitSmokeEntry('No');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your entry for today has been submitted.'),
                  ),
                );
              },
              child: const Text('No'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSmokeEntry(String smokingStatus) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      DateTime now = DateTime.now();
      String formattedDate = '${now.year}-${now.month}-${now.day}';

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('entries')
            .doc(formattedDate)
            .set({
          'status': smokingStatus,
        });
        print('Entry added successfully');
      } catch (e) {
        print('Error adding entry: $e');
      }
    } else {
      print('User is not logged in');
    }
  }

  Future<int> _fetchSmokeFreeHours() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        // Get all entries for the current user
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('entries')
            .get();

        // Initialize smoke-free hours
        int smokeFreeHours = 0;

        // Iterate through all entries
        snapshot.docs.forEach((doc) {
          Map<String, dynamic> data = doc.data();
          String status = data['status'];
          if (status == 'No') {
            smokeFreeHours += 24; // Assuming each entry represents 24 hours of being smoke-free
          }
        });

        return smokeFreeHours;
      } catch (e) {
        print('Error fetching smoke-free hours: $e');
        return 0;
      }
    } else {
      print('User is not logged in');
      return 0;
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}

class SmokePainter extends CustomPainter {
  final double animationValue;

  SmokePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // Create smoke effect using a series of circles with varying opacity
    final Paint paint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final double maxSize = size.width * 0.8;
    final double minSize = size.width * 0.6;
    final double distance = size.width * 0.3;

    for (int i = 0; i < 10; i++) {
      final double circleSize = lerpDouble(minSize, maxSize, i / 10)!;
      final double circleOpacity = lerpDouble(0.1, 0.2, i / 10)!;
      paint.color = paint.color.withOpacity(circleOpacity);
      final Offset offset = Offset(distance * sin(animationValue * pi * 2), i * 10.0);
      canvas.drawCircle(offset, circleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}