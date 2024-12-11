import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentEditPage extends StatefulWidget {
  const AppointmentEditPage({super.key});

  @override
  State<AppointmentEditPage> createState() => _AppointmentEditPageState();
}

class _AppointmentEditPageState extends State<AppointmentEditPage> {
  final _formKey = GlobalKey<FormState>();

  late String appointmentId;
  late Map<String, dynamic> appointment;
  late TextEditingController nameController;
  late TextEditingController dateController;
  late TextEditingController timeController;
  late TextEditingController purposeController;
  late TextEditingController noteController;

  List<Map<String, dynamic>> appointments = [];

  /// Load appointments from SharedPreferences and find the selected appointment
  Future<void> _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedAppointments = prefs.getStringList('appointments') ?? [];

    setState(() {
      appointments = storedAppointments.map((appointmentJson) {
        return Map<String, dynamic>.from(jsonDecode(appointmentJson));
      }).toList();

      appointment = appointments.firstWhere(
            (item) => item['id'] == appointmentId,
        orElse: () => {},
      );

      // Initialize the text controllers with the current appointment data
      nameController.text = appointment['name'] ?? '';
      dateController.text = appointment['date'] ?? '';
      timeController.text = appointment['time'] ?? '';
      purposeController.text = appointment['purpose'] ?? '';
      noteController.text = appointment['note'] ?? '';
    });
  }

  /// Save updated appointment back to SharedPreferences
  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      // Update the appointment details
      appointment['name'] = nameController.text;
      appointment['date'] = dateController.text;
      appointment['time'] = timeController.text;
      appointment['purpose'] = purposeController.text;
      appointment['note'] = noteController.text;

      // Update the list of appointments
      int index = appointments.indexWhere((item) => item['id'] == appointmentId);
      if (index != -1) {
        appointments[index] = appointment;
      }
    });

    // Save updated appointments to SharedPreferences
    List<String> updatedAppointments =
    appointments.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('appointments', updatedAppointments);

    log('Updated appointment: $appointment');

    // Navigate back to the details page
    Get.offAllNamed('/dashboard');
  }

  @override
  void initState() {
    super.initState();
    appointmentId = Get.arguments as String;

    nameController = TextEditingController();
    dateController = TextEditingController();
    timeController = TextEditingController();
    purposeController = TextEditingController();
    noteController = TextEditingController();

    _loadAppointments();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    purposeController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Appointment",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Patient Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: timeController,
                  decoration: const InputDecoration(labelText: 'Time'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the time';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the purpose';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Save Changes"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
