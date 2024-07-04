import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cravecrush/screens/home_screen.dart'; // Import your home page

class GetStartedPage extends StatefulWidget {
  final String uid;

  const GetStartedPage({Key? key, required this.uid}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  final List<Map<String, dynamic>> _userData = [
    {},
    {},
    {
      'reasons_started': [],
      'reasons_to_quit': [],
      'other_reason_started': '',
      'other_reason_quit': ''
    },
  ];

  void _submitForm(BuildContext context) {
    final form = _formKeys[_currentPageIndex].currentState;
    if (form != null && form.validate()) {
      form.save();

      if (_currentPageIndex == _formKeys.length - 1) {
        try {
          FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
            'first_name': _userData[0]['first_name'],
            'last_name': _userData[0]['last_name'],
            'age': _userData[0]['age'],
            'gender': _userData[0]['gender'],
            'num_cigarettes': _userData[1]['num_cigarettes'],
            'price_per_cigarette': _userData[1]['price_per_cigarette'],
            'reasons_started': _userData[2]['reasons_started'],
            'other_reason_started': _userData[2]['other_reason_started'],
            'reasons_to_quit': _userData[2]['reasons_to_quit'],
            'other_reason_quit': _userData[2]['other_reason_quit'],
          }).then((_) {
            print('User data saved to Firestore');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
            );
          }).catchError((error) {
            print('Failed to save user data: $error');
          });
        } catch (error) {
          print('Failed to save user data: $error');
        }
      } else {
        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
        setState(() {
          _currentPageIndex++;
        });
      }
    }
  }


  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Started'),
        leading: _currentPageIndex == 0
            ? null
            : IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousPage,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameSection(),
                _buildSmokingProfileSection(),
                _buildReasonsSection(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _submitForm(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Increase vertical padding
                minimumSize: const Size(double.infinity, 50.0), // Set minimum button size
              ),
              child: Text(
                _currentPageIndex == _formKeys.length - 1 ? 'Submit' : 'Next',
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameSection() {
    return Form(
      key: _formKeys[0],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onSaved: (value) => _userData[0]['first_name'] = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onSaved: (value) => _userData[0]['last_name'] = value ?? '',
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your age';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value!)) {
                  return 'Please enter a valid age';
                }
                return null;
              },
              onSaved: (value) => _userData[0]['age'] = int.tryParse(value ?? '') ?? 0,
            ),

            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other'].map((gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your gender';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _userData[0]['gender'] = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmokingProfileSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Form(
            key: _formKeys[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Smoking Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Number of cigarettes per day'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the number of cigarettes';
                    }
                    return null;
                  },
                  onSaved: (value) => _userData[1]['num_cigarettes'] = int.tryParse(value ?? '') ?? 0,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price per cigarette'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter the price per cigarette';
                    }
                    return null;
                  },
                  onSaved: (value) => _userData[1]['price_per_cigarette'] = double.tryParse(value ?? '') ?? 0.0,
                ),
                const SizedBox(height: 20),
                if (_userData[2]['times_to_smoke'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        children: List.generate(
                          _userData[2]['times_to_smoke'].length,
                              (index) => Chip(
                            label: Text(_userData[2]['times_to_smoke'][index]),
                            onDeleted: () {
                              setState(() {
                                _userData[2]['times_to_smoke'].removeAt(index);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()), // Spacer to push the "Previous" button to the bottom
          Padding(
            padding: const EdgeInsets.only(top: 8.0), // Add padding to push the "Previous" button down
            child: ElevatedButton(
              onPressed: _previousPage,
              child: const Text(
                'Previous',
                style: TextStyle(fontSize: 18.0), // Increase font size
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0), // Match vertical padding with the "Next" button
                minimumSize: const Size(double.infinity, 50.0), // Match minimum size with the "Next" button
                // Add other styling properties to match the "Next" button if needed
              ),
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildReasonsSection() {
    return Form(
      key: _formKeys[2],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reasons for Smoking & Quitting',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildMultiSelectFormField(
              title: 'Reasons started smoking',
              dataSource: [
                {"display": "Stress", "value": "Stress"},
                {"display": "Peer pressure", "value": "Peer pressure"},
                {"display": "Curiosity", "value": "Curiosity"},
                {"display": "Other", "value": "Other"},
              ],
              selectedValues: _userData[2]['reasons_started'],
              onChanged: (value) {
                setState(() {
                  _userData[2]['reasons_started'] = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_userData[2]['reasons_started'] != null && _userData[2]['reasons_started'].contains('Other'))
              TextFormField(
                decoration: const InputDecoration(labelText: 'Other reasons started smoking (if any)'),
                onSaved: (value) => _userData[2]['other_reason_started'] = value ?? '',
              ),
            const SizedBox(height: 20),
            _buildMultiSelectFormField(
              title: 'Reasons to quit smoking',
              dataSource: [
                {"display": "Health concerns", "value": "Health concerns"},
                {"display": "Financial reasons", "value": "Financial reasons"},
                {"display": "Social reasons", "value": "Social reasons"},
                {"display": "Other", "value": "Other"},
              ],
              selectedValues: _userData[2]['reasons_to_quit'],
              onChanged: (value) {
                setState(() {
                  _userData[2]['reasons_to_quit'] = value;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_userData[2]['reasons_to_quit'] != null && _userData[2]['reasons_to_quit'].contains('Other'))
              TextFormField(
                decoration: const InputDecoration(labelText: 'Other reasons to quit smoking (if any)'),
                onSaved: (value) => _userData[2]['other_reason_quit'] = value ?? '',
              ),
            const SizedBox(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _previousPage,
                  child: const Text(
                    'Previous',
                    style: TextStyle(fontSize: 18.0), // Increase font size
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0), // Match vertical padding with the "Next" button
                    minimumSize: const Size(double.infinity, 50.0), // Match minimum size with the "Next" button
                    // Add other styling properties to match the "Next" button if needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildMultiSelectFormField({
    required String title,
    required List<Map<String, dynamic>> dataSource,
    required List<dynamic> selectedValues,
    required Function(List<dynamic>) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          children: dataSource.map((item) {
            final value = item['value'];
            return FilterChip(
              label: Text(item['display']),
              selected: selectedValues.contains(value),
              onSelected: (selected) {
                List<dynamic> newSelectedValues = List.from(selectedValues);
                if (selected) {
                  newSelectedValues.add(value);
                } else {
                  newSelectedValues.remove(value);
                }
                onChanged(newSelectedValues);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}