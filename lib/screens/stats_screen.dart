import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late String uid;
  late int numCigarettes;
  late int smokingDays;
  late int nonSmokingDays;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
      _fetchUserData();
    }
  }

  void _fetchUserData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        setState(() {
          numCigarettes = snapshot.data()?['num_cigarettes'] ?? 0;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    _fetchSmokingDays();
  }

  void _fetchSmokingDays() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('entries').get();
      setState(() {
        smokingDays = snapshot.docs.where((doc) => doc.data()['status'] == 'Yes').length;
        nonSmokingDays = snapshot.docs.where((doc) => doc.data()['status'] == 'No').length;
      });
    } catch (e) {
      print('Error fetching smoking days: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int smokeFreeHours = nonSmokingDays * 24;
    int totalCigarettesAvoided = numCigarettes * nonSmokingDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stats',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Total No of Days',
              value: '${smokingDays + nonSmokingDays}',
              icon: Icons.calendar_today,
              color: Colors.blue,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'No of Smoking Days',
              value: '$smokingDays',
              icon: Icons.smoking_rooms,
              color: Colors.red,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'No of Non-Smoking Days',
              value: '$nonSmokingDays',
              icon: Icons.check_circle_outline,
              color: Colors.green,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Smoke-Free Hours',
              value: '$smokeFreeHours',
              icon: Icons.hourglass_empty,
              color: Colors.orange,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Total Cigarettes Avoided',
              value: '$totalCigarettesAvoided',
              icon: Icons.cancel,
              color: Colors.purple,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String value, required IconData icon, required Color color}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24.0,
                ),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ],
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
