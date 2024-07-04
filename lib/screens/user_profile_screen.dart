import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late String _gender;
  late TextEditingController _numCigarettesController;
  late TextEditingController _pricePerCigaretteController;
  late List<String> _timesToSmoke;
  late List<String> _reasonsStarted;
  late String _otherReasonStarted;
  late List<String> _reasonsToQuit;
  late String _otherReasonQuit;

  bool _isEditing = false;
  late bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _ageController = TextEditingController();
    _gender = '';
    _numCigarettesController = TextEditingController();
    _pricePerCigaretteController = TextEditingController();
    _timesToSmoke = [];
    _reasonsStarted = [];
    _otherReasonStarted = '';
    _reasonsToQuit = [];
    _otherReasonQuit = '';

    // Fetch user data from Firestore and populate the fields
    _fetchUserData();
  }

  void _fetchUserData() async {
    DocumentSnapshot documentSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
    if (documentSnapshot.exists) {
      var data = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        _firstNameController.text = data['first_name'] ?? '';
        _lastNameController.text = data['last_name'] ?? '';
        _ageController.text = data['age'].toString() ?? '';
        _gender = data['gender'] ?? '';
        _numCigarettesController.text = data['num_cigarettes']?.toString() ?? '';
        _pricePerCigaretteController.text = data['price_per_cigarette']?.toString() ?? '';
        _timesToSmoke = List<String>.from(data['times_to_smoke'] ?? []);
        _reasonsStarted = List<String>.from(data['reasons_started'] ?? []);
        _otherReasonStarted = data['other_reason_started'] ?? '';
        _reasonsToQuit = List<String>.from(data['reasons_to_quit'] ?? []);
        _otherReasonQuit = data['other_reason_quit'] ?? '';
        _dataLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _numCigarettesController.dispose();
    _pricePerCigaretteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _dataLoaded
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField('First Name:', _firstNameController),
              _buildTextField('Last Name:', _lastNameController),
              _buildTextField('Age:', _ageController),
              _buildGenderDropdown(),
              _buildTextField('Number of cigarettes per day:', _numCigarettesController),
              _buildTextField('Price per cigarette:', _pricePerCigaretteController),
              _buildTimesToSmoke(),
              _buildReasonsStarted(),
              _buildOtherReasonStarted(),
              _buildReasonsToQuit(),
              _buildOtherReasonQuit(),
              const SizedBox(height: 32.0),
              if (!_isEditing)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: const Text('Edit'),
                ),
              if (_isEditing)
                ElevatedButton(
                  onPressed: () {
                    _updateProfile();
                  },
                  child: const Text('Update'),
                ),
            ],
          )
              : const CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
          ),
          enabled: _isEditing,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        DropdownButtonFormField<String>(
          value: _gender,
          items: ['Male', 'Female', 'Other'].map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: _isEditing
              ? (value) {
            setState(() {
              _gender = value ?? '';
            });
          }
              : null,
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildTimesToSmoke() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Times to smoke:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 8.0,
          children: _timesToSmoke.map((time) => Chip(label: Text(time))).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildReasonsStarted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reasons started smoking:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _reasonsStarted.map((reason) => Text(reason)).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildOtherReasonStarted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other reasons started smoking:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(_otherReasonStarted),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildReasonsToQuit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reasons to quit smoking:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _reasonsToQuit.map((reason) => Text(reason)).toList(),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildOtherReasonQuit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Other reasons to quit smoking:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(_otherReasonQuit),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void _updateProfile() {
    // Update user data in Firestore
    FirebaseFirestore.instance.collection('users').doc(widget.uid).update({
      'first_name': _firstNameController.text,
      'last_name': _lastNameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'gender': _gender,
      'num_cigarettes': int.tryParse(_numCigarettesController.text) ?? 0,
      'price_per_cigarette': double.tryParse(_pricePerCigaretteController.text) ?? 0.0,
    }).then((_) {
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated successfully'),
      ));
    }).catchError((error) {
      print('Failed to update profile: $error');
    });
  }
}
