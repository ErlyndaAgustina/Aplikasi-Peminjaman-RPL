import 'package:flutter/material.dart';

const String roboto = 'Roboto';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.suffixIcon,
    this.controller,
    this.onTap,
    required this.readOnly,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(
              fontFamily: roboto,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Color.fromRGBO(205, 238, 226, 1)),
            ),
            child: TextField(
              controller: widget.controller,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: const TextStyle(
                  fontFamily: roboto,
                  color: Color.fromRGBO(72, 141, 117, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.w600
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: InputBorder.none,
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
