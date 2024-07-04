import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      backgroundColor: const Color(0xFF2B2B2B), // Set the background color of the Scaffold
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200, // Set a fixed height for the image container
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/breakthehabit.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Text(
                  'About Us',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'At QuitSmokingApp, our mission is to help you break free from the harmful habit of smoking and lead a healthier life. We understand the challenges and struggles that come with quitting smoking, and we are here to support you every step of the way.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white, // Text color
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 40), // Increased space for better separation
            const Center(
              child: Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  'Our Team',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color
                  ),
                ),
              ),
            ),
            // Use Card widgets to display team members
            buildTeamMemberCard('assets/profile1.jpg', 'Rohan Gunge', 'Dev'),
            buildTeamMemberCard('assets/profile2.jpg', 'Neha Nair', 'Dev'),
            buildTeamMemberCard('assets/profile1.jpg', 'Ashish Varghese', 'Dev'),
            buildTeamMemberCard('assets/profile1.jpg', 'Vijay Gupta', 'Dev'),
            // Add more team members as needed
          ],
        ),
      ),
    );
  }

  // Helper method to build team member card
  Widget buildTeamMemberCard(String imagePath, String name, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color(0xFF3B3B3B), // Set background color of the Card
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(imagePath),
          ),
          title: Text(
            name,
            style: const TextStyle(color: Colors.white), // Text color
          ),
          subtitle: Text(
            role,
            style: const TextStyle(color: Colors.white), // Text color
          ),
        ),
      ),
    );
  }
}