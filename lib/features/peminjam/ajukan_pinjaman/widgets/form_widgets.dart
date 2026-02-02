import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatTanggalIndonesia(DateTime date) {
  return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
}

const String roboto = 'Roboto';

class BuildTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final bool isReadOnly;
  final bool isDate;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const BuildTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.isReadOnly = false,
    this.isDate = false,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle()),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: roboto,
              color: Color.fromRGBO(72, 141, 117, 1),
              fontSize: 12,
            ),
            suffixIcon: icon != null
                ? Icon(
                    icon,
                    color: const Color.fromRGBO(72, 141, 117, 1),
                    size: 15,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            constraints: const BoxConstraints(minHeight: 36),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromRGBO(205, 238, 226, 1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromRGBO(72, 141, 117, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildDropdownField extends StatelessWidget {
  final String label;
  final String hint;
  final VoidCallback? onTap;

  const BuildDropdownField({
    super.key,
    required this.label,
    required this.hint,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: roboto,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Color.fromRGBO(49, 47, 52, 1),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            height: 36, // 🔥 SAMA dengan TextField
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: const Color.fromRGBO(205, 238, 226, 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: const TextStyle(
                      fontFamily: roboto,
                      fontSize: 12,
                      color: Color.fromRGBO(72, 141, 117, 1),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color.fromRGBO(72, 141, 117, 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
