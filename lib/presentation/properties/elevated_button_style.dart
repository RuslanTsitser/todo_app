import 'package:flutter/material.dart';

ButtonStyle elevatedButtonStyle(BuildContext context) {
  return ElevatedButton.styleFrom(
    minimumSize: Size(MediaQuery.of(context).size.width, 60),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );
}
