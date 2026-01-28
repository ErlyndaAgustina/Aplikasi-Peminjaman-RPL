import 'package:flutter/material.dart';

class LoginStyles {
  static OutlineInputBorder inputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color.fromRGBO(205, 238, 226, 0.49)),
    );
  }

  static OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color.fromRGBO(72, 141, 117, 1),
        width: 1.4,
      ),
    );
  }

  static Widget roleChip(String text, String roboto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 253, 240, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: roboto,
          fontSize: 11,
          color: const Color.fromRGBO(1, 85, 56, 1),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}