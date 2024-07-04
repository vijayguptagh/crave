import 'package:cravecrush/screens/user_exp_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravecrush/screens/user_profile_screen.dart';
import 'about_us.dart';
import 'stats_screen.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Text('User not logged in');
          } else {
            User? user = snapshot.data;
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                  return const Text('User data not found');
                } else {
                  Map<String, dynamic>? userData = userSnapshot.data!.data();
                  if (userData == null) {
                    return const Text('User data not found');
                  }
                  String? firstName = userData['first_name'] as String?;
                  String? lastName = userData['last_name'] as String?;
                  String? email = user.email;
                  return ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text("$firstName $lastName"),
                        accountEmail: Text(email ?? ''),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_circle),
                        title: const Text('Profile'),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage(uid: user.uid)),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text('User Experiences'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ExperiencePage()),
                          );
                          },
                      ),
                      ListTile(
                        leading: const Icon(Icons.line_axis),
                        title: const Text('Stats'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const StatsPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.info),
                        title: const Text('About us'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUsPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () => FirebaseAuth.instance.signOut(),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
