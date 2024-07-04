import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late String uid;
  double pricePerCigarette = 0.0;
  late int numCigarettes;
  late int smokingDays;
  late int nonSmokingDays;
  late String latestEntryStatus;

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
          pricePerCigarette = snapshot.data()?['price_per_cigarette'] ?? 0.0;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user data: $e');
      }
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
        // Get the latest entry status
        latestEntryStatus = snapshot.docs.isEmpty ? '' : snapshot.docs.last.data()['status'];
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching smoking days: $e');
      }
    }
  }

  double _calculateTotalSavings() {
    return numCigarettes * pricePerCigarette * nonSmokingDays;
  }

  double _calculateExpenseToday() {
    // If there's no latest entry status or if it's 'Yes' (smoked), then the expense today will be 0
    if (latestEntryStatus == 'Yes') {
      return numCigarettes * pricePerCigarette;
    }
    else { // Otherwise, calculate the expense for the day
      return 0.0;
    }
  }

  double _calculateDailySavings() {
    // If there's no latest entry status or if it's 'No' (did not smoke), then calculate the savings for the day
    if (latestEntryStatus == 'No') {
      return numCigarettes * pricePerCigarette;
    }
    else{
      return 0.0;
    }
  }

  double _calculateTotalSpent() {
    return numCigarettes * pricePerCigarette * smokingDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallet',
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
              title: 'Total Amount Saved',
              value: '\u20B9${_calculateTotalSavings().toStringAsFixed(2)}',
              icon: Icons.attach_money,
              color: Colors.green,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Expense Today',
              value: '\u20B9${_calculateExpenseToday().toStringAsFixed(2)}',
              icon: Icons.money_off,
              color: Colors.red,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Savings Today',
              value: '\u20B9${_calculateDailySavings().toStringAsFixed(2)}',
              icon: Icons.monetization_on,
              color: Colors.green,
            ),
            const SizedBox(height: 20.0),
            _buildInfoCard(
              title: 'Total Amount Spent',
              value: '\u20B9${_calculateTotalSpent().toStringAsFixed(2)}',
              icon: Icons.money_off,
              color: Colors.red,
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
