import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Custom TextField Widget
import 'custom_widget/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            "Create Account",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: const RegisterBody(),
    );
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  Future<void> _registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        specialtyController.text.isEmpty ||
        contactController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    // Save data to shared preferences
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('specialty', specialtyController.text);
    await prefs.setString('contact', contactController.text);

    // Navigate to dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully!"),
        backgroundColor: Colors.green,
      ),
    );
    Get.offAllNamed('/dashboard'); // Redirect to the dashboard page
  }

  Future<void> _showRegisterData() async {
    final prefs = await SharedPreferences.getInstance();
    String? getName = await prefs.getString('name');
    String? getEmail = await prefs.getString('email');
    String? getPassword = await prefs.getString('password');
    String? getSpecialty = await prefs.getString('specialty');
    String? getContact = await prefs.getString("contact");

    Object accountInfo = {
      'name': getName,
      'email': getEmail,
      'password': getPassword,
      'specialty': getSpecialty,
      'contact': getContact
    };

    log(accountInfo.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            const Text(
              "Join as a Doctor",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            TextFieldGroup(
              nameController: nameController,
              emailController: emailController,
              passwordController: passwordController,
              specialtyController: specialtyController,
              contactController: contactController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _registerUser();
                await _showRegisterData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const RouteRegisterLink(),
          ],
        ),
      ),
    );
  }
}

class RouteRegisterLink extends StatelessWidget {
  const RouteRegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already Have an Account? ",
          style: TextStyle(fontSize: 15),
        ),
        TextButton(
          onPressed: () {
            Get.offAllNamed('/login');
          },
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }
}

class TextFieldGroup extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController specialtyController;
  final TextEditingController contactController;

  const TextFieldGroup({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.specialtyController,
    required this.contactController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          label: "Name",
          obscureText: false,
          controller: nameController,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Email",
          obscureText: false,
          controller: emailController,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Password",
          obscureText: true,
          controller: passwordController,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Specialty",
          obscureText: false,
          controller: specialtyController,
        ),
        const SizedBox(height: 20),
        CustomTextField(
          label: "Contact Information",
          obscureText: false,
          controller: contactController,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
