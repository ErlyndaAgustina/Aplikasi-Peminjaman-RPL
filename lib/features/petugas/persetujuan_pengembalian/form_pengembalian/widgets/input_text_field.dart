import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final bool isDatePicker;
  final bool isTimePicker;

  const InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
    this.onTap,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.isDatePicker = false, // Default false
    this.isTimePicker = false,
  });

  @override
  Widget build(BuildContext context) {
    const String roboto = 'Roboto';
    // Logika pemilihan icon
    Widget? buildSuffixIcon() {
      if (isDatePicker) {
        return const Icon(
          Icons.calendar_today_outlined,
          size: 18,
          color: Color.fromRGBO(62, 159, 127, 1),
        );
      } else if (isTimePicker) {
        return const Icon(
          Icons.access_time, // Icon jam sesuai gambar
          size: 18,
          color: Color.fromRGBO(62, 159, 127, 1),
        );
      }
      return null;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: roboto,
            fontWeight: FontWeight.w600, // Lebih tebal sesuai gambar
            fontSize: 14,
            color: Color.fromRGBO(49, 47, 52, 1), // Warna teks judul input
          ),
        ),
        const SizedBox(height: 8), // Jarak sedikit lebih lebar
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: const TextStyle(
            fontFamily: roboto,
            color: Color.fromRGBO(
              72,
              141,
              117,
              1,
            ), // Warna teks input hijau sesuai gambar
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: roboto,
              color: Color.fromRGBO(72, 141, 117, 1,),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            // Border saat tidak fokus (Hijau Pucat)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), // Radius lebih besar
              borderSide: const BorderSide(
                color: Color.fromRGBO(205, 238, 226, 1),
                width: 1,
              ),
            ),
            // Border saat fokus
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color.fromRGBO(62, 159, 127, 1),
                width: 1.5,
              ),
            ),
            // Icon kalender sesuai gambar
            suffixIcon: buildSuffixIcon(),
          ),
        ),
      ],
    );
  }
}
