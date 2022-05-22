import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    minimumSize: const Size(double.maxFinite, 60),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
