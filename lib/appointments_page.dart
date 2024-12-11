import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Get.offAllNamed('/');
            },
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 20),
        ],
        title: const Text(
          "Upcoming Appointments",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: const AppointmentsBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/createAppointment');
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AppointmentsBody extends StatefulWidget {
  const AppointmentsBody({super.key});

  @override
  State<AppointmentsBody> createState() => _AppointmentsBodyState();
}

class _AppointmentsBodyState extends State<AppointmentsBody> {
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  /// Load appointments from SharedPreferences
  void _loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> storedAppointments =
        prefs.getStringList('appointments') ?? [];
    log('Loaded appointments: $storedAppointments');

    // Decode JSON strings to Map<String, dynamic>
    setState(() {
      appointments = storedAppointments.map((appointmentJson) {
        return Map<String, dynamic>.from(jsonDecode(appointmentJson));
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? const Center(child: Text("No Appointments Found"))
        : ListView.builder(
            itemCount: appointments.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(
                    appointment['name'] ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${appointment['date'] ?? 'N/A'} , ${appointment['time'] ?? 'N/A'} ",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "${appointment['purpose'] ?? 'N/A'}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    Get.toNamed(
                      '/appointmentDetails',
                      arguments: appointment,
                    );
                  },
                ),
              );
            },
          );
  }
}
