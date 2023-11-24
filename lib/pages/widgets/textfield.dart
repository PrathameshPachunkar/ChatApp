import 'package:flutter/material.dart';

class chatTextField extends StatelessWidget {
  TextEditingController controller;
  chatTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        textAlign: TextAlign.center,
        controller: controller,
        decoration: InputDecoration(
            hintText: "Enter Your Message", border: OutlineInputBorder()),
      ),
    );
  }
}
