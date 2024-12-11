import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic appointment;

List<Map<String, dynamic>> appointments = [];

class AppointmentDetailsPage extends StatefulWidget {
  const AppointmentDetailsPage({super.key});

  @override
  State<AppointmentDetailsPage> createState() => _AppointmentDetailsPageState();
}

class _AppointmentDetailsPageState extends State<AppointmentDetailsPage> {
  double consultationFee = 50.0;
  double labTestFee = 0.0;
  double followUpFee = 20.0;
  double medication = 0.0;
  double diagnostic = 0.0;
  double seniorCitizen = 0.0;
  double loyaltyProgram = 0.0;
  double totalAmount = 0.0;

  void calculateCharges() {
    setState(() {
      double serviceFees = (consultationFee + labTestFee + followUpFee);
      totalAmount = (serviceFees + (medication + diagnostic)) -
          (seniorCitizen + loyaltyProgram);
    });
  }

  /// Load appointments from SharedPreferences
  void _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> storedAppointments = prefs.getStringList('appointments') ?? [];

    // Decode JSON strings to Map<String, dynamic>
    setState(() {
      appointments = storedAppointments.map((appointmentJson) {
        return Map<String, String>.from(jsonDecode(appointmentJson));
      }).toList();
    });
  }

  void removeAppointmentById(String idToRemove) async {
    appointments.removeWhere((appointment) => appointment['id'] == idToRemove);
    log(appointments.toString());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newAppointmentsList =
        appointments.map((appointment) => jsonEncode(appointment)).toList();
    await prefs.setStringList('appointments', newAppointmentsList);
  }

  @override
  void initState() {
    _loadAppointments();
    appointment = Get.arguments as Map<String, dynamic>;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Appointment Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Patient Name: " + appointment['name'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text("Date: ${appointment['date']}"),
              Text("Time: ${appointment['time']}"),
              Text("Purpose: ${appointment['purpose']}"),
              Text("Notes: ${appointment['note']}"),
              const Divider(height: 30, thickness: 1),
              const Text(
                "Charges Calculation",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text("Consultation Fee: \$${consultationFee.toStringAsFixed(2)}"),
              Text("Follow-up Fee: \$${followUpFee.toStringAsFixed(2)}"),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Lab Test Fees",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    labTestFee = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text(
                "Additional Fees",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Medication",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          medication = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Diagnostic",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          diagnostic = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "Discounts",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Senior Citizen",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          seniorCitizen = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Loyalty Program",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          loyaltyProgram = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateCharges,
                child: const Text("Calculate Charges"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                "Total Amount: \$${totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Divider(height: 30, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Edit Appointment screen
                      Get.toNamed('/editAppointment', arguments: appointment['id']);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black),
                    child: const Text("Edit Appointment"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logic to delete the appointment
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete Appointment"),
                          content: const Text(
                              "Are you sure you want to delete this appointment?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                log(appointment['id']);
                                removeAppointmentById(appointment['id']);

                                // Logic to remove the appointment
                                Get.back(); // Close dialog

                                Get.offAllNamed(
                                    "/dashboard"); // Return to previous page
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.black),
                    child: const Text("Delete Appointment"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
