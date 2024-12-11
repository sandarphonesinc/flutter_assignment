import 'package:flutter/material.dart';
import 'package:flutter_assignment/appointment_detail_page.dart';
import 'package:flutter_assignment/appointment_edit_page.dart';
import 'package:flutter_assignment/appointments_page.dart';
import 'package:flutter_assignment/create_appointment_page.dart';
import 'package:flutter_assignment/register_page.dart';
import 'package:get/get.dart';

import 'login_page.dart';

void main() {
  runApp(const MyApp());
}

final routes = [
  GetPage(name: '/', page: () => RegisterPage()),
  GetPage(name: '/login', page: () => LoginPage()),
  GetPage(name: '/dashboard', page: () => AppointmentsPage()),
  GetPage(name: '/createAppointment', page: () => CreateAppointmentPage()),
  GetPage(name: '/appointmentDetails', page: () => AppointmentDetailsPage()),
  GetPage(name: '/editAppointment', page:()=> AppointmentEditPage()),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: routes,
      home: RegisterPage(),
    );
  }
}
