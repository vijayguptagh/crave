import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({Key? key}) : super(key: key);

  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  late String uid;
  late List<String> allExperiences;
  late List<String> myExperiences;
  final TextEditingController _experienceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _fetchAllExperiences();
    _fetchUserExperiences();
  }

  void _getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  void _fetchAllExperiences() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      List<String> experiences = [];
      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
          if (doc.id != uid && doc.data().containsKey('experiences')) {
            List<String> userExperiences = List<String>.from(
                doc.data()['experiences'].map((experience) => experience as String));
            experiences.addAll(userExperiences);
          }
        }
      }
      setState(() {
        allExperiences = experiences;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching all experiences: $e');
      }
    }
  }

  void _fetchUserExperiences() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('experiences').get();
      List<String> experiences =
      snapshot.docs.map((doc) => doc.data()['experience'] as String).toList();
      setState(() {
        myExperiences = experiences;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user experiences: $e');
      }
    }
  }

  Future<void> _addExperience(String experience) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('experiences').add({
        'experience': experience,
      });
      _experienceController.clear();
      _fetchUserExperiences();
    } catch (e) {
      if (kDebugMode) {
        print('Error adding experience: $e');
      }
    }
  }

  Future<void> _editExperience(String oldExperience, String newExperience) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).collection('experiences').get();
      String docId = '';
      snapshot.docs.forEach((doc) {
        if (doc.data()['experience'] == oldExperience) {
          docId = doc.id;
        }
      });
      if (docId.isNotEmpty) {
        await FirebaseFirestore.instance.collection('users').doc(uid).collection('experiences').doc(docId).update({
          'experience': newExperience,
        });
        _fetchUserExperiences();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error editing experience: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Experiences'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All Experiences'),
              Tab(text: 'My Experiences'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAllExperiencesTab(),
            _buildMyExperiencesTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildAllExperiencesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildAddExperienceDialog();
                },
              );
            },
            child: const Text('Share Your Experience'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: allExperiences.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(allExperiences[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyExperiencesTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildAddExperienceDialog();
                },
              );
            },
            child: const Text('Share Your Experience'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: myExperiences.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(myExperiences[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildEditExperienceDialog(myExperiences[index]);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddExperienceDialog() {
    return AlertDialog(
      title: const Text('Share Your Experience'),
      content: TextField(
        controller: _experienceController,
        decoration: const InputDecoration(
          labelText: 'Enter your experience',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _addExperience(_experienceController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  Widget _buildEditExperienceDialog(String experience) {
    _experienceController.text = experience;
    return AlertDialog(
      title: const Text('Edit Experience'),
      content: TextField(
        controller: _experienceController,
        decoration: const InputDecoration(
          labelText: 'Edit your experience',
          border: OutlineInputBorder(),
        ),
        maxLines: null,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _editExperience(experience, _experienceController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
