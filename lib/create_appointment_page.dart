import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  _CreateAppointmentPageState createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  String? _selectedDate;
  String? _selectedTime;
  TextEditingController patientName = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController note = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Appointment",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Patient Name Input
            TextField(
              decoration: const InputDecoration(
                labelText: "Patient Name",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              controller: patientName,
            ),
            const SizedBox(height: 20),

            // Date Picker
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate ?? "Select Date",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Icon(Icons.calendar_today_outlined),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Time Picker
            GestureDetector(
              onTap: _showTimePicker,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime ?? "Select Time",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: "Note",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              controller: note,
            ),
            const SizedBox(height: 20),

            // Purpose Input
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Purpose",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.note),
              ),
              controller: purpose,
            ),
            const SizedBox(height: 30),

            // Save Appointment Button
            ElevatedButton(
              onPressed: () async {
                await _saveAppointment();
                Get.offAllNamed('/dashboard');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Save Appointment",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate.toString().split(' ')[0];
      });
    }
  }

  void _showTimePicker() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime.format(context);
      });
    }
  }

  Future<void> _saveAppointment() async {
    var uuid = Uuid();
    if (patientName.text.isNotEmpty &&
        purpose.text.isNotEmpty &&
        _selectedDate != null &&
        _selectedTime != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final newAppointment = {
        'id': uuid.v1(),
        'name': patientName.text,
        'date': _selectedDate!,
        'time': _selectedTime!,
        'purpose': purpose.text,
        'note': note.text
      };

      List<String> existingAppointments =
          prefs.getStringList('appointments') ?? [];
      existingAppointments.add(jsonEncode(newAppointment));

      await prefs.setStringList('appointments', existingAppointments);
    } else {
      // Handle validation error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
    }
  }
}
