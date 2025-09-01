import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CustomPostScreen extends StatefulWidget {
  @override
  _CustomPostScreenState createState() => _CustomPostScreenState();
}

class _CustomPostScreenState extends State<CustomPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? preferredDate;
  TimeOfDay? preferredTime;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _locationController.text = "${place.street}, ${place.locality}, ${place.administrativeArea}";
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        preferredDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        preferredTime = picked;
      });
    }
  }

  Future<void> _submitPost() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('custom_posts').add({
          'userId': user.uid,
          'serviceType': _serviceController.text,
          'description': _descriptionController.text,
          'budget': double.tryParse(_budgetController.text) ?? 0,
          'location': _locationController.text,
          'preferredDate': preferredDate,
          'preferredTime': preferredTime != null ? '${preferredTime!.hour}:${preferredTime!.minute}' : null,
          'status': 'open',
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Custom post created successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Custom Post'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Service Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(
                  labelText: 'What service do you need?',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., House Cleaning, Plumbing, etc.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Detailed Description',
                  border: OutlineInputBorder(),
                  hintText: 'Describe your requirements in detail',
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a detailed description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: _budgetController,
                decoration: InputDecoration(
                  labelText: 'Budget (₹)',
                  border: OutlineInputBorder(),
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your budget';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              Text('Location & Time', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Service Location',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: _getCurrentLocation,
                  ),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the service location';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Text('Preferred Date & Time (Optional)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(preferredDate == null
                          ? 'Select Date'
                          : '${preferredDate!.day}/${preferredDate!.month}/${preferredDate!.year}'),
                      leading: Icon(Icons.calendar_today, color: Colors.blue[600]),
                      onTap: _selectDate,
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
                      title: Text(preferredTime == null
                          ? 'Select Time'
                          : preferredTime!.format(context)),
                      leading: Icon(Icons.access_time, color: Colors.blue[600]),
                      onTap: _selectTime,
                      tileColor: Colors.grey[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  child: Text('Create Post', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}