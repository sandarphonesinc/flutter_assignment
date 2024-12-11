import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String textName;
  final Function onPressed;
  const CustomButton({
    super.key,
    required this.textName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: Text(
        textName,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
