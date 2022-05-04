import 'package:flutter/material.dart';

InputDecoration textFieldDecoration(
    String hintText, TextEditingController controller) {
  return InputDecoration(
    suffixIcon: IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        controller.clear();
      },
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.black),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Colors.red),
    ),
    hintText: hintText,
    hintStyle: const TextStyle(color: Colors.grey),
  );
}
